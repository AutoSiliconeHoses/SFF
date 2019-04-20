Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSbiztools.txt" -Force
$Host.UI.RawUI.WindowTitle = 'BizToolsFeed'

Function alter($sku,$edit) {
  (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\bixtools.txt') -replace "$sku`t`t`t`t.+", "$sku`t`t`t`t$edit`targreplace" | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\biztools.txt'
}

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts"
If (Test-Path -Path "biztools.csv"){del biztools.csv}

"Acquiring File"
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | % {iex $_}

$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts\biztools.csv"
Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
Catch {
	"FTP Issue 1/2, trying again"
	Try {FTP-Download $RemoteFile $Username $Password $LocalFile}
	Catch {
		. "\\Diskstation\Feeds\SDK\Scripts\PowerBullet.ps1"
		gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			% {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running BizTools FTP failed."}
		sleep 3
		EXIT
	}
}

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts\OpenAndSavePS.ps1" /C

"Cleaning File"
Import-CSV "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\alterations.csv" | select sku,qty | ? {$_.sku.endswith("-BZ")} | % {alter $_.sku $_.qty}

"Moving File to Upload folder"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed"
move biztools.txt "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
