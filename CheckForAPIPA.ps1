#check for APIPA 
$IP = (Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object -ExpandProperty IPAddress) -like "*.*"  #the MAC-Address is also written with the IP because of this we select the IP with the statement like "*.*"
foreach ($i in 1..3) {  

    if ($IP -like "169.254.*.*") { #if the IP is like 169.254.*.* then 
        Write-host "APIPA - IP will be released and renewed" -ForegroundColor Red
        Set-NetIPInterface -InterfaceAlias LAN1 -Dhcp Enabled #Enable DHCP
        (Get-WmiObject -List | Where-Object -FilterScript {$_.Name -eq "Win32_NetworkAdapterConfiguration"}).InvokeMethod("ReleaseDHCPLeaseAll", $null)  #Release IP
        (Get-WmiObject -List | Where-Object -FilterScript {$_.Name -eq "Win32_NetworkAdapterConfiguration"}).InvokeMethod("ReleaseDHCPLeaseAll", $null)  #Release IP
        (Get-WmiObject -List | Where-Object -FilterScript {$_.Name -eq "Win32_NetworkAdapterConfiguration"}).InvokeMethod("RenewDHCPLeaseAll", $null) #Get a IP
        $IP = @(@(Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object -ExpandProperty IPAddress) -like "*.*")[0] #save new IP into the variable IP
        $IP 
        Write-Host 'Tries:' $i'/3' 
        Start-Sleep -s 10
        continue
    } else { 
        Write-Host 'Tries:' $i'/3' 
        Write-Host 'No APIPA'    
        break  
        } 
}

