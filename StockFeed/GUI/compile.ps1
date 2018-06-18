Z:
cd "Z:\Stock File Fetcher\Upload"

$condition = (Get-Location) -like "Z:\Stock File Fetcher\Upload"
If ($condition) {
  # "Combining files"
  # gc *.txt | sc amazon.txt
  # Get-ChildItem "Z:\Stock File Fetcher\Upload" -Filter *.txt | Foreach-Object {
  #     If ($_ -notlike "amazon.txt") {del $_}
  # }
  $lead = $args[0]
  $message = "Replacing argreplace with " + $lead
  $message
  Get-ChildItem "Z:\Stock File Fetcher\Upload" -Filter *.txt |
  Foreach-Object {
    $_
    (gc $_).replace("argreplace", $lead) | sc $_
  }
  "Removing duplicates"
  Get-ChildItem "Z:\Stock File Fetcher\Upload" -Filter *.txt |
  Foreach-Object {
    $_
    gc $_ | sort-object | get-unique | sc $_
  }

  "Cleaning file"
  Get-ChildItem "Z:\Stock File Fetcher\Upload" -Filter *.txt |
  Foreach-Object {
    $_
    (cat $_)| ?{$_.Trim(" `t")} | sc $_
  }
  # "Adding .Header"
  # copy "Z:\Stock File Fetcher\StockFeed\GUI\.header.txt" "Z:\Stock File Fetcher\Upload"
  # Add-Content -Path "Z:\Stock File Fetcher\Upload\.header.txt" -Value (gc "Z:\Stock File Fetcher\Upload\amazon.txt")
  # del amazon.txt
  # Rename-Item .header.txt amazon.txt

  "Finished Compiling"
}

If (!$Condition) {
  Throw 'Directory not correct, please check your drives.'
  PAUSE
}
