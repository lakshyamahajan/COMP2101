
function HardwareInfo {
get-wmiobject -class win32_computersystem         
}

function OSInfo {
Get-wmiobject -class win32_operatingsystem | Select-Object Name, Version | Format-List
}

function ProcessorInfo {
Get-WmiObject -class win32_processor | Select-Object Description, Maxclockspeed, Currentclockspeed,L1CacheSize,L2CacheSize,L3CacheSize | Format-List
}

function PhysicalMemoryInfo {
$physicalMemory = Get-WmiObject -class win32_physicalmemory

foreach($memory in $physicalMemory) {
 New-Object -TypeName psobject -Property @{
	 Vendor = $memory.manufacturer
	 Description = $memory.description
	 Size = $memory.capacity/1mb
	 Bank = $memory.banklabel
	 Slot = $memory.devicelocator
 } | ft -Auto  Vendor,Description,Size, Bank, Slot
 
 $totalcapacity += $memory.capacity/1mb
} 
"Total RAM: ${totalcapacity}MB " 
}

Function DiskInfo {
$diskdrives = Get-CIMInstance CIM_diskdrive

  foreach ($disk in $diskdrives) {
      $partitions = $disk|get-cimassociatedinstance -resultclassname CIM_diskpartition
      foreach ($partition in $partitions) {
            $logicaldisks = $partition | get-cimassociatedinstance -resultclassname CIM_logicaldisk
            foreach ($logicaldisk in $logicaldisks) {
                     new-object -typename psobject -property @{
															   Vendor = $disk.Manufacturer
                                                               Model=$disk.Model
                                                               Size=$logicaldisk.Size
                                                               Freespace=$logicaldisk.FreeSpace
                                                               PercentageFree=($logicaldisk.Freespace/$logicaldisk.Size)*100
                                                               }  | Format-Table -auto  Vendor, Model, Size, Freespace, PercentageFree
                                                               
           } 
           
      } 
  }  
 

} 

Function NetworkInfo {
Get-CimInstance win32_networkadapterconfiguration | Where-Object IPEnabled | Select-Object Description, Index, IPAddress, IPSubnet, DNSDomain, DNSServerSearchOrder | Format-Table
}

Function VideoInfo {
Get-WmiObject -Class Win32_VideoController | Select-Object -Property Description,@{Name="CurrentScreenResolution";Expression={ $_.CurrentHorizontalResolution.ToString() + " X " + $_.CurrentVerticalResolution.ToString() }} | Format-List
}


HardwareInfo
OSInfo
ProcessorInfo
PhysicalMemoryInfo
DiskInfo
NetworkInfo
VideoInfo
