. "\\Diskstation\Feeds\SDK\Scripts\PowerBullet.ps1"

$check = Test-Path -Path '\\STOCKMACHINE\AmazonTransport\production\processingreports\*'
If ($check) {
	"Files Found"
	move '\\STOCKMACHINE\AmazonTransport\production\processingreports\*' '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Error Reports\Input'
	. '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Error Reports\Errors.ps1'
	If (Test-Path -Path '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Error Reports\Output\Errors.txt') {
		"There are Errors"
		$errors = Import-CSV '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Error Reports\Output\Errors.txt' -Delimiter "`t"
		$errorNumber = $errors.Length
		gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			% {Send-PushMessage -Type Email -Recipient $_ -Title "Processing Report Errors" -msg "Processing report is showing $errorNumber errors."}
	}
	If (Test-Path -Path '\\STOCKMACHINE\AmazonTransport\production\failed\*.txt') {
		gci "\\STOCKMACHINE\AmazonTransport\production\failed\" | % {
			Send-PushMessage -Type Email -Recipient $_ -Title "File Upload Failed" -msg $_.name
		}
	}
}
