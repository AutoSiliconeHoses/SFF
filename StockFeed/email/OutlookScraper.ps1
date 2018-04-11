# Creates MAPI workspace
Add-Type -Assembly "Microsoft.Office.Interop.Outlook"
$Outlook = New-Object -ComObject Outlook.Application
$Namespace = $Outlook.GetNameSpace("MAPI")

# Enters the inbox
$inbox = $NameSpace.GetDefaultFolder(6).Items

# Gets today's date and formats it
$Today = (Get-Date).tostring("yy-MM-dd")
echo ($Today)

# Experimental Filter objects
#$filt = Items | Where {(_.receivedTime.GetDateTimeFormats()[5]) -match ($Today)}
#$sorted = $Items | Sort-Object -Property receivedTime

# Creates a folder for today and opens it
$target = 'Z:\Stock File Fetcher\StockFeed\email\attachments\' + ($Today)
if(!(Test-Path -Path $target )) {
  New-Item -ItemType directory -Path $target
}
ii ("Z:\Stock File Fetcher\StockFeed\email\attachments\" + $Today)
$saveFilePath = ('Z:\Stock File Fetcher\StockFeed\email\attachments\' + $Today)

# Begins the search
foreach ($email in $inbox) {
	if ($email.attachments.count -ge 1) {
    echo ($email.receivedTime)
		if (($email.receivedTime.GetDateTimeFormats()[5]) -eq ($Today)) {
			foreach ($attachment in $email.attachments) {
        if ($attachment.filename.contains(".CSV") -or $attachment.filename.contains(".csv") -or $attachment.filename.contains(".xlsx")) {
          $supplier = $email.SenderName
          $filename = $attachment.filename
          echo ($filename + " saved from " + $supplier)
  	  		$attachment.saveasfile((join-path $savefilepath $filename))
        }
			}
		}
	}
}
