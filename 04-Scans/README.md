# rvuln – Reconnaissance & Vulnerability Automation Framework

rvuln is a modular reconnaissance and vulnerability scanning framework designed for offensive security research, bug bounty workflows, and red‑team automation.

Built with a professional pipeline mindset: **recon → crawl → parameter mining → scanning**.

---

## Features

- Subdomain enumeration (Subfinder, Findomain)  
- Live host resolution (httpx)  
- URL crawling (GAU, Hakrawler)  
- Parameter extraction and reflection‑parameter detection (Gxss)  
- Fragment (`#`) harvesting for DOM‑based attack surface  
- Technology fingerprinting (httpx)  
- HTTP status intelligence report  
- Modular scanning pipeline (Nuclei, Dalfox, Subjack, SQLMap)  
- Stealth mode with configurable delays  
- Modular architecture (easy to extend and adapt)

---

## Philosophy

rvuln is **not a one‑click auto‑pwn script**.

It follows a professional bug‑bounty methodology:

1. Passive reconnaissance  
2. Surface mapping  
3. Target filtering  
4. Controlled active scanning  

**Signal > noise.** Automation supports thinking; it does not replace it.

---

## Directory Structure

```text
rvuln/
├── main.sh        # Entry point
├── config.sh      # Global configuration
├── utils.sh       # Logging and helper functions
├── recon.sh       # Subdomain discovery and host resolution
├── crawl.sh       # URL discovery and crawling
├── params.sh      # Parameter and fragment extraction
├── scan.sh        # Technology detection and vulnerability scanners
└── data/          # Output directory
```

---

## Requirements

Install the following tools:

- subfinder  
- findomain  
- httpx  
- gau  
- hakrawler  
- gxss  
- nuclei  
- dalfox  
- subjack  
- sqlmap  

Recommended:

- Seclists  

---

## Installation

```bash
git clone https://github.com/HexSilent/rvuln.git
cd rvuln
chmod +x *.sh
```

### Usage

**Standard Recon Mode (Safe)**

```bash
./main.sh example.com
```

**Aggressive Mode (Active Scanners)**

```bash
./main.sh example.com --aggressive
```

> **Warning:** Aggressive mode may trigger WAFs, rate limits, or violate scope policies.

---

## Output Structure

```text
data/
├── recon/
│   ├── subs.txt
│   ├── resolv.txt
├── crawl/
│   ├── urls.txt
├── params/
│   ├── parameters.txt
│   ├── reflected.txt
│   ├── fragments.txt
├── scan/
│   ├── tech.json
│   ├── status.txt
│   ├── nuclei.txt
│   ├── xss.txt
│   ├── sqlmap.txt
│   ├── takeover.txt
```

---

## Configuration

Edit `config.sh` to tune:

- Threads  
- Timeout  
- Delay (stealth mode)  
- Nuclei template path  
- User‑Agent list  

---

## Legal & Ethical Disclaimer

This tool is intended **exclusively for educational purposes and authorized security testing**.

You must:

- Have explicit permission to test the target  
- Respect bug‑bounty program scope and rules  
- Follow applicable local laws and regulations  

The author assumes **no responsibility** for misuse or unauthorized testing.

---

## Roadmap

- SQLite backend for recon history  
- Recon diff detection (new assets alert)  
- Proxy rotation and WAF‑adaptive rate control  
- TUI interface (ncurses)  
- JSON consolidated report export  
- Dockerized deployment  

---

## Author

HexSilent  
Offensive Security Researcher | Bug Bounty Hunter | Cyberpunk‑oriented engineer  

---

## Final Note

Automation makes you faster. Critical thinking makes you dangerous.
