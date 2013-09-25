<?php

if (empty($argv[1])) {
	echo 'eco whitelist xml not defined.' . "\n";
	exit;
}

if (empty($argv[2])) {
	echo 'Postfix whitelist file not defined.' . "\n";
	exit;
}

$whitelistPath = $argv[1];
$postfixExportPath = $argv[2];

$xml = @simplexml_load_file($whitelistPath);
$output = '';

if (!empty($xml)) {
	if (!empty($xml->certified_mass_sender)) {
		foreach ($xml->certified_mass_sender as $certifiedMassSender) {
			if (!empty($certifiedMassSender->certified_server)) {
				foreach ($certifiedMassSender->certified_server as $certified_server) {
					if (!empty($certified_server->IP)) {
						$output .= $certified_server->IP . ' OK' . "\n";
					}
				}
			}
		}
		file_put_contents($postfixExportPath, $output);
	}
}