$FileA = Import-CSV "C:\Users\sales-20\Desktop\PS Lookup\FileA.txt" -delimiter "`t"
$FileB = Import-CSV "C:\Users\sales-20\Desktop\PS Lookup\FileB.txt" -delimiter "`t"

$FileName = "C:\Users\sales-20\Desktop\PS Lookup\FileC.txt"
If (Test-Path $FileName) {del $FileName}

$List = ""

$FileA | % {
  $AList = $_
  $FileB | % {
    If ($AList.ColumnC -eq $_.Column1) {
      $List += $AList.ColumnC + "`t" + $_.Column2 + "`t" + $_.Column3
    }
  }
}

$List
$List | sc $FileName
