#NOTE: No data is being added, just sits there.
#TODO: Try working on a supplier by supplier basis. Essentially loads of micro-processes

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
function CreateStockfile ($store) {
  #Load Files into RAM
  $FileA = Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreFiles\$store.csv" | Sort-Object CustomLabel

  #Setup Output file location
  $FileCPath = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Updated\" + $store + ".csv"
  If (Test-Path $FileCPath) {del $FileCPath}
  "Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8),ItemID,SiteID,Quantity,Relationship,RelationshipDetails,CustomLabel" | Add-Content $FileCPath

  #Build File Data
  ForEach($lineA in $FileA) {
      BinarySearch -YourOrderedArray $AmazonStock.sku -ItemSearched $lineA.CustomLabel
      If ($ItemFound -eq $True) {
          $lineC = "{0},{1},{2},{3},{4},{5},{6}" -f $lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lineA.ItemID,$lineA.SiteID,$AmazonStock[$MiddlePoint].quantity,$lineA.Relationship,$lineA.RelationshipDetails,$lineA.CustomLabel
          #$FileC += $lineC
          $lineC | Add-Content $FileCPath
      }
  }
  #Add Data to File
  #$FileC | Add-Content $FileCPath
}

"Creating Sorted Combined File"
#NOTE: Reliable, but slow
If (Test-Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\Fullstock\fullstock.csv") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\Fullstock\fullstock.csv"}
Import-CSV (gci "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock" -filter "*.txt").Fullname -delimiter "`t" | Sort-Object sku | Export-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\Fullstock\fullstock.csv" -NoTypeInformation
$AmazonStock = Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Stock\Fullstock\fullstock.csv" -delimiter "`t" | Sort-Object sku

$StoreList = Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreList.csv" | Select-Object -skip 1
Foreach ($store in $StoreList) {
  $store.'Store Email'
  #Start-Job -Name ($store.'Store Code') -Scriptblock {
    #TODO: Put into a Job with a wait at the end
    "`tProcessing..."
    CreateStockfile $store.'Store Code'

    $result = '"\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\UploadResults\' + $store.'Store Code' + '.csv"'
    $token = '"token=' + $store.Token + '"'
    $file = '"file=@' + $store.'Store Code' + '.csv"'
    "`tUploading..."
    #curl.exe -k -o $result -F $token -F $file https://bulksell.ebay.com/ws/eBayISAPI.dll?FileExchangeUpload
  #} | Out-Null
}

"Waiting for completion..."
Wait-Job * -timeout 900 | Out-Null
"Done"
