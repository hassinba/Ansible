Within the Ansible WinRM documentation I never found one script that fully prepped Windows endpoints for WinRM-Secure. I pieced this PS script together to quickly be able to prep endpoints, rather than following instructions from 3-4 different sources which had a mix of PS/CMD.

This gets the cert put into the certificate store in two places, sets up the Windows firewall (it sets the profile to private so if you're doing this to public facing web servers adjust this part!), setups up the HTTPS WinRM listener, deletes the HTTP WinRM listener, and maps the user to the certificate.

Lines 4 and 5 you will have to point to your certificate, so change "enter path to certificate here\cert.pem" to an accessible share on your network, leave the quotes.

Line 13 you will need to enter a local username appropriate for your environment, leave the quotes.

Line 14 you will need to enter a password for the username in Line 13, leave the quotes.

Let me know if there are any issues and I can take a look. If there are issues it will likely be with the firewall, most likely the firewall profile, so you may need to tweak that part to suit your needs.
