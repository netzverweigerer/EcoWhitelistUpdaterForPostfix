#!/bin/sh
## Author: Patrick Baber
## Updated: Franz Bettag
## Updated even more: Armin Jenewein (@netzverweigerer on GitHub)

## eco whitelist credentials
user="your eco user"
password="your eco pw"

## Download URL for the eco whitelist
whitelist="https://****/csa-whitelist.xml"

postfix="/etc/postfix"

## Local path for the whitelist in xml format
whitelist="$postfix/eco-whitelist/csa-whitelist.xml"

## Path to postfix whitelist
override="$postfix/eco-whitelist/rbl_override"

bailout () {
  echo "ERROR: $@"
  exit 255
}

depcheck () {
  which "$@" >/dev/null 2>&1 || bailout "$@ not found in \$PATH. Exiting."
}

depcheck wget
depcheck curl

wget --http-user=${user} --http-passwd=${password} --no-check-certificate -N -O ${whitelist} ${whitelist} || bailout "wget returned non-zero exit code. Exiting."
curl --user "${user}:${password}" --insecure ${whitelist} > ${whitelist} || bailout "curl returned non-zero exit code. Exiting."

grep -E -oe '<IP>[^<]+</IP>' ${whitelist} | sed -e 's;<IP>;;g' -e 's;</IP>; OK;g' > ${override}

postmap ${override}


