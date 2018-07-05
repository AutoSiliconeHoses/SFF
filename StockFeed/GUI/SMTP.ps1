#param(
#[string]$to,
#[string]$subject,
#[string]$body
#)

$to = "jackp@autosiliconehoses.com"
$subject = "PowerShell SMTP Test"
$body = gc text.txt

$smtpServer = "mail.autosiliconehoses.com"
$smtpFrom = "daniel@autosiliconehoses.com"
$smtpTo = $to
$messageSubject = $subject
$messageBody = $body

$smtp = New-Object Net.Mail.SmtpClient($smtpServer)
$smtp.Send($smtpFrom,$smtpTo,$messagesubject,$messagebody)
