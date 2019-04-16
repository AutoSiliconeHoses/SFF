#CSV file headers = stock_no	primary	secondary	tertiary	cstock	direct
#NOTE: Tab-delimited
#sku = IF('\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts\[biztools.csv]biztools'!A2<>"",'\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts\[biztools.csv]biztools'!A2&"-BZ")
#quanity = IF('\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts\[biztools.csv]biztools'!B2<>"",IF('\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts\[biztools.csv]biztools'!B2<0,0,IF('\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts\[biztools.csv]biztools'!B2>20,20,'\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts\[biztools.csv]biztools'!B2)),0)

function cap ([int]$value) {
  If ($value -gt 20) {
    return 20
  } else {
    return $value
  }
}

Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts\biztools.csv" |
  Select @{n='sku';e={$_.stock_no + '-BZ'}},
  price,minimum-seller-allowed-price,maximum-seller-allowed-price,
  @{n='quantity'; e={cap $_.primary}},
  @{n='leadtime-to-ship'; e={'argreplace'}} |
  ConvertTo-Csv -Delimiter "`t" -NoTypeInformation |
  % {$_.Replace('"','')} |
  Out-File "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\biztools.txt"
