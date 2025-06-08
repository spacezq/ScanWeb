# ScanWeb

ScanWeb is an automated web domain enumeration and vulnerability scanning tool. It performs passive reconnaissance, subdomain enumeration, live domain detection, vulnerability scanning with customizable templates, and exports data to Burp Suite for further manual testing.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Setup](#setup)
- [Usage](#usage)
- [Tools Used](#tools-used)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- Passive subdomain enumeration using multiple popular tools  
- Live domain detection with fast HTTP probing  
- URL crawling and parameter extraction  
- Vulnerability scanning using Nuclei with template support  
- Directory fuzzing with FFUF  
- Automatic export of discovered URLs to Burp Suite proxy  
- Modular design for easy updates and customization  

---

## Installation

Clone the repository and navigate to the project directory:

```
git clone https://github.com/spacezq/ScanWeb.git
cd ScanWeb
sudo apt install dos2unix
```

---

## Setup

To automate the installation of required tools, run the setup script:

```
dos2unix setup.sh
chmod +x setup.sh
./setup.sh
```

This will install all necessary dependencies and tools on Kali Linux, Ubuntu, or similar Debian-based systems.

---

## Usage

Run the main scanning script with the target domain as argument:

```
./auto.sh 
```

Replace `` with the target domain you want to scan.

The script will perform:

1. Passive subdomain enumeration  
2. Live domain detection  
3. URL crawling and parameter extraction  
4. Vulnerability scanning with Nuclei and directory fuzzing with FFUF  
5. Sending discovered URLs to Burp Suite proxy for further manual testing  

Results will be saved in folders under the target domain directory.

Example:

```
./auto.sh example.com
```

---

## Tools Used

- **Subfinder**: Passive subdomain enumeration  
- **Assetfinder**: Subdomain discovery tool  
- **Findomain**: Fast subdomain finder  
- **Amass**: Comprehensive attack surface mapping  
- **Httpx**: HTTP probing for live domain detection  
- **Waymore**: URL and parameter extraction crawler  
- **Katana**: Web crawler with parameter extraction  
- **Nuclei**: Template-based vulnerability scanner  
- **FFUF**: HTTP fuzzer for directories and parameters  
- **GNU Parallel**: Parallel execution utility  
- **Qsreplace**: URL parameter manipulation tool  

---

## Contributing

Contributions are welcome! Please open issues or pull requests to improve features or fix bugs.

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

---



[1] https://github.com/spacezq/ScanWeb.git
[2] https://github.com/TermuxHackz/WebScan
[3] https://github.com/spark1security/n0s1
[4] https://pentest-tools.com/information-gathering/find-subdomains-of-domain
[5] https://github.com/mgriit/ScanAppForWeb
[6] https://help.hcl-software.com/appscan/ASoC/src_run_scan_wizard_github.html
[7] https://github.com/GovernIB/pluginsib-scanweb/actions
[8] https://github.com/GovernIB/pluginsib-scanweb/milestone/2
[9] https://docs.solidityscan.com/project/
[10] https://enlacehacktivista.org/index.php/Scanning_and_Recon
[11] https://github.com/capture0x/web-scanner
