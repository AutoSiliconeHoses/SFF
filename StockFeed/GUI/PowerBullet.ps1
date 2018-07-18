Function Send-PushMessage {
[CmdletBinding(DefaultParameterSetName='Message')]

param(
        [Parameter(Mandatory=$false,ParameterSetName="File")]$FileName,
        [Parameter(Mandatory=$true, ParameterSetName="File")]$FileType,
        [Parameter(Mandatory=$true, ParameterSetName="File")]
        [Parameter(Mandatory=$true, ParameterSetName="Link")]$url,

        [Parameter(Mandatory=$true, ParameterSetName="Recipient")]$recipient,

        [Parameter(Mandatory=$false,ParameterSetName="Address")]$PlaceName,
        [Parameter(Mandatory=$true, ParameterSetName="Address")]$PlaceAddress,

        [Parameter(Mandatory=$false)]
        [ValidateSet("Address","Message", "Email", "File", "List","Link")]
        [Alias("Content")]
        $Type,

        [switch]$UploadFile,
        [string[]]$items,
        $title="PushBullet Message",
        $msg)

begin{
    $authtoken = "o.rD3nqMqr3OaeUCWFL5SzXGDYtzbdMptl"
    $PushURL = "https://api.pushbullet.com/v2/pushes"
    $devices = "https://api.pushbullet.com/v2/devices"
    $uploadRequestURL   = "https://api.pushbullet.com/v2/upload-request"
    $uploads = "https://s3.amazonaws.com/pushbullet-uploads"

    $cred = New-Object System.Management.Automation.PSCredential ($authtoken,(ConvertTo-SecureString $authtoken -AsPlainText -Force))

    if (($PlaceName) -or ($PlaceAddress)){$type = "address"}

    if ($authtoken -eq "***YourAPIHere***"){Write-warning "Please place your API Key within line 48 and try again"
        BREAK}
    }

process{
    switch($Type){
    'Email'   {Write-Verbose "Emailing text "<#SendaMessagesstuff#>
             $body = @{
                    type = "note"
                    email = $recipient
                    title = $title
                    body = $msg
                    }

             }
    'Address'{Write-Verbose "Sending an Address"<#SendaMessagestuff#>
                $body = @{
                    type = "address"
                    title = $Placename
                    address = $PlaceAddress
                    }
             }
    'Message'{Write-Verbose "Sending a message"<#SendaMessagestuff#>
                $body = @{
                    type = "note"
                    title = $title
                    body = $msg
                    }
             }
    'List'   {Write-Verbose "Sending a list "<#SendaListstuff#>
             $body = @{
                    type = "list"
                    title = $title
                    items = $items

                    }

                    "body preview"
                    $body
                    #$body = $body | ConvertTo-Json
             }
    'Link'   {Write-Verbose "Sending a link "<#SendaLinkstuff#>
             $body = @{
                    type = "link"
                    title = $title
                    body = $msg
                    url = $url
                    }

             }
    'File'   {Write-Verbose "Sending a file "<#SendaFilestuff#>

              If ($UploadFile) {
                $UploadRequest = @{
                    file_name = $FileName
                    fileType  = $FileType
                }

                $attempt = Invoke-WebRequest -Uri $uploadRequestURL -Credential $cred -Method Post -Body $UploadRequest -ErrorAction SilentlyContinue
                If ($attempt.StatusCode -eq "200"){Write-Verbose "Upload Request OK"}
                else {Write-Warning "error encountered, check `$Uploadattempt for more info"
                        $global:Uploadattempt = $attempt}

                $UploadApproval = $attempt.Content | ConvertFrom-Json | select -ExpandProperty data

                #Have to append the file data to the Upload request
                $UploadApproval | Add-Member -Name "file" -MemberType NoteProperty -Value ([System.IO.File]::ReadAllBytes((get-item C:\TEMP\upload.txt).FullName))

                Invoke-WebRequest -Uri $uploads -Method Post -Body $UploadApproval -ErrorAction SilentlyContinue
                }
            Else {
                $body = @{
                    type = "file"
                    file_name = $fileName
                    file_type = $filetype
                    file_url = $url
                    body = $msg
                    }

            }
            $global:UploadApproval = $UploadApproval
            BREAK
            }
    }

    write-debug "Test-value of `$body before it gets passed to Invoke-WebRequest"

    #Here is where it is sent
    $Sendattempt = Invoke-WebRequest -Uri $PushURL -Credential $cred -Method Post -Body $body -ErrorAction SilentlyContinue

    If ($Sendattempt.StatusCode -eq "200"){Write-Verbose "OK"}
        else {Write-Warning "error encountered, check `$attempt for more info"
              $global:Sendattempt = $Sendattempt  }
    }

end{$global:Sendattempt = $Sendattempt}
}
