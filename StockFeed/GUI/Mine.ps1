Clear-Host
. "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\timestamp.ps1"

"BizTools"
gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\BizToolsFeed\Scripts\login.txt" | ForEach-Object{Invoke-Expression $_}
$dt = Get-FileDateTime $RemoteFile $Username $Password
$dt
Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ScheduleTracking\BZSCHEDULE.txt" ($dt)

"Draper"
gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\DraperFeed\Scripts\login.txt" | ForEach-Object{Invoke-Expression $_}
$dt = Get-FileDateTime $RemoteFile $Username $Password
$dt
Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ScheduleTracking\DPSCHEDULE.txt" ($dt)

"HomeHardware"
gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\HomeHardwareFeed\Scripts\login.txt" | ForEach-Object{Invoke-Expression $_}
$dt = Get-FileDateTime $RemoteFile $Username $Password
$dt
Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ScheduleTracking\HH1SCHEDULE.txt" ($dt)

"ToolBank Prime"
gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankPrimeFeed\Scripts\login.txt" | ForEach-Object{Invoke-Expression $_}
$dt = Get-FileDateTime $RemoteFile $Username $Password
$dt
Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ScheduleTracking\TBPSCHEDULE.txt" ($dt)

"ToolBank"
gc "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\ToolBankFeed\Scripts\login.txt" | ForEach-Object{Invoke-Expression $_}
$dt = Get-FileDateTime $RemoteFile $Username $Password
$dt
Add-Content "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\ScheduleTracking\TBSCHEDULE.txt" ($dt)

Sleep 3
