Get-ChildItem -Path "Z:\Stock File Fetcher\StockFeed\GUI\Output" -Include * -File -Recurse | foreach { $_.Delete()}
