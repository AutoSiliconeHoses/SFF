Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSdraper.txt" -Force
$Host.UI.RawUI.WindowTitle = $title = "DraperFeed"

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts"
If (Test-Path -Path draper.csv) {del draper.csv}

"Acquiring File"
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | ForEach-Object{Invoke-Expression $_}
$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\draper.csv"
Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
Catch {
	"FTP Issue 1/2, trying again"
	Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
	Catch {
		. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\PowerBullet.ps1"
		Get-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			Foreach-Object {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running $title FTP failed."}
		Sleep 3
		EXIT
	}
}

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\draper.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\draper.txt'

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed"
move draper.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
