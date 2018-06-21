get-process |? {$_.processname -eq 'excel'}|%{stop-process $_.id}
