While ($true) {
	Sleep 20
	$check = Test-Path -Path '\\STOCKMACHINE\AmazonTransport\production\processingreports\*'
	If ($check) {
		"Files Found"
		move '\\STOCKMACHINE\AmazonTransport\production\processingreports\*' '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Error Reports\Input'
		. '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Error Reports\Errors.ps1'
		If (Test-Path -Path '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Error Reports\Output\Errors.txt') {
			"There are Errors"
		}
	}
}
