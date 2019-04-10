Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\Scripts\FPS_STOCK.csv" |
  Select @{n='sku';e={$_.'Product Code' + '-' + $_.'MFG Code' + '-FPS'}},price,minimum-seller-allowed-price,maximum-seller-allowed-price,@{n='quantity'; e={$_.'Free Stock Available Flag'}},@{n='leadtime-to-ship'; e={'argreplace'}} |
  ConvertTo-Csv -Delimiter "`t" -NoTypeInformation |
  % {$_.Replace('"','')} |
  Out-File "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\FPSFeed\fps_stock.txt"
