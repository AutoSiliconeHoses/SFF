Z:
cd "Z:\Stock File Fetcher\Upload"
$condition = (Get-Location) -like "Z:\Stock File Fetcher\Upload"
If ($condition) {
  If (Test-Path -Path amazon.txt) {del amazon.txt}
  cat *.txt | sc amazon.txt
  mkdir "Z:\Stock File Fetcher\Upload\Amazon"
  move amazon.txt "Z:\Stock File Fetcher\Upload\Amazon"
  del *.txt
  cd "Z:\Stock File Fetcher\Upload\Amazon"
  move amazon.txt "Z:\Stock File Fetcher\Upload"
  cd "Z:\Stock File Fetcher\Upload"
  rmdir "Z:\Stock File Fetcher\Upload\Amazon"
  "Finished Compilation"
}
If (!$Condition) {
  Throw 'Directory not correct, please check your drives.'
  PAUSE
}
