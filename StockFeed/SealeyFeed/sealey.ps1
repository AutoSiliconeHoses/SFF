Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSsealey.txt" -Force
$Host.UI.RawUI.WindowTitle = 'SealeyFeed'

Function alter($sku,$edit) {
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\sealey.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\sealey.txt'
}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\Scripts"
If (Test-Path -Path "sealey.xlsx"){del sealey.xlsx}

"Acquiring File"
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | % {iex $_}
$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\Scripts\sealey.xlsx"
Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
Catch {
	"FTP Issue 1/2, trying again"
	Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
	Catch {
		. "\\Diskstation\Feeds\SDK\Scripts\PowerBullet.ps1"
		gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			% {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running Sealey FTP failed."}
		sleep 3
		EXIT
	}
}

"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | select sku,qty | ? {$_.sku.endswith("-SY")} | % {alter $_.sku $_.qty}

"Moving File to Upload folder"
If (Test-Path -Path "\\DISKSTATION\Feeds\Dropship\Scripts\SY\SY.txt") {del "\\DISKSTATION\Feeds\Dropship\Scripts\SY\SY.txt"}
copy "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\sealey.txt" "\\DISKSTATION\Feeds\Dropship\Scripts\SY\SY.txt"
move "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\SealeyFeed\sealey.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
