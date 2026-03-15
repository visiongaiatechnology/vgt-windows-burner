# 🔥 VGT Windows Firewall Burner — APT & State-Actor Shield

[![License](https://img.shields.io/badge/License-AGPLv3-green?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Windows-0078D4?style=for-the-badge&logo=windows)](https://microsoft.com/windows)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-5391FE?style=for-the-badge&logo=powershell)](https://microsoft.com/powershell)
[![Status](https://img.shields.io/badge/Status-DIAMANT-purple?style=for-the-badge)](#)
[![Feeds](https://img.shields.io/badge/Threat_IPs-280.000+-red?style=for-the-badge)](#)
[![VGT](https://img.shields.io/badge/VGT-VisionGaia_Technology-red?style=for-the-badge)](https://visiongaiatechnology.de)
[![Donate](https://img.shields.io/badge/Donate-PayPal-00457C?style=for-the-badge&logo=paypal)](https://www.paypal.com/paypalme/dergoldenelotus)

> *"Make your Windows invisible to state actors, APTs, and the darknet."*

**VGT Windows Firewall Burner** injects over **280,000 verified threat IPs** — Tor exit nodes, APT command-and-control servers, and state-actor infrastructure — directly into the native Windows Firewall. No third-party software. No background services. Pure Windows kernel-level blocking.

---

## 🔗 VGT Windows Security Ecosystem

This tool is part of the VGT Windows Security Suite. Use both for maximum protection:

| Tool | Purpose |
|---|---|
| 🔍 **[VGT Civilian Checker](https://github.com/visiongaiatechnology/Winsyssec)** | Audits your system — shows WHERE you are vulnerable |
| 🔥 **VGT Windows Firewall Burner** | Blocks the attackers before they arrive |

> **Civilian Checker first — Firewall Burner second.** Know your exposure, then eliminate it.

---

## 🚨 The Problem With Standard Windows Security

The Windows Firewall out of the box blocks nothing by default on outbound traffic. Known APT infrastructure, Tor exit nodes, and state-actor C2 servers can freely communicate with your machine.

| Standard Windows Firewall | VGT Windows Firewall Burner |
|---|---|
| ❌ No threat intelligence | ✅ 280,000+ verified threat IPs |
| ❌ No APT blocking | ✅ Mandiant / Kaspersky APT feeds |
| ❌ Tor traffic allowed | ✅ All Tor exit nodes blocked |
| ❌ State-actor C2 open | ✅ Known C2 infrastructure blocked |
| ❌ Manual rule management | ✅ Fully automated injection |
| ❌ Rules lost on reinstall | ✅ Native Windows Firewall — survives reboots |

---

## 🛡️ Threat Intelligence Sources — The Aluhut Feeds

```
stamparm/ipsum          →  Aggregates 30+ feeds incl. Mandiant & Kaspersky APT tracking
firehol/blocklist-ipsets →  Global high-risk C2 nodes (firehol_level1)
SecOps-Institute        →  Tor exit node list (covert C2 routing)
```

Combined: **280,000+ IPs and subnets** covering state actors, APTs, botnets, and anonymization infrastructure.

---

## ⚡ How It Works

```
Script starts → Auto-elevates to Administrator
    ↓
Downloads 3 live threat intelligence feeds
    ↓
Deduplicates into a hash table (high-performance)
    ↓
Removes old VGT rules (clean slate)
    ↓
Injects IPs in chunks of 1,000 (prevents firewall collapse)
    ↓
280,000+ IPs burned into Windows Firewall kernel
    ↓
Inbound + Outbound blocked permanently
```

**Chunking is critical** — injecting 280,000 IPs as a single rule would crash the Windows Firewall service. The Burner splits everything into 1,000-IP chunks, each as a separate rule, preventing firewall collapse.

---

## 📊 Live Progress Output

```
==========================================================
   VGT CORE INTELLIGENCE - APT & STATE-ACTOR BURNER
   Status: DIAMANT VGT SUPREME (ALUHUT-MODUS)
==========================================================

[VGT] Lade APT Threat-Intelligence Feeds herunter...
  -> Erfolgreich: stamparm/ipsum
  -> Erfolgreich: firehol_level1
  -> Erfolgreich: Tor exit nodes
[VGT] 284,731 APT-Vektoren & Tor-Knoten identifiziert.
[VGT] Bereinige alte APT-Schilder...
[VGT] Brenne Matrix in den Windows Kernel (285 Chunks)...
  -> Fortschritt: 10% (Chunk 29/285 eingebrannt)
  -> Fortschritt: 20% (Chunk 57/285 eingebrannt)
  ...
  -> Fortschritt: 100% (Chunk 285/285 eingebrannt)

==========================================================
   APT FIREWALL INJEKTION ABGESCHLOSSEN!
   Dein Windows ist nun für das Darknet und staatliche
   Akteure unsichtbar.
==========================================================
```

---

## 🚀 Installation

### Requirements
- Windows 10 / 11 / Server 2019+
- PowerShell 5.1+
- Administrator privileges
- Internet connection (for live feed download)

### Setup

**Step 1 — Download the script:**
```powershell
git clone https://github.com/visiongaiatechnology/vgt-windows-burner.git
cd vgt-windows-burner
```

**Step 2 — Right-click → Run as Administrator**

Or via PowerShell as Administrator:
```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\VGT-WindowsBurner.ps1
```

**Step 3 — Wait 5–10 minutes**

280,000+ rules take time to inject. The progress display keeps you informed.

**Done.** Your Windows Firewall now blocks all known APT and Tor infrastructure.

---

## ♻️ Updating the Blocklist

The feeds update regularly. Re-run the script to refresh:

```powershell
# Old VGT rules are automatically removed and replaced
.\VGT-WindowsBurner.ps1
```

The script cleans up all previous `VGT_APT_BLOCK_*` rules before injecting fresh data.

---

## 🔍 Verify the Rules

```powershell
# Count active VGT rules
(Get-NetFirewallRule -DisplayName "VGT_APT_BLOCK_*").Count

# View inbound rules
Get-NetFirewallRule -DisplayName "VGT_APT_BLOCK_INBOUND_*" | Select DisplayName, Enabled

# Remove all VGT rules (emergency rollback)
Remove-NetFirewallRule -DisplayName "VGT_APT_BLOCK_*"
```

---

## 📦 System Specs

```
INJECTION_TARGET   Windows Firewall (native kernel-level)
THREAT_FEEDS       3 live sources (stamparm, firehol, SecOps-Institute)
TOTAL_IPs          280,000+ (IPv4 IPs and subnets)
CHUNK_SIZE         1,000 IPs per rule (prevents firewall collapse)
DIRECTIONS         Inbound + Outbound blocked
PERSISTENCE        Survives reboots (native Windows Firewall rules)
RUNTIME            ~5-10 minutes for full injection
DEPENDENCIES       Zero — pure PowerShell + native Windows API
```

---

## ⚠️ Important Notes

- **Run as Administrator** — Windows Firewall requires elevated privileges
- **Injection takes 5–10 minutes** — do not close the window
- **Re-run monthly** — threat feeds update regularly
- **Emergency rollback** — `Remove-NetFirewallRule -DisplayName "VGT_APT_BLOCK_*"` removes all rules instantly
- **Performance impact** — 280,000+ firewall rules have minimal CPU impact on modern hardware. Windows Firewall evaluates rules in kernel space.

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first.

Licensed under **AGPLv3** — *"For Humans, not for SaaS Corporations."*

---

## ☕ Support the Project

VGT Windows Firewall Burner is free. If it protects your machine:

[![Donate via PayPal](https://img.shields.io/badge/Donate-PayPal-00457C?style=for-the-badge&logo=paypal)](https://www.paypal.com/paypalme/dergoldenelotus)

---

## 🏢 Built by VisionGaia Technology

[![VGT](https://img.shields.io/badge/VGT-VisionGaia_Technology-red?style=for-the-badge)](https://visiongaiatechnology.de)

VisionGaia Technology builds enterprise-grade security and AI tooling — engineered to the DIAMANT VGT SUPREME standard.

> *"The Windows Firewall knows nothing about APTs. Now it does."*

---

*Version 2.0 (APT EDITION) — VGT Windows Firewall Burner // State-Actor & Tor Shield*
