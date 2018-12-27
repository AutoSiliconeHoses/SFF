#TODO: Get Gib to use the folders with the names
#TODO: See how some commands feel about the CSV headers

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
  $FileB = Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Fullstock\fullstock.csv" -delimiter "`t" | Sort-Object sku

  #Setup Output file location
  $FileCPath = "\\DISKSTATION\Feeds\Stock File Fetcher\Upload\eBay\Updated\" + $storeName
  If (Test-Path $FileCPath) {del $FileCPath}
  "Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8),ItemID,SiteID,Quantity,Relationship,RelationshipDetails,CustomLabel" | Add-Content $FileCPath

  #Build File Data
  ForEach($lineA in $FileA) {
      BinarySearch -YourOrderedArray $FileB.sku -ItemSearched $lineA.CustomLabel
      If ($ItemFound -eq $True) {
          $lineC = "{0},{1},{2},{3},{4},{5},{6}`n" -f $lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lineA.ItemID,$lineA.SiteID,$FileB[$MiddlePoint].quantity,$lineA.Relationship,$lineA.RelationshipDetails,$lineA.CustomLabel
          $FileC += $lineC
      }
  }
  #Add Data to File
  $FileC | Add-Content $FileCPath
}

If (Test-Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Fullstock\fullstock.csv") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Fullstock\fullstock.csv"}
Import-CSV (gci "\\DISKSTATION\Feeds\Stock File Fetcher\Upload" -filter "*.txt").Fullname -delimiter "`t" | Sort-Object sku | Export-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Fullstock\fullstock.csv" -NoTypeInformation

$StoreList = Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\StoreList.csv" | Select-Object -skip 1
Foreach ($store in $StoreList) {
  $store.'Store Email'
  CreateStockfile $store.'Store Code'

  $result = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\eBay\Results\$store.'Store Code'.csv"
  curl -k -o $result -F "token=$store.Token" -F "file=@$store.csv" https://bulksell.ebay.com/ws/eBayISAPI.dll?FileExchangeUpload
}
