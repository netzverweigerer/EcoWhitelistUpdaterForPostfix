#!/bin/sh
#
## Author: Patrick Baber
## Updated: Franz Bettag
## Updated even more: Armin Jenewein (@netzverweigerer on GitHub)
#

## Set credentials for eco whitelist here
user="your eco user"
password="your eco pw"

## Download URL for the eco whitelist
whitelist="https://****/csa-whitelist.xml"

# Path to postfix configuration directory
postfix="/etc/postfix"

## Local path for the whitelist in xml format
whitelist="$postfix/eco-whitelist/csa-whitelist.xml"

## Path to postfix whitelist
override="$postfix/eco-whitelist/rbl_override"

# Prints an error message and exits gracefully
bailout () {
  echo "ERROR: $@"
  exit 255
}

# Determine download program
determine () {
	which wget >/dev/null 2>&1 && downloader=wget && return
	which curl >/dev/null 2>&1 && downloader=curl && return
	which fetch >/dev/null 2>&1 && downloader=fetch && return
	downloader=""
}
determine

# Exit if no compatible download program was found
if [ $downloader == "" ]; then
  bailout "No compatible download program found. Please intall wget, curl, or fetch. Exiting."
  exit 255
else
  echo "Using downloader: $downloader"
fi

case "$downloader" in
  wget)
  wget --http-user=${user} --http-passwd=${password} --no-check-certificate -N -O ${whitelist} ${whitelist} || bailout "wget returned non-zero exit code. Exiting."
  ;;
  curl)
    curl --user "${user}:${password}" --insecure ${whitelist} > ${whitelist} || bailout "curl returned non-zero exit code. Exiting."
  ;;
  fetch)
    echo "IMPLEMENT ME."
    exit 1
  ;;
esac

grep -E -oe '<IP>[^<]+</IP>' ${whitelist} | sed -e 's;<IP>;;g' -e 's;</IP>; OK;g' > ${override}

postmap ${override}
exit $?



