$config_path = '.\Cloudflare_Tunnel_Management.psd1'
if (Test-Path $config_path){
    $config = Import-PowerShellDataFile -Path $config_path
}
else {
    Write-Error "Configuration file not found at path: $config_path"
    exit
}

function Start-CloudflareAccessRDPTunnel {
    param(
        [string]$TunnelName = "",
        [string]$Domain = "",
        [string]$Subdomain = "",
        [string]$Url = "",
        [string]$LocalAddress
    )
    if (-not (Test-Path "C:\01_Logs\cloudflared")) {
        New-Item -Path "C:\01_Logs\cloudflared" -ItemType Directory | Out-Null
    }
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $logPath = "C:\01_Logs\cloudflared\_$TunnelName_$timestamp.log"
    $cmd = "cloudflared access rdp --hostname $Subdomain.$Domain --url $Url *> `"$logPath`""

    Show-Title -Title "$TunnelName Tunnel Running"
    Write-Host "Command Being Run: cloudflared access rdp --hostname $Subdomain.$Domain --url $Url"
    Write-Host "`nInstructions:"
    Write-Host "- Launch Remote Desktop and connect to: $LocalAddress"
    Write-Host "- When finished, close the Cloudflared window to return to the menu.`n"
    Write-Host "- Note: cloudflared log output can be found at: C:\01_Logs\cloudflared\`n"

    Write-Host "Launching tunnel..."
    $process = Start-Process powershell -ArgumentList "-NoExit", "-Command", $cmd -WindowStyle Normal -PassThru

    # Wait for the cloudflared window to close
    while (-not $process.HasExited) {
        Start-Sleep -Seconds 2
    }

    Write-Host "`nTunnel has closed. Press Enter to return to the menu."
    Read-Host
}

function Show-Title {
    param(
        [string]$Title = 'Cloudflare Tunnel Management'
    )
    Clear-Host
    Write-Host "================ $Title ================"
}
function Show-TunnelUpMenu {
    do {
        Show-Title -Title "Cloudflare Tunnel Management"
        Write-Host "1) Start $($config.Server1.TunnelName) $($config.Server1.Application) Tunnel"
        Write-Host "2) Start $($config.Server2.TunnelName) $($config.Server2.Application) Tunnel"
        Write-Host "3) Start $($config.Server3.TunnelName) $($config.Server3.Application) Tunnel"
        Write-Host "4) Go Back"
        $selectionTunnelUpMenu = Read-Host "Select an option"
    
        switch ($selectionTunnelUpMenu){
            '1' {
                Start-CloudflareAccessRDPTunnel -TunnelName $config.Server1.TunnelName -Domain $config.Server1.Domain -Subdomain $config.Server1.Subdomain -Url $config.Server1.Url -LocalAddress $config.Server1.LocalAddress
            }
            '2' {
                Start-CloudflareAccessRDPTunnel -TunnelName $config.Server2.TunnelName -Domain $config.Server2.Domain -Subdomain $config.Server2.Subdomain -Url $config.Server2.Url -LocalAddress $config.Server2.LocalAddress
            }
            '3' {
                Start-CloudflareAccessRDPTunnel -TunnelName $config.Server3.TunnelName -Domain $config.Server3.Domain -Subdomain $config.Server3.Subdomain -Url $config.Server3.Url -LocalAddress $config.Server3.LocalAddress
            }
            '4' {
                break
            }
            default { 
                Write-Host "Invalid option. Press enter to continue."
                Read-Host 
            }
        }
    
    } while ($selectionTunnelUpMenu -ne '4')
}

function Show-MainMenu {
    do {

        Show-Title -Title "Cloudflare Tunnel Management"
        Write-Host "1) Setup Tunnel"
        Write-Host "2) Exit"
        $selectionMainMenu = Read-Host "Select an option"
    
        switch ($selectionMainMenu){
            '1' {
                Show-TunnelUpMenu
            }
            '2' {
                Write-Host "Exiting..."
                break
            }
            default { 
                Write-Host "Invalid option. Press enter to continue."
                Read-Host
            }
        }
    
    } while ($selectionMainMenu -ne '2')
}

Show-MainMenu