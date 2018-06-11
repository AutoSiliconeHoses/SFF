Set-PSDebug -Trace 0
If (Test-Path -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSOutlookScraper.txt") {
  del "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSOutlookScraper.txt"
}
Start-Transcript -Path "\\DISKSTATION\Feeds\Stock File Fetcher\StockFeed\GUI\Transcripts\TRANSOutlookScraper.txt" -Force -NoClobber

# Creates MAPI workspace
Add-Type -Assembly "Microsoft.Office.Interop.Outlook"
$Outlook = New-Object -ComObject Outlook.Application
$Namespace = $Outlook.GetNameSpace("MAPI")
$Namespace.logon()
$Namespace.SendAndReceive($false)
$inbox = $NameSpace.Folders.Item(1).Folders.Item('Inbox').Folders

# Gets today's date and formats it
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
                foreach ($attachment in $email.attachments) {
                    if ($attachment.filename.contains(".CSV") `
                    -or $attachment.filename.contains(".csv") `
                    -or $attachment.filename.contains(".xlsx") `
                    -or $attachment.filename.contains(".zip")) {
                        $supplier = $email.SenderName
                        $filename = $attachment.filename

                        if ($supplierName -eq "Decco") {$filename = "decco.zip"}
                        if ($supplierName -eq "KYB") {$filename = "kyb.csv"}
                        if ($supplierName -eq "Febi") {$filename = "febi.csv"}
                        if ($supplierName -eq "Kilen") {$filename = "kilen.csv"}
                        if ($supplierName -eq "FPS") {$filename = "fps.xlsx"}

                        echo ($filename + " saved from " + $supplier + " time: " + $email.receivedTime)
                        $attachment.saveasfile((join-path $savefilepath $filename))
                    }
                }
            }
        }
    }
}
Stop-Transcript
