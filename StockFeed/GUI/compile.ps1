cd "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
$lead = $args[0]
$message = "Replacing argreplace with " + $lead
$message
Get-ChildItem "\\DISKSTATION\Feeds\Stock File Fetcher\Upload" -Filter *.txt |
Foreach-Object {
  $_
  (gc $_).replace("argreplace", $lead) | sc $_
}

"Cleaning file"
Get-ChildItem "\\DISKSTATION\Feeds\Stock File Fetcher\Upload" -Filter *.txt |
Foreach-Object {
  $_
  (gc $_)| ?{$_.Trim(" `t")} | sc $_
}

"Finished Compiling"
