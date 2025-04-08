$report = ""

# Orphaned NICs
$nic = az network nic list --query "[?virtualMachine==null]" -o table
if ($nic) { $report += "`nOrphaned NICs:`n$nic" }

# Unattached Disks
$disks = az disk list --query "[?managedBy==null]" -o table
if ($disks) { $report += "`nUnattached Disks:`n$disks" }

# Unused Public IPs
$ips = az network public-ip list --query "[?ipConfiguration==null]" -o table
if ($ips) { $report += "`nUnused Public IPs:`n$ips" }

# Empty RGs
$groups = az group list --query "[?length(resources)==\`0`]" -o table
if ($groups) { $report += "`nEmpty Resource Groups:`n$groups" }

$report | Out-File -FilePath cleanup_report.txt
