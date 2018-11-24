$open = Get-Process "Amazon Merchant Transport Utility"
If ($open) {"AMTU is still running"; EXIT}
If (!$open) {
    "AMTU is closed, opening"
    . "C:\Program Files\AMTU\Amazon Merchant Transport Utility.exe"
}