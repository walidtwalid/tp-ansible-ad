# enable-winrm.ps1
# À exécuter UNE fois sur chaque Windows Server, dans PowerShell lancé en administrateur :
#   powershell -ExecutionPolicy Bypass -File .\enable-winrm.ps1
# Active WinRM pour qu'Ansible puisse piloter ce serveur depuis la VM Ubuntu.

# 1. Active WinRM (écoute HTTP sur le port 5985), même si le réseau est en profil "Public"
Enable-PSRemoting -Force -SkipNetworkProfileCheck

# 2. Ouvre le port 5985 dans le pare-feu, quel que soit le profil réseau
if (-not (Get-NetFirewallRule -Name "WinRM-HTTP-TP" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule -Name "WinRM-HTTP-TP" -DisplayName "WinRM HTTP (TP Ansible)" `
        -Protocol TCP -LocalPort 5985 -Direction Inbound -Action Allow -Profile Any
}

# 3. Démarre WinRM automatiquement au démarrage
Set-Service -Name WinRM -StartupType Automatic
Start-Service -Name WinRM

# 4. Vérification : doit afficher un écouteur "Transport = HTTP, Port = 5985"
winrm enumerate winrm/config/listener
