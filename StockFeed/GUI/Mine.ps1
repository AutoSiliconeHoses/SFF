Clear-Host
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\timestamp.ps1"

"BizTools"
gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts\login.txt" | ForEach-Object{Invoke-Expression $_}
Try {$dt = Get-FileDateTime $RemoteFile $Username $Password}
Catch {
	"FTP Issue 1/2, trying again"
	Try {$dt = Get-FileDateTime $RemoteFile $Username $Password}
	Catch {
		. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\PowerBullet.ps1"
		Get-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			Foreach-Object {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running $title FTP failed."}
		Sleep 3
		EXIT
	}
}
$dt
Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ScheduleTracking\BZSCHEDULE.txt" ($dt)

"Draper"
gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\login.txt" | ForEach-Object{Invoke-Expression $_}
Try {$dt = Get-FileDateTime $RemoteFile $Username $Password}
Catch {
	"FTP Issue 1/2, trying again"
	Try {$dt = Get-FileDateTime $RemoteFile $Username $Password}
	Catch {
		. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\PowerBullet.ps1"
		Get-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			Foreach-Object {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running $title FTP failed."}
		Sleep 3
		EXIT
	}
}
$dt
Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ScheduleTracking\DPSCHEDULE.txt" ($dt)

"HomeHardware"
gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\login.txt" | ForEach-Object{Invoke-Expression $_}
Try {$dt = Get-FileDateTime $RemoteFile $Username $Password}
Catch {
	"FTP Issue 1/2, trying again"
	Try {$dt = Get-FileDateTime $RemoteFile $Username $Password}
	Catch {
		. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\PowerBullet.ps1"
		Get-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			Foreach-Object {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running $title FTP failed."}
		Sleep 3
		EXIT
	}
}
$dt
Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ScheduleTracking\HH1SCHEDULE.txt" ($dt)

"ToolBank Prime"
gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\login.txt" | ForEach-Object{Invoke-Expression $_}
Try {$dt = Get-FileDateTime $RemoteFile $Username $Password}
Catch {
	"FTP Issue 1/2, trying again"
	Try {$dt = Get-FileDateTime $RemoteFile $Username $Password}
	Catch {
		. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\PowerBullet.ps1"
		Get-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			Foreach-Object {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running $title FTP failed."}
		Sleep 3
		EXIT
	}
}
$dt
Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ScheduleTracking\TBPSCHEDULE.txt" ($dt)

"ToolBank"
gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\login.txt" | ForEach-Object{Invoke-Expression $_}
Try {$dt = Get-FileDateTime $RemoteFile $Username $Password}
Catch {
	"FTP Issue 1/2, trying again"
	Try {$dt = Get-FileDateTime $RemoteFile $Username $Password}
	Catch {
		. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\PowerBullet.ps1"
		Get-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\subscribed.txt" |
			Foreach-Object {Send-PushMessage -Type Email -Recipient $_ -Title "FTP Issue" -msg "2nd Attempt at running $title FTP failed."}
		Sleep 3
		EXIT
	}
}
$dt
Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ScheduleTracking\TBSCHEDULE.txt" ($dt)

Sleep 3
