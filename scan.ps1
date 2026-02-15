$env:PYTHONUTF8=1
checkov -d . | Tee-Object -FilePath checkov-report.txt
