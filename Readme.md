EcoWhitelistUpdaterForPostfix
=================================

This is a bunch of scripts for using the whitelist from the Certified Senders Alliance. This is a mailserver whitelist project initiated by eco - Verband der deutschen Internetwirtschaft e.V. More informations you get on the official website: http://www.certified-senders.eu/

The shell script will be executed via cronjob. This script loads the eco whitelist in XML format and converts it with the php script and the SimpleXML extension (included since PHP 5.x) to a Postfix hash file. At the end the hash file will also be converted with postmap to Berkeley DB.

1. Requirements:
----------------
- Signed contract with eco for using the whitelist as ISP.
- The credentials to download the whitelist in XML format.
- The downloading server needs to be in the firewall rules of eco with his IP address.
- PHP CLI to execute the convert script (on Debian: apt-get install php5-cli)
- And of course Postfix (:

2. Integration:
----------------
- Jump to the postfix configuration: cd /etc/postfix
- Create folder in postfix configuration: mkdir eco-whitelist
- Put the scripts in this folder
- Edit the credentials, paths and URL to the eco XML whitelist (this is blurred in the script, cause of a NDA with eco)
- Give the shell script execution permissions: chmod +x eco-postfix-whitelist-update.sh
- Create a new cronjob to start the shell script: crontab -e
- Add this line to update the whitelist on midnight: 0 0 * * * /etc/postfix/eco-whitelist/eco-postfix-whitelist-update >/dev/null 2>&1
- Edit the smtpd_recipient_restrictions section in the main.cf of postfix and restart it (/etc/init.d/postfix restart).

> smtpd_recipient_restrictions =  
>  [...]  
>  reject_unauth_destination  
>  #eco whitelist  
>  check_client_access hash:/etc/postfix/eco-whitelist/rbl_override  
>  reject_rbl_client dnsbl.sorbs.net  
>  reject_rbl_client bl.spamcop.net  
>  [...]  
