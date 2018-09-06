$Yto20 = @{
  "Y" = "20";
  "N" = "0"
}

Import-Csv "C:\Users\Bubbl\Downloads\DPP\draperprime.csv" |
    Select-Object *, @{ Name = "quantity"; Expression = { $Yto20[$_."In Stock"] } }, @{Name = "sku"; Expression = { $_."Stock Item".ToString("00000") }|
    Select sku,price,minimum-seller-allowed-price,maximum-seller-allowed-price,quantity,leadtime-to-ship |
    Export-Csv "C:\Users\Bubbl\Downloads\DPP\draperprimeRESULT.csv" -NoTypeInformation

