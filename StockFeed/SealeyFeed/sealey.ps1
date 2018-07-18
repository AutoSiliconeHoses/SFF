Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSsealey.txt" -Force
$Host.UI.RawUI.WindowTitle = $title = 'SealeyFeed'

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\Scripts"
If (Test-Path -Path "sealey.xlsx"){del sealey.xlsx}

"Acquiring File"
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | ForEach-Object{Invoke-Expression $_}
$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\Scripts\sealey.xlsx"
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

"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\Scripts\OpenAndSave.ps1" /C

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed"
move sealey.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
