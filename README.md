# ScanWeb

Auto_scanweb is an automated web domain enumeration and vulnerability scanning script. It performs passive reconnaissance, subdomain enumeration, live domain detection, vulnerability scanning, and sends data to Burp Suite for further manual testing.

## Table of Contents
- [Installation](#installation)
- [Setup](#setup)
- [Usage](#usage)
- [Tools Used](#tools-used)

## Installation

To get started with Auto_scanweb, clone the repository and navigate to the project directory:

```bash
git clone https://github.com/spacezq/ScanWeb.git
cd ScanWeb
sudo apt install dos2unix
```
Automated Setup
Alternatively, you can use the provided setup.sh script to automate the installation process for the required tools:

Run the conversion command on the setup.sh file:

```bash
dos2unix setup.sh
```

```bash
chmod +x setup.sh
./setup.sh
```
This script will install the necessary tools on a Kali Linux or Ubuntu system.

Usage
To run the Auto_scanweb script, use the following command:

```bash
./auto.sh <domain>
```
Replace <domain> with the target domain you want to scan. The script will perform the following actions:

Passive Enumeration: Subdomain enumeration using multiple tools.
Vulnerability Scanning: Scan live domains and identified parameters using Nuclei.
Data Export to Burp Suite: Sends all discovered URLs to Burp Suite for further manual testing.
Example:
```bash
./auto.sh example.com
```
The results will be saved in the respective folders created under the domain's directory.

Tools Used
Auto_scanweb utilizes the following tools for domain enumeration and scanning:
Subfinder: Fast passive subdomain enumeration tool.
Assetfinder: Another tool for finding subdomains.
Findomain: High-performance subdomain finder.
Amass: OWASP Amass performs network mapping of attack surfaces and external asset discovery using open source information gathering and active reconnaissance techniques.
Httpx: Fast and multi-purpose HTTP toolkit.
Waymore: A powerful crawler that extracts URLs and parameters.
Katana: Web crawling tool with parameter extraction.
Nuclei: Fast, customizable vulnerability scanner based on template files.
Ffuf: Fuzzing tool for discovering directories, files, and parameters.
GNU Parallel: Utility for executing jobs in parallel.
