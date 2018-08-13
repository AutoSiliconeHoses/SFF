Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANShh.txt" -Force
$Host.UI.RawUI.WindowTitle = $title = "HomeHardwareFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
"Acquiring Files"
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | % {iex $_}
$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\Primary1.csv"
Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
Catch {
	"FTP Issue 1/2, trying again"
	Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
	Catch {
		. "\\Diskstation\Feeds\SDK\Scripts\PowerBullet.ps1"
		gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			% {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running $title FTP failed."}
		sleep 3
		EXIT
	}
}

$RemoteFile = "ftp://195.74.141.134/HHW_Availability_Bedford/Primary15.csv"
$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\Primary15.csv"
Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
Catch {
	"FTP Issue 1/2, trying again"
	Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
	Catch {
		. "\\Diskstation\Feeds\SDK\Scripts\PowerBullet.ps1"
		gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			% {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running $title FTP failed."}
		sleep 3
		EXIT
	}
}

"Combining Files"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed"
gc *.csv | sc ".\Scripts\homehardware.csv"

If (Test-Path -Path Primary1.csv) {del Primary1.csv}
If (Test-Path -Path Primary15.csv) {del Primary15.csv}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts"
If (Test-Path -Path hhmacro2.xlsm) {del hhmacro2.xlsm}

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning file"
$textfile = '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt'
(gc $textfile).replace("FALSE`t`t`t`t0`targreplace", "").replace("-HH`t`t`t`t0`targreplace", "").replace("stock_no-HH`t`t`t`t50`targreplace", "") | sc $textfile

"Cleaning folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed"
If (Test-Path -Path Primary1.csv) {del Primary1.csv}
If (Test-Path -Path Primary15.csv) {del Primary15.csv}

"Moving File to Upload folder"
If (Test-Path -Path "\\DISKSTATION\Feeds\Dropship\Scripts\HH\HH.txt") {del "\\DISKSTATION\Feeds\Dropship\Scripts\HH\HH.txt"}
copy "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt" "\\DISKSTATION\Feeds\Dropship\Scripts\HH\HH.txt"
move "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\homehardware.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
