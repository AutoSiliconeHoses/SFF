Z:
cd "Z:\Stock File Fetcher\Upload"

$condition = (Get-Location) -like "Z:\Stock File Fetcher\Upload"
If ($condition) {
  $lead = $args[0]
  $message = "Replacing argreplace with " + $lead
  $message
  Get-ChildItem "Z:\Stock File Fetcher\Upload" -Filter *.txt |
  Foreach-Object {
    $_
    (gc $_).replace("argreplace", $lead) | sc $_
  }

  "Cleaning file"
  Get-ChildItem "Z:\Stock File Fetcher\Upload" -Filter *.txt |
  Foreach-Object {
    $_
    (cat $_)| ?{$_.Trim(" `t")} | sc $_
  }

  "Finished Compiling"
}

If (!$Condition) {
  Throw 'Directory not correct, please check your drives.'
  PAUSE
}
