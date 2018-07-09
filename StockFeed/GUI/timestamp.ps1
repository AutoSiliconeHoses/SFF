# Function to get date timestamp of a file on FTP server
Function Get-FileDateTime { 

Param (
 [System.Uri]$server,
 [string]$username,
 [string]$password,
 [string]$FilePath

)
try 
 {

    # Create URI by joining server name and directory path
    $uri =  "$server$FilePath" 
  
     # Create an instance of FtpWebRequest
    $FTPRequest = [System.Net.FtpWebRequest]::Create($uri)

    # Set the username and password credentials for authentication
    $FTPRequest.Credentials = New-Object System.Net.NetworkCredential($username,$password)

    #Set method to GetDateTimestamp
    $FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::GetDateTimestamp

    # Enter passive mode.
    # Server waits for client to initiate a connection. 
    $FTPRequest.UsePassive = $true

    # Get response from FTP server for the request
    $FTPResponse = $FTPRequest.GetResponse() 

    # Extract last modified time from the response
    $LastModified = [DateTime]$FTPResponse.LastModified

    # Close response object
    $FTPResponse.Close()
    Return $LastModified 
}
catch {
    #Show error message if any
    write-host -message $_.Exception.InnerException.Message
}

} #End of Funtion