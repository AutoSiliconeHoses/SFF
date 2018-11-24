$Yto20 = @{
  "Y" = "20";
  "N" = "0"
}

Import-Csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperPrimeFeed\Scripts\draperprime.csv" | % {
        $quantity = $Yto20[$_."In Stock"]
        ($_."Stock Item") -f "{0:00000}"
    } | Select sku,price,minimum-seller-allowed-price,maximum-seller-allowed-price,quantity,leadtime-to-ship |
    Export-Csv "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperPrimeFeed\Scripts\draperprimeRESULT.csv" -NoTypeInformation
