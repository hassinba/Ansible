$pcname = $env:computername
$c = New-SelfSignedCertificate -DNSName $pcname -CertStoreLocation Cert:\LocalMachine\My
$certprint = (Get-ChildItem -Path Cert:\LocalMachine\My | Where-Object { $_.Subject -eq "CN=$pcname" }).Thumbprint
Import-Certificate -FilePath "enter path to certificate here\cert.pem" -CertStoreLocation 'Cert:\LocalMachine\Root'
Import-Certificate -FilePath "enter path to certificate here\cert.pem" -CertStoreLocation 'Cert:\LocalMachine\TrustedPeople'
Set-NetConnectionProfile -NetworkCategory Private
New-NetFirewallRule -Name "WinRM-Secure" -DisplayName "WinRM-Secure" -Protocol TCP -Direction Inbound -LocalPort 5986 -Profile Any -Description "Allows Ansible to manage remotely"
Enable-PSRemoting
New-Item WSMan:\localhost\Listener -Address * -Transport HTTPS -HostName $pcname -CertificateThumbPrint $certprint -Force
winrm delete winrm/config/Listener?Address=*+Transport=HTTP
winrm enumerate winrm/config/Listener
Set-Item -Path WSMan:\localhost\Service\Auth\Certificate -Value $true
$username = "enter local username here"
$password = ConvertTo-SecureString -String "enter local password here" -AsPlainText -Force
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $password
# This is the issuer thumbprint which in the case of a self generated cert
$thumbprint = (Get-ChildItem -Path cert:\LocalMachine\root | Where-Object { $_.Subject -eq "CN=$username" }).Thumbprint
New-Item -Path WSMan:\localhost\ClientCertificate `
    -Subject "$username@localhost" `
    -URI * `
    -Issuer $thumbprint `
    -Credential $credential `
    -Force