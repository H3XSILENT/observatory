#!/usr/bin/env bash

# Threads
THREADS=25
TIMEOUT=10

# Status codes
STATUS_CODES="200,201,204,301,302,307,308,401,403,405,500,502,503,504"

# User-Agent rotation
UA_FILE="/usr/share/seclists/Fuzzing/User-Agents/user-agents.txt"

# Tools paths
NUCLEI_TEMPLATES="/usr/share/nuclei-templates"

# Stealth mode
STEALTH=true
DELAY=1

# Scope file (optional)
SCOPE_FILE=""
