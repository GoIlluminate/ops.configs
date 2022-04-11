# Illuminate-Release Scripts

## Illuminate-Release directory structure
```bash
sample-release-directory
    ├── logs
    │   └── sample_log.log
    ├── packages
    │   └── sample_package.msi
    └── scripts
        └── sample_script.ps1
```

## Illuminate-Release scripts
* `msi_installation.ps1` 
  * Installs all packages under `packages` directory
  and logs all log files for each application under `logs` directory.
    * Log file for each application will be overwritten after installation.