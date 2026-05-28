# DevOps Bash Automation Scripts

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Shell Script](https://img.shields.io/badge/Language-Bash-blue.svg)](https://www.gnu.org/software/bash/)

## Bash Scripts for Backup Automation and ELK Workflows

This repository contains a sanitized collection of Bash scripts developed during my professional DevOps engineering work in the infrastructure context of a FinTech startup.

The scripts automate routine infrastructure tasks such as MongoDB/MySQL backup generation, backup retention, remote synchronization, and JSON ingestion into Elasticsearch/ELK.

All credentials, IP addresses, hostnames, ports, and company-specific information have been removed or replaced with placeholders.

## Overview

The repository includes lightweight Bash scripts for:

* MongoDB backup automation.
* MySQL backup automation.
* Remote backup synchronization using `scp` or `rsync`.
* Backup retention and cleanup policies.
* JSON ingestion into Elasticsearch.
* Simple JSON/file preprocessing utilities.

These scripts are shared as practical examples of Bash-based DevOps automation and infrastructure scripting.

## Repository Structure

```text
.
├── README.md
├── LICENSE
├── CITATION.cff
└── scripts
    ├── Backup_Live.sh
    ├── Backup_Test.sh
    ├── Backup_Period.sh
    ├── post2elk.sh
    ├── rename.sh
    └── spaceremover.sh
```

## Scripts

| Script             | Description                                                                                                                       |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------------- |
| `Backup_Live.sh`   | Creates timestamped MongoDB and MySQL backups for a live environment and transfers them to a remote backup location.              |
| `Backup_Test.sh`   | Creates timestamped MongoDB and MySQL backups for a test/staging environment and synchronizes them with a remote backup location. |
| `Backup_Period.sh` | Applies backup retention rules by deleting old backup folders after a defined number of days.                                     |
| `post2elk.sh`      | Sends local JSON files to an Elasticsearch index using HTTP POST requests.                                                        |
| `rename.sh`        | Appends the `.json` extension to files in a target directory.                                                                     |
| `spaceremover.sh`  | Removes spaces, tabs, and newline characters from files and stores compacted outputs as JSON files.                               |

## Typical Use Cases

These scripts are useful for demonstrating or implementing:

* Scheduled database backup workflows.
* Backup rotation and retention policies.
* Remote backup transfer between servers.
* Basic disaster-recovery preparation.
* Lightweight ELK/Elasticsearch ingestion workflows.
* Bash scripting for operational DevOps tasks.

## Usage

Clone the repository:

```bash
git clone https://github.com/ahmadtanhaa/Automata.git
cd Automata
```

Make a script executable:

```bash
chmod +x scripts/Backup_Test.sh
```

Run the script:

```bash
./scripts/Backup_Test.sh
```

Before running any script, update the required placeholders, such as:

```bash
MYSQL_USER="your_mysql_user"
MYSQL_PASSWORD="your_mysql_password"
MONGO_USER="your_mongo_user"
MONGO_PASSWORD="your_mongo_password"
REMOTE_USER="backup_user"
REMOTE_HOST="backup.example.com"
REMOTE_PORT="22"
BACKUP_DIR="/path/to/backup"
```

For production environments, it is strongly recommended to use environment variables or a secure secrets-management solution instead of hard-coded credentials.

## Example Cron Usage

A backup script can be scheduled with `cron`, for example:

```bash
0 2 * * * /path/to/Automata/scripts/Backup_Live.sh
```

This example runs the live backup script every day at 02:00.

A retention script can also be scheduled periodically:

```bash
0 4 * * * /path/to/Automata/scripts/Backup_Period.sh
```

## Security Notice

These scripts are provided in sanitized form for portfolio, educational, and reproducibility purposes.

Before using them in a real production environment, please review and adapt them carefully.

Recommended security practices:

* Do not hard-code passwords in scripts.
* Use environment variables or secret-management tools.
* Use dedicated backup users with limited privileges.
* Avoid direct root SSH access.
* Use SSH keys with restricted permissions.
* Restrict access to backup directories.
* Encrypt sensitive backups when required.
* Validate all paths before running deletion commands.
* Test retention policies in a safe environment before production deployment.
* Add logging and error handling for production usage.

## Disclaimer

These scripts are not directly connected to any current or former employer infrastructure.

All sensitive information has been removed. The repository does not contain private data, internal hostnames, production credentials, proprietary business logic, or confidential company information.

The scripts are shared only as examples of Bash-based infrastructure automation.


## Citation

If you use or refer to this repository, please cite it as:

```bibtex
@misc{Tanha_Automata_2026,
  author       = {Tanha, Ahmad},
  title        = {DevOps Bash Automation Scripts for Backup and ELK Workflows},
  year         = {2026},
  howpublished = {\url{https://github.com/ahmadtanhaa/Automata}},
  note         = {Sanitized Bash scripts for database backup automation, retention policies, remote synchronization, and Elasticsearch JSON ingestion}
}
```

## Author

**Ahmad Tanha**

GitHub: https://github.com/ahmadtanhaa

## License

This repository is distributed under the Apache License 2.0.

See the `LICENSE` file for more details.

