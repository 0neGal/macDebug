#!/bin/bash

# Last updated on: 13/9/2019
# Version: 1.0
# Auther: 0neGuyDev <0neguybusiness@gmail.com>
# Copyrighted by: 0neGuyDev
# Purpose: Get info for debugging a mac machine

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YO='\033[0;33m'
NC='\033[0m'

echo -e "${GREEN}Script made by 0neGuy${NC}"
echo -e "${GREEN}Copyrighted Property of 0neGuy${NC}"
echo -e "${GREEN}https://twitter.com/0neGuyDev${NC}"
echo

uuid=$(pmset -g uuid)
result=$(pmset -g batt)
path=~/Desktop/macDebug.html
deviceuname=$(uname -mnprs)
date=$(date)
otherBatInfo=$(ioreg -l | grep Capacity)
SIP=$(csrutil status)
hiddenFiles=$(defaults read com.apple.finder AppleShowAllFiles)
networkEn0=$(ifconfig en0)
uptime=$(uptime)
rebootList=$(last reboot)
shutdownList=$(last shutdown)
diskList=$(diskutil list)
version="1.0"

SAVE_TO_FILE() {
	echo -e "${CYAN} Saving to file at $path"
	echo "
<!DOCTYPE html>
<html>
<head>
<title>macOS Debug Info</title>
<meta charset='UTF-8'>
<meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no, viewport-fit=cover'>

</head>
<body onload='init()'>
<style>body{margin:30px;background:black;font-family:monospace; color:lightgreen;} h1, h2, h4 {color:white; font-style:italic;} a {color:inherit !important;</style>
<h1>macDebug</h1>
<h4>Script is made and copyrighted by <a href='https://twitter.com/0neGuyDev'>0neGuy</a></h4>
	
<h2>Miscellaneuos</h2>
<h3>Device Info: $deviceuname<br>
Device UUID: $uuid<br>
Time and date of run: $date<br>
$SIP (If enabled it allows the user to remove system files)</h3>

<h2>Battery Info</h2>
<h3>Time since last full shutdown: $uptime</h3>
<h3>$result</h3>
<h3 class='compile'>$otherBatInfo</h3>

<h2>Compiled Battery Info</h2>
<h3 id='compiled'>
</h3>

<h2>Network Info</h2>
<h3 id='network'>
$networkEn0
</h3>

<h2>Mounted Disks and Partitions</h2>
<h3 id='disks'>$diskList</h3>

<h2>Settings</h2>
<h3>
Show hidden files in finder: $hiddenFiles <br>
</h3>

<h2>Available list of all shutdowns</h2>
<h3 id='shutdowns'>$shutdownList</h3>

<h2>Available list of all reboots</h2>
<h3 id='reboots'>$rebootList</h3>

<script>
function init() {
var compileIt = document.querySelector('.compile').innerText;
var designCapacity1 = compileIt.search('DesignCapacity') + 18;
var designCapacity2 = designCapacity1 + 4;

var maxCapacity1 = compileIt.search('RawMaxCapacity') + 18;
var maxCapacity2 = maxCapacity1 + 4;
var maxCap = compileIt.slice(maxCapacity1, maxCapacity2)

var batVolt1 = compileIt.search('Voltage') + 9;
var batVolt2 = batVolt1 + 4;
var batVolt = compileIt.slice(batVolt1, batVolt2)

var batCycles1 = compileIt.search('CycleCount') + 12;
var batCycles2 = batCycles1 + 4;
var batCycles = compileIt.slice(batCycles1, batCycles2)

var designCap = compileIt.slice(designCapacity1, designCapacity2)
var maxInPec = maxCap / designCap * 100;
maxInPec = Math.round(maxInPec)

maxInPec = maxInPec.toString()

maxInPec = maxInPec.replace('|', ' ');
maxInPec = maxInPec.replace('=', '')
maxInPec = maxInPec.replace(',', '')
batVolt = batVolt.replace('|', '')
batVolt = batVolt.replace('=', '')
batVolt = batVolt.replace(',', '')
batCycles = batCycles.replace('|', '')
batCycles = batCycles.replace('=', '')
batCycles = batCycles.replace(',', '')
maxCap = maxCap.replace('|', '')
maxCap = maxCap.replace('=', '')
maxCap = maxCap.replace(',', '')
designCap = designCap.replace('|', '')
designCap = designCap.replace('=', '')
designCap = designCap.replace(',', '')

document.getElementById('compiled').innerHTML = 'Max capacity in mAh: ' + maxCap + 
'<br>Original max capacity in mAh: ' + designCap +
'<br>Max capacity in percent: ' + maxInPec + '%' +
'<br>Battery Voltage: ' + batVolt +
'<br>Total Amount Of Cycles: ' + batCycles;

var network = document.getElementById('network').innerText;

network = network.replace('ether', '<br>MAC:')
network = network.replace('inet ', '<br>inet/ip: ')
network = network.replace('inet6', '<br>inet6:')
network = network.replace('nd6', '<br>nd6:')

network = network.substring(0, network.search('media'))

document.getElementById('network').innerHTML = network

shutdowns = document.getElementById('shutdowns').innerHTML;
shutdowns = shutdowns.replace(/shutdown/g, '<br>shutdown')
shutdowns = shutdowns.replace('wtmp', '<br>wtmp')
document.getElementById('shutdowns').innerHTML = shutdowns;
reboots = document.getElementById('reboots').innerHTML;
reboots = reboots.replace(/reboot/g, '<br>reboot')
reboots = reboots.replace('wtmp', '<br>wtmp')
document.getElementById('reboots').innerHTML = reboots;

disks = document.getElementById('disks').innerHTML;
disks = disks.replace(new RegExp('/dev/', 'g'), '<br><br>/dev/')
document.getElementById('disks').innerHTML = disks;

}
</script>
" > $path
	echo -e "${CYAN} Saved file at $path"
}

BATT() {
	echo -e "${CYAN} $result ${NC}"
}

STRESSTEST() {
	echo -e "${CYAN} Starting stress test"
	yes > /dev/null & yes > /dev/null & yes > /dev/null & yes > /dev/null & yes > /dev/null &
	echo -e "${CYAN} Started stress test to stop it use './etaBat.sh -killstress'"
}

KILLSTRESS() {
	echo -e "${CYAN} Trying to stop stress test, killing it 5 times to make sure"
	killall yes
	killall yes
	killall yes
	killall yes
	killall yes
	echo -e "${CYAN} If stress test was running it is stopped now"
}

HELP_LIST() {
	echo -e "${CYAN}  -help | Shows this"
	echo -e "${CYAN}  -writefile | Makes a HTML file on users desktop named macDebug.html with all debug info"
	echo -e "${CYAN}  -stresstest | Makes a bunch of empty processes at /dev/null to get the CPU to 100% usage"
	echo -e "${CYAN}  -killstress | Kills all the empty processes and perfomance should return to normal"
	echo -e "${CYAN}  -shutdown | Prints all available shutdowns"
	echo -e "${CYAN}  -reboot | Prints all available reboots"
	echo -e "${CYAN}  -network | Prints network info"
	echo -e "${CYAN}  -misc | Prints miscellaneous info such as device name and UUID"
	echo -e "${CYAN}  -battinfo | Prints battery info more detailed version in '-writefile'"
	echo -e "${CYAN}  -disklist | Prints out list of mounted disks and partitions more readable version in '-writefile'"
}

case $1 in
	-writefile)
		SAVE_TO_FILE
		;;
	-stresstest)
		STRESSTEST
		;;
	-killstress)
		KILLSTRESS
		;;
	-shutdown)
		echo -e "${CYAN}Available list of all shutdowns"
		echo -e "${CYAN}$shutdownList"
		;;
	-reboot)
		echo -e "${CYAN}Available list of all reboots"
		echo -e "${CYAN}$rebootList"
		;;
	-network)
		echo -e "${CYAN}$networkEn0";
		;;
	-battinfo)
		echo -e "${CYAN}$result"
		echo -e "${CYAN}For more detailed version use -writefile"
		;;
	-misc)
		echo -e "${CYAN}Device Info: $deviceuname"
		echo -e "${CYAN}Device UUID: $uuid"
		echo -e "${CYAN}$SIP"
		;;
	-disklist)
		echo -e "${CYAN}$diskList"
		;;
	-version)
		echo -e "${CYAN}macDebug Version: $version"
		;;
	-help)
		HELP_LIST
		;;
	*)
		echo -e "${YO}You need to add a valid argument try -help"
		echo -e "${YO}You either forgot to enter an argument or didn't type it right"
		;;
esac

echo -e "${NC}"