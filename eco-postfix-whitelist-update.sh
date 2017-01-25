#!/bin/sh
## Author: Patrick Baber
## Updated: Franz Bettag

# MAKE SURE YOUR PATH IS SET CORRECTLY TO CONTAIN ALL REQUIRED BINARIES HERE

## Configuration

## eco whitelist credentials
ECOUSER="your eco user"
ECOPASS="your eco pw"

## Download URL for the eco whitelist
WHITELISTURL="https://****/csa-whitelist.xml"

POSTFIXPATH="/etc/postfix"

## Local path for the whitelist in xml format
WHITELISTPATH="$POSTFIXPATH/eco-whitelist/csa-whitelist.xml"

## Path to postfix whitelist
POSTFIXWHITELISTPATH="$POSTFIXPATH/eco-whitelist/rbl_override"

out=`which wget`
done=false
found=false
if [ $? -eq 0 ]; then
	found=true
	wget --http-user=${ECOUSER} --http-passwd=${ECOPASS} --no-check-certificate -N -O ${WHITELISTPATH} ${WHITELISTURL}
	[ $? -eq 0 ] && done=true
fi

if [ $done -eq false ]; then
	out=`which curl`
	if [ $? -eq 0 ]; then
		found=true
		curl --user "${ECOUSER}:${ECOPASS}" --insecure ${WHITELISTURL} > ${WHITELISTPATH}
		[ $? -eq 0 ] && done=true
	fi
fi

if [ $found -ne true ]; then
	echo "Neither wget nor curl found in PATH! aborting.."
	exit 1
fi

if [ $done -ne true ]; then
	echo "Unable to download whitelist! aborting.."
	exit 1
fi

egrep -oe '<IP>[^<]+</IP>' ${WHITELISTPATH} | sed -e 's;<IP>;;g' -e 's;</IP>; OK;g' > ${POSTFIXWHITELISTPATH}
postmap ${POSTFIXWHITELISTPATH}

exit 0
