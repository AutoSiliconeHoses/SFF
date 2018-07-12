Function FTP-Download ($RemoteFile, $Username, $Password, $LocalFile) {
	# Create a FTPWebRequest
	$FTPRequest = [System.Net.FtpWebRequest]::Create($RemoteFile)
	$FTPRequest.Credentials = New-Object System.Net.NetworkCredential($Username,$Password)
	$FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile
	$FTPRequest.UsePassive = $true
	$FTPRequest.UseBinary = $true
	$FTPRequest.KeepAlive = $true
	# Send the ftp request
	$FTPResponse = $FTPRequest.GetResponse()
	# Get a download stream from the server response
	$ResponseStream = $FTPResponse.GetResponseStream()
	# Create the target file on the local system and the download buffer
	$LocalFileFile = New-Object IO.FileStream ($LocalFile,[IO.FileMode]::Create)
	[byte[]]$ReadBuffer = New-Object byte[] 1024
	# Loop through the download
		do {
			$ReadLength = $ResponseStream.Read($ReadBuffer,0,1024)
			$LocalFileFile.Write($ReadBuffer,0,$ReadLength)
		}
		while ($ReadLength -ne 0)
	"Download Complete."
	$ResponseStream.Close()
	$ResponseStream.Dispose()
	$LocalFileFile.Close()
}
