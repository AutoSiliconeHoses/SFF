Z:
cd "Z:\Stock File Fetcher\Upload"

$condition = (Get-Location) -like "Z:\Stock File Fetcher\Upload"
If ($condition) {
  If (Test-Path -Path amazon.txt) {del amazon.txt}
  cat *.txt | sc amazon.txt
  mkdir "Z:\Stock File Fetcher\Upload\Amazon"
  move amazon.txt "Z:\Stock File Fetcher\Upload\Amazon" -force
  del *.txt
  cd "Z:\Stock File Fetcher\Upload\Amazon"
  move amazon.txt "Z:\Stock File Fetcher\Upload"
  If (Test-path -Path amazon.txt) {del amazon.txt}
  cd "Z:\Stock File Fetcher\Upload"
  rmdir "Z:\Stock File Fetcher\Upload\Amazon"
  (cat amazon.txt).replace("argreplace", $args[0]) | sc amazon.txt
  "Finished Compilation"
}
If (!$Condition) {
  Throw 'Directory not correct, please check your drives.'
  PAUSE
}
