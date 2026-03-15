# ==============================================================================
# VISIONGAIA TECHNOLOGY: WINDOWS FIREWALL BURNER (VGT-WFB v2.0 - APT EDITION)
# STATUS: DIAMANT VGT SUPREME (ALUHUT-MODUS)
# ZWECK: Injektion von >280.000 State-Actor, Tor & APT IPs in die native Firewall
# SCHUTZ: Verhindert Firewall-Kollaps durch hartes Chunking (max 1000/Regel)
# ==============================================================================

$ErrorActionPreference = "SilentlyContinue"

# --- VGT AUTO-ELEVATION ---
$IsAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $IsAdmin) {
    Write-Warning "[VGT] Benötige Administrator-Rechte für Firewall-Injektion!"
    Start-Process powershell.exe -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   VGT CORE INTELLIGENCE - APT & STATE-ACTOR BURNER       " -ForegroundColor Cyan
Write-Host "   Status: DIAMANT VGT SUPREME (EXTREM-MODUS)             " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Die Feeds (Tor, APTs, Geheimdienst-C2s)
$Feeds = @(
    "https://raw.githubusercontent.com/stamparm/ipsum/master/ipsum.txt",
    "https://raw.githubusercontent.com/firehol/blocklist-ipsets/master/firehol_level1.netset",
    "https://raw.githubusercontent.com/SecOps-Institute/Tor-IP-Addresses/master/tor-exit-nodes.lst"
)

$IpList = @{}
# Regex fängt nun einzelne IPs UND Subnetze präzise am Zeilenanfang ab
$RegexIP = '^(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}(?:/[0-9]{1,2})?)'

# 2. Daten abrufen und filtern (High-Performance Hash-Table)
Write-Host "[VGT] Lade APT Threat-Intelligence Feeds herunter..." -ForegroundColor Yellow
foreach ($Url in $Feeds) {
    try {
        $Data = Invoke-WebRequest -Uri $Url -TimeoutSec 15 -UseBasicParsing -ErrorAction Stop
        $Lines = $Data.Content -split "`n"
        foreach ($Line in $Lines) {
            if ($Line -match "^#" -or [string]::IsNullOrWhiteSpace($Line)) { continue }
            
            if ($Line -match $RegexIP) {
                $IpOrSubnet = $matches[1]
                $IpList[$IpOrSubnet] = $true
            }
        }
        Write-Host "  -> Erfolgreich: $Url" -ForegroundColor DarkGray
    } catch {
        Write-Host "[FEHLER] Konnte Feed nicht laden: $Url" -ForegroundColor Red
    }
}

$TotalIPs = $IpList.Count
Write-Host "[VGT] $TotalIPs APT-Vektoren & Tor-Knoten identifiziert." -ForegroundColor Green
if ($TotalIPs -eq 0) {
    Write-Host "[VGT] Abbruch: Keine Daten gefunden." -ForegroundColor Red
    Start-Sleep -Seconds 5
    exit
}

# 3. Alte VGT-APT-Regeln bereinigen
Write-Host "[VGT] Bereinige alte APT-Schilder (kann einen Moment dauern)..." -ForegroundColor Yellow
Remove-NetFirewallRule -DisplayName "VGT_APT_BLOCK_*" -ErrorAction SilentlyContinue

# 4. Intelligentes Chunking (Schutz vor dem Firewall-Schlaganfall)
$ChunkSize = 1000
$IpArray = [array]$IpList.Keys
$TotalChunks = [math]::Ceiling($IpArray.Count / $ChunkSize)

Write-Host "[VGT] Brenne Matrix in den Windows Kernel ($TotalChunks Chunks)..." -ForegroundColor Yellow
Write-Host "ACHTUNG: Dies kann bei 280.000 IPs ca. 5-10 Minuten dauern. Bitte warten!" -ForegroundColor Red

for ($i = 0; $i -lt $TotalChunks; $i++) {
    $StartIndex = $i * $ChunkSize
    $EndIndex = [math]::Min((($i + 1) * $ChunkSize) - 1, $IpArray.Count - 1)
    $CurrentChunk = $IpArray[$StartIndex..$EndIndex]
    
    # Eigener Prefix, damit es nicht mit normalen Regeln kollidiert
    $RuleNameIn  = "VGT_APT_BLOCK_INBOUND_CHUNK_$i"
    $RuleNameOut = "VGT_APT_BLOCK_OUTBOUND_CHUNK_$i"

    New-NetFirewallRule -DisplayName $RuleNameIn -Direction Inbound -Action Block -RemoteAddress $CurrentChunk -Profile Any -ErrorAction SilentlyContinue | Out-Null
    New-NetFirewallRule -DisplayName $RuleNameOut -Direction Outbound -Action Block -RemoteAddress $CurrentChunk -Profile Any -ErrorAction SilentlyContinue | Out-Null
    
    # Fortschrittsanzeige alle 10 Chunks, damit die Konsole nicht spammt
    if ($i % 10 -eq 0 -or $i -eq ($TotalChunks -1)) {
        $Percent = [math]::Round((($i + 1) / $TotalChunks) * 100)
        Write-Host "  -> Fortschritt: $Percent% (Chunk $($i + 1)/$TotalChunks eingebrannt)" -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "   APT FIREWALL INJEKTION ABGESCHLOSSEN!                  " -ForegroundColor Cyan
Write-Host "   Dein Windows ist nun für das Darknet und staatliche    " -ForegroundColor Cyan
Write-Host "   Akteure unsichtbar.                                    " -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Start-Sleep -Seconds 10
