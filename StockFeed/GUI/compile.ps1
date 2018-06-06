Z:
cd "Z:\Stock File Fetcher\Upload"

$condition = (Get-Location) -like "Z:\Stock File Fetcher\Upload"
If ($condition) {
  "Combining files"
  gc *.txt | sc amazon.txt
  Get-ChildItem "Z:\Stock File Fetcher\Upload" -Filter *.txt | Foreach-Object {
      If ($_ -notlike "amazon.txt") {del $_}
  }

  $message = "Replacing argreplace with " + $args[0]
  $message
  (cat amazon.txt).replace("argreplace", $args[0]) | sc amazon.txt

  "Removing duplicates"
  # gc amazon.txt | sort-object | get-unique | sc amazon.txt

  "Cleaning file"
  (cat 'Z:\Stock File Fetcher\Upload\amazon.txt')| ?{$_.Trim(" `t")} | sc 'Z:\Stock File Fetcher\Upload\amazon.txt'

  "Adding .Header"
  copy "Z:\Stock File Fetcher\StockFeed\GUI\.header.txt" "Z:\Stock File Fetcher\Upload"
  Add-Content -Path "Z:\Stock File Fetcher\Upload\.header.txt" -Value (gc "Z:\Stock File Fetcher\Upload\amazon.txt")
  del amazon.txt
  Rename-Item .header.txt amazon.txt

  "Finished Compiling"
}

If (!$Condition) {
  Throw 'Directory not correct, please check your drives.'
  PAUSE
}
