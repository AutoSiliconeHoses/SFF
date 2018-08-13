Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANStoolbank.txt" -Force
$Host.UI.RawUI.WindowTitle = $title = 'ToolBankFeed'

cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts"
If (Test-Path -Path "toolbank.csv"){del toolbank.csv}

"Acquiring File"
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ftp.ps1"
gc login.txt | % {iex $_}

$LocalFile = "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\toolbank.csv"
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

"Processing File"
"OpenAndSave.ps1"
& "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\OpenAndSave.ps1" /C

"Cleaning File"
cd "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed"
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt').replace("FALSE`t`t`t`t0`targreplace", "") | sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt'
# (gc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt')|?{$_.Trim(" `t")}|sc '\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt'

"Moving File to Upload folder"
If (Test-Path -Path "\\DISKSTATION\Feeds\Dropship\Scripts\TB\TB.txt") {del "\\DISKSTATION\Feeds\Dropship\Scripts\TB\TB.txt"}
copy "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt" "\\DISKSTATION\Feeds\Dropship\Scripts\TB\TB.txt"
move "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\toolbank.txt" "\\DISKSTATION\Feeds\Stock File Fetcher\Upload"
Stop-Transcript
