<#

.SYNOPSIS
This script consolidates several printer related cmdlets to add a printer to a users computer. These include Add-PrinterDriver, Add-PrinterPort, and Add-Printer.

.PARAMETER ip
Takes the IP Address of the printer on the network to add.

.PARAMETER printer
The name of the printer to be added to the computer.

.PARAMETER driver
The driver that will be added to the printer port. Will accept HP, Lanier, or RICOH and accomodate generic drivers.

.PARAMETER computer
The computer name that the printer will be added to. If blank, will default to host computer.

.EXAMPLE
Map-Printer -ip 10.100.10.25 -computer BOBS-PC -driver "HP Universal Printing PCL 6" -printer BOBS-PRINTER
#>

Param(
    $ip, #IP address of printer
    $printer, #name of printer
    $driver, #brand of driver
    $computer #name of computer
)

#check for driver shortcut and add driver
if($driver -eq "HP"){
    $check = Get-PrinterDriver -Name "HP Universal Printing PCL 6" -ComputerName $computer
    if(!$check){
        Add-PrinterDriver -Name "HP Universal Printing PCL 6" -ComputerName $computer
    }
    $driver = "HP Universal Printing PCL 6"
}
elseif($driver -eq "Lanier"){
    $check = Get-PrinterDriver -Name "Lanier Universal v2" -ComputerName $computer
    if(!$check){
        Add-PrinterDriver -Name "Lanier Universal v2" -ComputerName $computer
    }
    $driver = "Lanier Universal v2"
}
elseif ($driver -eq "Ricoh") {
    $check = Get-PrinterDriver -Name "PCL6 Driver for Universal Print" -ComputerName $computer
    if(!$check){
        Add-PrinterDriver -Name "PCL6 Driver for Universal Print" -ComputerName -$computer
    }
    $driver = "PCL6 Driver for Universal Print"
}
else{
    $check = Get-PrinterDriver -Name $driver -ComputerName $computer
    if(!$check){
        try{Add-PrinterDriver -Name $driver -ComputerName $computer} catch{"The driver does not exist as entered."}
    }
}

#check open printer port
$portCheck = Get-PrinterPort -Name $ip -ComputerName $computer
if(!$portCheck){
    Add-PrinterPort -name $ip -PrinterHostAddress $ip -ComputerName $computer -SNMP 1 -SNMPCommunity 'public'
}

Add-Printer -ComputerName $computer -Name $printer -DriverName $driver -PortName $ip 
