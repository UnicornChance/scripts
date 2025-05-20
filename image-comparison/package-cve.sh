#!/bin/bash

# List of packages to scan
packages=(
  backup-restore
  base
  identity-authorization
  logging
  metrics-server
  monitoring
  runtime-security
)

# Clean old results if needed
rm -rf cve
mkdir -p cve/scans

# Run vulnerability scans for each package
for package in "${packages[@]}"; do
  echo "🔍 Scanning package: $package"
  uds run -f tasks/scan.yaml single-layer-scan --set PACKAGE="$package"
  echo "✅ Finished: $package"
  echo "-----------------------------"
done

# Output file
output="image-comparison-artifacts/combined-vulnerability-report.md"
rm -rf $output

echo "# Combined Vulnerability Report" > "$output"
echo "" >> "$output"

# Combine individual reports into a single Markdown file
for md_file in cve/scans/core-*-vulnerability-report.md; do
  package_name=$(basename "$md_file" | sed 's/^core-\(.*\)-vulnerability-report\.md$/\1/')
  echo "🔗 Adding report for: $package_name"

  echo "<details><summary><code>${package_name}</code></summary>" >> "$output"
  echo "" >> "$output"
  cat "$md_file" >> "$output"
  echo "" >> "$output"
  echo "---" >> "$output"
  echo "" >> "$output"
  echo "</details>" >> "$output"
  echo "" >> "$output"
done

echo "✅ Combined report written to $output"
