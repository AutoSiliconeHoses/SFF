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
    $FileA = Import-CSV ("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreFiles\$store\"+$supplier+"-FULLSTOCK.csv") | Sort-Object CustomLabel
    $FileB = Import-CSV ("\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\"+$supplier+".txt") -delimiter "`t" | Sort-Object sku

    #Setup Output file location
    $FileCPath = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Updated\" + $store + "-" + $supplier + ".csv"
    If (Test-Path $FileCPath) {del $FileCPath}
    "Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8),ItemID,SiteID,Quantity,Relationship,RelationshipDetails,CustomLabel" | Add-Content $FileCPath

    #Build File Data
    ForEach($lineA in $FileA) {
        BinarySearch -YourOrderedArray $FileB.sku -ItemSearched $lineA.CustomLabel
        If ($ItemFound -eq $True) {
            $lineC = "{0},{1},{2},{3},{4},{5},{6}`n" -f $lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lineA.ItemID,$lineA.SiteID,$FileB[$MiddlePoint].quantity,$lineA.Relationship,$lineA.RelationshipDetails,$lineA.CustomLabel
            $FileC += $lineC
            # $lineC | Add-Content $FileCPath
        }
    }
    #Add Data to File
    $FileC | Add-Content $FileCPath
  }
}

$StoreList = Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreList.csv" | Select-Object -skip 1
$AmazonStocks = gci "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock" -filter "*.txt"

Foreach ($amazonFile in $AmazonStocks) {
  Foreach ($store in $StoreList) {
    $store.'Store Email'
    $dir = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreFiles\"+$store.'Store Code'+"\"+$amazonFile.basename+"-FULLSTOCK.csv"
    If (Test-Path $dir) {
      "`tProcessing " + $amazonFile.basename
      Start-Job -InitializationScript $functions -name ($store.'Store Code'+"-"+$amazonFile.basename) -ScriptBlock {
        $store = $args[0]
        $amazonFile = $args[1]
        CreateStockfile $store.'Store Code' $amazonFile
        $result = '"\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\UploadResults\'+ $store.'Store Code' + "-" + $amazonFile +'-RESULT.txt"'
        $token = '"token=' + $store.Token + '"'
        $file = '"file=@' + "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Updated\" + $store.'Store Code' + "-" + $amazonFile + '.csv"'
        #"`tUploading..."
        #curl.exe -k -o $result -F $token -F $file https://bulksell.ebay.com/ws/eBayISAPI.dll?FileExchangeUpload
      } -ArgumentList $store,$amazonFile.basename | Out-Null
    }
  }
}

"Waiting for completion..."
Wait-Job * -timeout 900 | Out-Null
"Done"
