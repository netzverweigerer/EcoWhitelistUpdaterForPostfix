#!/bin/sh
## Author: Patrick Baber

## Configuration

## eco whitelist credentials
USER="your eco user"
PASSWORD="your eco pw"

## Download URL for the eco whitelist
WHITELISTURL="https://****/csa-whitelist.xml"

## Local path for the whitelist in xml format
WHITELISTPATH="/etc/postfix/eco-whitelist/csa-whitelist.xml"

## Path to postfix whitelist
POSTFIXWHITELISTPATH="/etc/postfix/eco-whitelist/rbl_override"

## Path to PHP convert script
PHPCONVERTPATH="/etc/postfix/eco-whitelist/eco-postfix-whitelist-convert.php"

## Path to wget
WGETPATH="/usr/bin/wget"

## Path to php cli
PHPPATH="/usr/bin/php"

## Path to the postfix tool postmap
POSTMAPPATH="/usr/sbin/postmap"

${WGETPATH} --http-user=${USER} --http-passwd=${PASSWORD} --no-check-certificate -N -O ${WHITELISTPATH} ${WHITELISTURL}
${PHPPATH} -f ${PHPCONVERTPATH} ${WHITELISTPATH} ${POSTFIXWHITELISTPATH}
${POSTMAPPATH} ${POSTFIXWHITELISTPATH}

exit 0