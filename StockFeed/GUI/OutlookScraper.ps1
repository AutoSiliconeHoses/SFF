$Host.UI.RawUI.WindowTitle = $title = "Outlook Scraper"
Set-PSDebug -Trace 0
If (Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSOutlookScraper.txt") {del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSOutlookScraper.txt" -ErrorAction SilentlyContinue}
Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSOutlookScraper.txt" -Force  -ErrorAction SilentlyContinue

#Open Outlook
saps 'Outlook' -WindowStyle Hidden -ErrorAction SilentlyContinue -ArgumentList '/profile "Stocks" '

# Creates MAPI workspace
Add-Type -Assembly "Microsoft.Office.Interop.Outlook"
$Outlook = New-Object -ComObject Outlook.Application
$Namespace = $Outlook.GetNameSpace("MAPI")
$Namespace.logon()
$Namespace.SendAndReceive($TRUE)
sleep 15
$inbox = $NameSpace.Folders.Item(1).Folders.Item('Inbox').Folders

# Gets today's date and formats it
$Yesterday = (Get-Date).AddDays(-1).tostring("yyyy-MM-dd")
$Today = (Get-Date).tostring("yyyy-MM-dd")
echo ($Today)

# Begins the search
foreach ($supplier in $inbox) {
  $supplierName = $supplier.FolderPath.replace("\\Personal Folders\Inbox\","").replace("2","")

  $folderPath = ('\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\')
  $saveFilePath = ('\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Dropzone\' + $supplierName)

  If (!(Test-Path -Path $saveFilePath)) {
    New-Item -Path $folderPath -Name $supplierName -ItemType "directory"
  }

  $supplierCont = $supplier.Items
  $supplierName
  foreach ($email in $supplierCont) {
    if ($email.attachments.count -ge 1) {
      if (($email.receivedTime.tostring("yyyy-MM-dd")) -eq ($Today)) {
        if ($email.unread) {
          foreach ($attachment in $email.attachments) {
            if ($attachment.filename.contains(".CSV") `
              -or $attachment.filename.contains(".csv") `
              -or $attachment.filename.contains(".xls") `
              -or $attachment.filename.contains(".xlsx") `
              -or $attachment.filename.contains(".zip")) {
              $supplier = $email.SenderName
              $filename = $attachment.filename

							If ($args[0] -eq "-run"){
								$email.unread = $false
							}

              switch ($supplierName) {
                "Decco" {$filename = "decco.zip"; $run += "dc- "}
                "Decco Prime" {$filename = "deccoprime.zip"}
                "Febi" {$filename = "febi.csv"; $run += "fi- "}
                "FPS" {If ($filename -like '*LEEDS*') {$filename = "FPS_LEEDS.xlsx"} $run += "fps- "}
                "FPS Prime" {If ($filename -like '*LEEDS*') {$filename = "FPS_LEEDS.xlsx"}}
                "KYB" {$filename = "kyb.csv"; $run += "kb- "}
                "Mintex" {$filename = "mintex.zip"; $run += "mx- "}
                "Tetrosyl" {$run += "tl- "}
                "Workshop Warehouse" {$filename = "workshopwarehouse.xls"; $run += "ww- "}
              }

              echo ($filename + " saved from " + $supplier + " @ " + $email.receivedTime)
              $filepath = (join-path $savefilepath $filename)
              $attachment.saveasfile($filepath)

              $file = Get-Item $filepath
              $file.LastWriteTime = $email.receivedTime
            }
          }
        }
      }
    }
  }
}
# Stop Outlook
$Outlook = ps outlook -ErrorAction SilentlyContinue
$Outlook.CloseMainWindow()
While ($Outlook) {
  $Outlook.CloseMainWindow()
  sleep 2
  $Outlook = ps outlook -ErrorAction SilentlyContinue
}
rv Outlook

If ($args[0] -eq "-run"){
  If (!([String]::IsNullOrEmpty($run))) {
		$run = ($run -split ' ' | Select -Unique) -join ' '
    $run = "4 " + $run + "up-"
    "Args: "+$run
    "Booting RunAll"
    sleep 2
    $loadString = "& '\\Diskstation\Feeds\Stock File Fetcher\StockFeed\GUI\RunAll.ps1' $run"
  	Start PowerShell $loadstring
  }
  If ([String]::IsNullOrEmpty($run)) {"No new emails found"; sleep 3}
}
Stop-Transcript
