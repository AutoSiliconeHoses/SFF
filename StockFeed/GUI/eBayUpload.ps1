function BinarySearch {
   Param ($YourOrderedArray, $ItemSearched)
   [int] $LowIndex = 0
   [int] $HigIndex = $YourOrderedArray.length - 1
   while ($LowIndex -le $HigIndex) {
#     [int]$script:MiddlePoint = ($LowIndex + $HigIndex) / 2
      [int]$script:MiddlePoint = $LowIndex + (($HigIndex - $LowIndex) / 2)
      $InspectedValue = $YourOrderedArray[$script:MiddlePoint]
      If ($InspectedValue -lt $ItemSearched) {
          $LowIndex = $script:MiddlePoint + 1
      }
      Elseif ($InspectedValue -gt $ItemSearched) {
          $HigIndex = $script:MiddlePoint - 1
      }
      Else {
          $script:ItemFound = $True
          return
      }
    }
    $script:ItemFound = $False
    $script:MiddlePoint = -($LowIndex + 1)
    return
}

#Load Files into RAM
$FileA = Import-CSV "C:\Users\sales-20\Desktop\PS Lookup\HH-FULLSTOCK.csv" | Sort-Object CustomLabel
$FileB = Import-CSV "C:\Users\sales-20\Desktop\PS Lookup\homehardware.txt" -delimiter "`t" | Sort-Object sku

#Setup Output file location
$FileCPath = "C:\Users\sales-20\Desktop\PS Lookup\FileC.csv"
If (Test-Path $FileCPath) {del $FileCPath}
 "Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8),ItemID,SiteID,Quantity,Relationship,RelationshipDetails,CustomLabel" | Add-Content $FileCPath

$i = 0
Start-Job {sleep 3}
Wait-Job *
ForEach($lineA in $FileA) {
    BinarySearch -YourOrderedArray $FileB.sku -ItemSearched $lineA.CustomLabel
    If ($ItemFound -eq $True) {
        #"Found at position $MiddlePoint"
        $lineC = "{0},{1},{2},{3},{4},{5},{6}`n" -f $lineA.'Action(SiteID=UK|Country=GB|Currency=GBP|Version=585|CC=UTF-8)',$lineA.ItemID,$lineA.SiteID,$FileB[$MiddlePoint].quantity,$lineA.Relationship,$lineA.RelationshipDetails,$lineA.CustomLabel
        $FileC += $lineC
        #$lineC | Add-Content $FileCPath
    }
}
$FileC | Add-Content $FileCPath
