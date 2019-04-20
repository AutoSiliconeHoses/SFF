$Host.UI.RawUI.WindowTitle = "eBay Zeroing"
$functions = {
  function CreateStockfile ($store, $supplier) {
      #Load Files into RAM
      $FileA = Import-CSV ("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreFiles\$store\"+$supplier+"-FULLSTOCK.csv")
      $FileB = Import-CSV ("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\"+$supplier+".txt") -delimiter "`t"

      #Setup Output file location
      $FileCPath = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Updated\ZEROING-" + $store + "-" + $supplier + ".csv"
      If (Test-Path $FileCPath) {del $FileCPath}
      "Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8),ItemID,SiteID,Quantity,Relationship,RelationshipDetails,CustomLabel" | Add-Content $FileCPath

      #Build File Data
      Foreach ($lineB in $FileB) {
        ForEach($lineA in $FileA) {
          #Header Check
          If ($lineA.Quantity -eq "" -and $lineA.Relationship -eq "") {$lastHeader = $lineA; $checked = $false}

          #Clean Sku ready for search
          $lineAClean = $lineA.CustomLabel -replace "[\|#].*",""

          #Convert TEX to TL
          If ($supplier -eq "tetrosyl"){
            $lineAClean = $lineAClean -replace "-TEX","-TL"
          }

          If ($lineAClean -match $lineB.sku) {
            $lineAClean -match $lineB.sku
            If ($lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)' -eq "") {
                If ($checked) {$lineC = "{0},{1},{2},{3},{4},{5},{6}`n" -f $lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lineA.ItemID,$lineA.SiteID,$lineB.quantity,$lineA.Relationship,$lineA.RelationshipDetails,$lineA.CustomLabel}
                If (!$checked) {
                  $lineC = "{0},{1},{2},{3},{4},{5},{6}`n{7},{8},{9},{10},{11},{12},{13}`n" -f $lastHeader.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lastHeader.ItemID,$lastHeader.SiteID,$lastHeader.Quantity,$lastHeader.Relationship,$lastHeader.RelationshipDetails,$lastHeader.CustomLabel,$lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lineA.ItemID,$lineA.SiteID,$lineB.quantity,$lineA.Relationship,$lineA.RelationshipDetails,$lineA.CustomLabel
                  $checked=$True
                }
            }
            #Ordinary Check
            If ($lineA.Relationship -eq "" -and $lineA.RelationshipDetails -eq "") {$lineC = "{0},{1},{2},{3},{4},{5},{6}`n" -f $lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lineA.ItemID,$lineA.SiteID,$lineB.quantity,$lineA.Relationship,$lineA.RelationshipDetails,$lineA.CustomLabel}

            #Add to file data
            $FileC += $lineC
          }
        }
      }
    #Add Data to File
    If (!$FileC) {
      Write-Host "No matches"
      del $FileCPath
    }
    If ($FileC) {
      Write-Host $FileC.Length + " matches found"
      $FileC | Add-Content $FileCPath
    }
  }
}

$keepPath = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\Keep"
$zeroPath = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\Zeroing"

mkdir $keepPath
gci "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock" -filter "*.txt" |
  % {mv $_.fullname $keepPath}
gci $zeroPath |
  % {mv $_.fullname "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock"}
del $zeroPath

$StoreList = Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreList.csv"
$AmazonStocks = gci "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock" -filter "*.txt"

Foreach ($store in $StoreList) {
  $store.'Store Email'
  Foreach ($amazonFile in $AmazonStocks) {
    $dir = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreFiles\"+$store.'Store Code'+"\"+$amazonFile.basename+"-FULLSTOCK.csv"
    If (Test-Path $dir) {
      "`tProcessing " + $amazonFile.basename
      Start-Job -InitializationScript $functions -name ($jobname) -ScriptBlock {
        $store = $args[0]
        $amazonFile = $args[1]
        $jobname = "ZEROING-" + $store.'Store Code'+"-"+$amazonFile
        $filepath = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Updated\" + $jobname + ".csv"

        CreateStockfile $store.'Store Code' $amazonFile
        If (Test-Path ($filepath)) {
          # Set up arguments for curl
          $result = '"\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\UploadResults\'+ $jobname + '-RESULT.html"'
          $token = '"token=' + $store.Token + '"'
          $file = '"file=@' + $filepath + '"'

          # Concatonate command with arguments and invoke
          $command = "curl.exe -k -o " + $result + " -F " + $token + " -F " + $file + " https://bulksell.ebay.com/ws/eBayISAPI.dll?FileExchangeUpload"
          iex $command
          "$jobname Complete"
        }
        If (!Test-Path ($filepath)) {
          "$jobname results empty"
        }
      } -ArgumentList $store,$amazonFile.basename | Out-Null
    }
  }
}

"Waiting for completion..."
Wait-Job * -timeout 1800 | Out-Null

"Deleting used Stock Files"
del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\*.txt" -ErrorAction SilentlyContinue

gci $keepPath -ErrorAction SilentlyContinue |
  % {mv $_.fullname "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock" -ErrorAction SilentlyContinue} -ErrorAction SilentlyContinue
del $keepPath

"Done"
