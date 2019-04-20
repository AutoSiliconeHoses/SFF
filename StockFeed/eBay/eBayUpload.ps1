$functions = {
  function BinarySearch {
     Param ($YourOrderedArray, $ItemSearched)
     [int] $LowIndex = 0
     [int] $HigIndex = $YourOrderedArray.length - 1
     while ($LowIndex -le $HigIndex) {
        [int]$script:MiddlePoint = $LowIndex + (($HigIndex - $LowIndex) / 2)
        $InspectedValue = $YourOrderedArray[$script:MiddlePoint]
        If ($InspectedValue -lt $ItemSearched) {
            $LowIndex = $script:MiddlePoint + 1
        }
        Elseif ($InspectedValue -gt $ItemSearched) {
            $HigIndex = $script:MiddlePoint - 1
        }
        Else {
            $script:ItemFound = $True
            return
        }
      }
      $script:ItemFound = $False
      $script:MiddlePoint = -($LowIndex + 1)
      return
  }

  function CreateStockfile ($store, $supplier) {
      #Load Files into RAM
      $FileA = Import-CSV ("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreFiles\$store\"+$supplier+"-FULLSTOCK.csv")
      $FileB = Import-CSV ("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\"+$supplier+".txt") -delimiter "`t" | Sort-Object sku

      #Setup Output file location
      $FileCPath = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Updated\" + $store + "-" + $supplier + ".csv"
      If (Test-Path $FileCPath) {del $FileCPath}
      "Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8),ItemID,SiteID,Quantity,Relationship,RelationshipDetails,CustomLabel" | Add-Content $FileCPath

      #Build File Data
      ForEach($lineA in $FileA) {
        #Header Check
        If ($lineA.Quantity -eq "" -and $lineA.Relationship -eq "") {$lastHeader = $lineA; $checked = $false}

        #Clean Sku ready for search
        $lineAClean = $lineA.CustomLabel -replace "[\|#].*",""

        #Convert TEX to TL
        If ($supplier -eq "tetrosyl"){
          $lineAClean = $lineAClean -replace "-TEX","-TL"
        }
        BinarySearch -YourOrderedArray $FileB.sku -ItemSearched $lineAClean
        If ($ItemFound -eq $True) {
          #Drop-down Check
          If ($lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)' -eq "") {
              If ($checked) {$lineC = "{0},{1},{2},{3},{4},{5},{6}`n" -f $lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lineA.ItemID,$lineA.SiteID,$FileB[$MiddlePoint].quantity,$lineA.Relationship,$lineA.RelationshipDetails,$lineA.CustomLabel}
              If (!$checked) {
                $lineC = "{0},{1},{2},{3},{4},{5},{6}`n{7},{8},{9},{10},{11},{12},{13}`n" -f $lastHeader.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lastHeader.ItemID,$lastHeader.SiteID,$lastHeader.Quantity,$lastHeader.Relationship,$lastHeader.RelationshipDetails,$lastHeader.CustomLabel,$lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lineA.ItemID,$lineA.SiteID,$FileB[$MiddlePoint].quantity,$lineA.Relationship,$lineA.RelationshipDetails,$lineA.CustomLabel
                $checked=$True
              }
          }
          #Ordinary Check
          If ($lineA.Relationship -eq "" -and $lineA.RelationshipDetails -eq "") {$lineC = "{0},{1},{2},{3},{4},{5},{6}`n" -f $lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lineA.ItemID,$lineA.SiteID,$FileB[$MiddlePoint].quantity,$lineA.Relationship,$lineA.RelationshipDetails,$lineA.CustomLabel}

          #Add to file data
          $FileC += $lineC
          # $lineC | Add-Content $FileCPath
        }
    }
    #Add Data to File
    $FileC | Add-Content $FileCPath
  }

  function alter ($store) {
    #Load Files into RAM
    $FileA = Import-CSV ("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreFiles\" + $store + "\ash-FULLSTOCK.csv")
    $FileB = Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv"

    #Setup Output file location
    $FileCPath = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Updated\" + $store + "-ash.csv"
    If (Test-Path $FileCPath) {del $FileCPath}
    "Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8),ItemID,SiteID,Quantity,Relationship,RelationshipDetails,CustomLabel" | Add-Content $FileCPath

    $count = 0
    #Build File Data
    ForEach($lineA in $FileA) {
      $match = $FALSE
      Foreach ($lineB in $FileB) {
        #Clean Sku ready for search
        $lineAClean = $lineA.CustomLabel -replace "[\|#].*",""

        #Convert TEX to TL
        If ($supplier -eq "tetrosyl"){
          $lineAClean = $lineAClean -replace "-TEX","-TL"
        }

        If ($lineAClean -match $lineB.sku) {
          $lineC = "{0},{1},{2},{3},{4},{5},{6}`n" -f $lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lineA.ItemID,$lineA.SiteID,$lineB.qty,$lineA.Relationship,$lineA.RelationshipDetails,$lineA.CustomLabel
          $match = $TRUE
          $count++
          break
        }
      }
      If (!$match) {
        $lineC = "{0},{1},{2},{3},{4},{5},{6}`n" -f $lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lineA.ItemID,$lineA.SiteID,$lineA.Quantity,$lineA.Relationship,$lineA.RelationshipDetails,$lineA.CustomLabel
      }
      $FileC += $lineC
    }
    #Add Data to File
    Write-Host "$count alterations made"
    $FileC | Add-Content $FileCPath
  }
}

# The most horrid way of doing FPS known to man
gci "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock" -filter "*.txt" |
    % {
        if ($_.name -match "fps_stock.txt") {$fpsShef = $true}
        if ($_.name -match "fps_leeds.txt") {$fpsLeeds = $true}
    }

if ($fpsShef -and $fpsLeeds) {
    $fpsShef = gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\fps_stock.txt"
    $fpsLeeds = gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\fps_leeds.txt" | ? {$_.readcount -gt 1}
    $fpsShef,$fpsLeeds | sc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\fps.txt"
}
if (!($fpsShef -and $fpsLeeds) -and $fpsShef) {
     Rename-Item "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\fps_stock.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\fps.txt"
}
if (!($fpsShef -and $fpsLeeds) -and $fpsLeeds) {
     Rename-Item "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\fps_leeds.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\fps.txt"
}

$StoreList = Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreList.csv" | ? {$_.Enabled -eq "TRUE"}
$AmazonStocks = gci "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock" -filter "*.txt"

Foreach ($store in $StoreList) {
  $store.'Store Email'
  Foreach ($amazonFile in $AmazonStocks) {
    $dir = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreFiles\"+$store.'Store Code'+"\"+$amazonFile.basename+"-FULLSTOCK.csv"
    If (Test-Path $dir) {
      "`tProcessing " + $amazonFile.basename
      Start-Job -InitializationScript $functions -name ($store.'Store Code'+"-"+$amazonFile.basename) -ScriptBlock {
        $store = $args[0]
        $amazonFile = $args[1]
        CreateStockfile $store.'Store Code' $amazonFile

        # Set up arguments for curl
        $result = '"\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\UploadResults\'+ $store.'Store Code' + "-" + $amazonFile +'-RESULT.html"'
        $token = '"token=' + $store.Token + '"'
        $file = '"file=@' + "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Updated\" + $store.'Store Code' + "-" + $amazonFile + '.csv"'

        # Concatonate command with arguments and invoke
        $command = "curl.exe -k -o " + $result + " -F " + $token + " -F " + $file + " https://bulksell.ebay.com/ws/eBayISAPI.dll?FileExchangeUpload"
        iex $command
      } -ArgumentList $store,$amazonFile.basename | Out-Null
    }
  }
  $replenish = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreFiles\"+$store.'Store Code'+"\ash-FULLSTOCK.csv"
  If (Test-Path $replenish) {
    "`tCreating ASH file"
    Start-Job -InitializationScript $functions -name ($store.'Store Code'+"-ash") -ScriptBlock {
      #TODO: Create new file with alterations
      $store = $args[0]
      alter $store.'Store Code'

      # Set up arguments for curl
      $result = '"\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\UploadResults\'+ $store.'Store Code' + '-ash-RESULT.html"'
      $token = '"token=' + $store.Token + '"'
      #TODO: Change this path
      $file = '"file=@' + "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Updated\" + $store.'Store Code' + '-ash.csv"'

      # Concatonate command with arguments and invoke
      $command = "curl.exe -k -o " + $result + " -F " + $token + " -F " + $file + " https://bulksell.ebay.com/ws/eBayISAPI.dll?FileExchangeUpload"
      iex $command
    } -ArgumentList $store | Out-Null
  }
}

"Waiting for completion..."
Wait-Job * -timeout 43200 | Out-Null

"Deleting used Stock Files"
# del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\*.txt" -ErrorAction SilentlyContinue

"Done"
