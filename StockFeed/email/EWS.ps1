$MailboxName = "stock@autosiliconsehoses.com"
$Subject = "Report"
$downloadDirectory = "C:\Users\sales-10\Desktop\email\attachments"

Function FindTargetFolder($FolderPath) {
  $tfTargetidRoot = new-object  Microsoft.Exchange.WebServices.Data.FolderId([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::MsgFolderRoot,$MailboxName)
  $tfTargetFolder = [Microsoft.Exchange.WebServices.Data.Folder]::Bind($service,$tfTargetidRoot)
  $pfArray = $FolderPath.Split("/")

  for ($lint = 1; $lint -lt $pfArray.Length; $lint++) {
    $pfArray[$lint]
    $fvFolderView = new-object Microsoft.Exchange.WebServices.Data.FolderView(1)
    $SfSearchFilter = new-object Microsoft.Exchange.WebServices.Data.SearchFilter+IsEqualTo([Microsoft.Exchange.WebServices.Data.FolderSchema]::DisplayName,$pfArray[$lint])
    $findFolderResults = $service.FindFolders($tfTargetFolder.Id,$SfSearchFilter,$fvFolderView)
    if ($findFolderResults.TotalCount -gt 0){
      foreach($folder in $findFolderResults.Folders) {
        $tfTargetFolder = $folder
      }
    }
    else {
      "Error Folder Not Found"
      $tfTargetFolder = $null
      break
    }
  }
  $Global:findFolder = $tfTargetFolder
}

$dllpath = "Z:\Stock File Fetcher\StockFeed\Programs\WebServices 2.0\Microsoft.Exchange.WebServices.dll"
[void][Reflection.Assembly]::LoadFile($dllpath)
$service = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService([Microsoft.Exchange.WebServices.Data.ExchangeVersion]::Exchange2010_SP1)

$windowsIdentity = [System.Security.Principal.WindowsIdentity]::GetCurrent()
$sidbind = "LDAP://<SID=" + $windowsIdentity.user.Value.ToString() + ">"
$aceuser = [ADSI]$sidbind

$service.AutodiscoverUrl($aceuser.mail.ToString())

$folderid = new-object  Microsoft.Exchange.WebServices.Data.FolderId([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Inbox,$MailboxName)
$InboxFolder = [Microsoft.Exchange.WebServices.Data.Folder]::Bind($service,$folderid)
$Sfir = new-object Microsoft.Exchange.WebServices.Data.SearchFilter+IsEqualTo([Microsoft.Exchange.WebServices.Data.EmailMessageSchema]::IsRead, $false)
$Sfsub = new-object Microsoft.Exchange.WebServices.Data.SearchFilter+ContainsSubstring([Microsoft.Exchange.WebServices.Data.ItemSchema]::Subject, $Subject)
$Sfha = new-object Microsoft.Exchange.WebServices.Data.SearchFilter+IsEqualTo([Microsoft.Exchange.WebServices.Data.EmailMessageSchema]::HasAttachments, $true)
$sfCollection = new-object Microsoft.Exchange.WebServices.Data.SearchFilter+SearchFilterCollection([Microsoft.Exchange.WebServices.Data.LogicalOperator]::And);

$sfCollection.add($Sfir)
$sfCollection.add($Sfsub)
$sfCollection.add($Sfha)

$view = new-object Microsoft.Exchange.WebServices.Data.ItemView(200)
$frFolderResult = $InboxFolder.FindItems($sfCollection,$view)

foreach ($miMailItems in $frFolderResult.Items) {
  $miMailItems.Subject
  $miMailItems.Load()
  foreach($attach in $miMailItems.Attachments) {
    $attach.Load()
    $fiFile = new-object System.IO.FileStream(($downloadDirectory + “\” + "Report.csv"), [System.IO.FileMode]::Create)
    $fiFile.Write($attach.Content, 0, $attach.Content.Length)
    $fiFile.Close()
    write-host ("Downloaded Attachment : " + ($downloadDirectory + “\” + "Report.csv"))
  }

  $miMailItems.isread = $true
  $miMailItems.Update([Microsoft.Exchange.WebServices.Data.ConflictResolutionMode]::AutoResolve)
  #$miMailItems.delete([Microsoft.Exchange.WebServices.Data.DeleteMode]::MoveToDeletedItems)
}
