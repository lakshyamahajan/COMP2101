param ( [switch]$System, [switch]$Disks, [switch]$Network)

if ($System) {   
HardwareInfo  
OSInfo
ProcessorInfo
PhysicalMemoryInfo
VideoInfo
}
elseif ($Disks) { 
DiskInfo
}
elseif ($Network) { 
NetworkInfo
}

else {

HardwareInfo
OSInfo
ProcessorInfo
PhysicalMemoryInfo
DiskInfo
NetworkInfo
VideoInfo

}
