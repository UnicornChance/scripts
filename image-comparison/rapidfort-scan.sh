#!/usr/bin/env bash

set -euo pipefail

output_file="image-comparison-artifacts/rfscan-cve-comparison.md"
mkdir -p "$(dirname "$output_file")"
rm -f "$output_file"

# Format: "CGR_IMAGE|RF_IMAGE"
image_pairs=(
  "ghcr.io/defenseunicorns/pepr/private/controller:v0.48.1|quay.io/rfcurated/node:22.14.0-jammy-fips-rfcurated"
  "cgr.dev/du-uds-defenseunicorns/istio-pilot-fips:1.25.2|quay.io/rfcurated/istio-pilot:1.22.7-jammy-fips-rfcurated-rfhardened"
  "cgr.dev/du-uds-defenseunicorns/istio-proxy-fips:1.25.2|quay.io/rfcurated/istio-proxyv2:1.22.7-jammy-fips-rfcurated-rfhardened"
  "cgr.dev/du-uds-defenseunicorns/istio-install-cni:1.25.2|quay.io/rfcurated/istio-install-cni:1.22.7-jammy-fips-rfcurated-rfhardened"
  "cgr.dev/du-uds-defenseunicorns/metrics-server-fips:0.7.2|quay.io/rfcurated/metrics-server:0.7.2-jammy-scratch-fips-rfcurated-rfhardened"
  "cgr.dev/du-uds-defenseunicorns/keycloak:26.2.1|quay.io/rfcurated/keycloak:26.2.3-jammy-rfcurated"
  "cgr.dev/du-uds-defenseunicorns/loki-fips:3.5.0|quay.io/rfcurated/grafana/loki:3.3.2-jammy-fips-rfcurated-rfhardened"
  "cgr.dev/du-uds-defenseunicorns/nginx-fips:1.27.5|quay.io/rfcurated/nginx:1.27.5-slim-jammy-fips-rfcurated-rfhardened"
  "cgr.dev/du-uds-defenseunicorns/kube-state-metrics-fips:2.15.0|quay.io/rfcurated/kube-state-metrics:2.15.0-jammy-scratch-fips-rfcurated-rfhardened"
  "cgr.dev/du-uds-defenseunicorns/prometheus-node-exporter-fips:1.9.1|quay.io/rfcurated/prometheus/node-exporter:1.9.1-jammy-scratch-fips-rfcurated"
  "cgr.dev/du-uds-defenseunicorns/prometheus-operator-fips:0.81.0|quay.io/rfcurated/prometheus-operator:0.82.1-jammy-scratch-fips-rfcurated"
  "cgr.dev/du-uds-defenseunicorns/prometheus-alertmanager-fips:0.28.1|quay.io/rfcurated/prometheus/alertmanager:0.28.1-jammy-fips-rfcurated-rfhardened"
  "cgr.dev/du-uds-defenseunicorns/prometheus-config-reloader-fips:0.81.0|quay.io/rfcurated/prometheus-operator/prometheus-config-reloader:0.82.1-jammy-scratch-fips-rfcurated"
  "cgr.dev/du-uds-defenseunicorns/prometheus-fips:3.2.1|quay.io/rfcurated/prometheus:3.3.1-jammy-fips-rfcurated-rfhardened"
  "cgr.dev/du-uds-defenseunicorns/kube-webhook-certgen-fips:1.12.1|quay.io/rfcurated/ingress-nginx/kube-webhook-certgen:1.5.3-jammy-fips-rfcurated-rfhardened"
  "cgr.dev/du-uds-defenseunicorns/vector:0.46.1|quay.io/rfcurated/vector:0.46.1-jammy-fips-rfcurated-rfhardened"
  "cgr.dev/du-uds-defenseunicorns/kubectl-fips:1.33.0-dev|quay.io/rfcurated/kubectl:1.33.0-jammy-scratch-fips-rfcurated"
  "cgr.dev/du-uds-defenseunicorns/grafana-fips:11.6.1|quay.io/rfcurated/grafana:11.6.1-jammy-scratch-fips-rfcurated"
  "cgr.dev/du-uds-defenseunicorns/memcached-fips:1.6.38|quay.io/rfcurated/memcached:1.6.38-jammy-fips-rfcurated-rfhardened"
  "cgr.dev/du-uds-defenseunicorns/k8s-sidecar-fips:1.30.3|quay.io/rfcurated/k8s-sidecar:1.30.3-jammy-scratch-fips-rfcurated-rfhardened"
  "cgr.dev/du-uds-defenseunicorns/busybox-fips:1.37.0|quay.io/rfcurated/busybox:1.37.0-glibc-rf.1-rfcurated"
  "cgr.dev/du-uds-defenseunicorns/authservice-fips:1.0.4|quay.io/rfcurated/istio-ecosystem/authservice:1.0.4-jammy-scratch-fips-rfcurated"
  "cgr.dev/du-uds-defenseunicorns/velero-fips:1.16.0-dev|quay.io/rfcurated/velero/velero:1.16.0-jammy-scratch-fips-rfcurated"
  "cgr.dev/du-uds-defenseunicorns/velero-plugin-for-aws-fips:1.12.0|quay.io/rfcurated/velero/velero-plugin-for-aws:1.12.0-jammy-scratch-fips-rfcurated"
  "velero/velero-plugin-for-microsoft-azure:v1.12.0|quay.io/rfcurated/velero/velero-plugin-for-microsoft-azure:1.12.0-jammy-scratch-fips-rfcurated"
  "cgr.dev/du-uds-defenseunicorns/ztunnel-fips:1.25.2|quay.io/rfcurated/istio/ztunnel:1.26.0-jammy-scratch-fips-rfcurated"
  "cgr.dev/du-uds-defenseunicorns/curl-fips:8.12.1|"
  "cgr.dev/du-uds-defenseunicorns/neuvector-manager:5.4.3|"
  "cgr.dev/du-uds-defenseunicorns/neuvector-enforcer-fips:5.4.3|"
  "cgr.dev/du-uds-defenseunicorns/neuvector-controller-fips:5.4.3|"
  "docker.io/neuvector/scanner:latest|"
  "cgr.dev/du-uds-defenseunicorns/neuvector-updater-fips:8.12.1-dev|"
)

TMPLOG="rfscan_tmp.log"

# Header
{
  echo '| # | CGR Image | CGR CVEs | Delta | RF CVEs | RF Image |'
  echo '|----|-----------|----------|--------|---------|----------|'
} > "$output_file"

get_cve_count() {
  local image=$1
  local critical=0 high=0

  if [[ -n "$image" ]]; then
    echo "🔍 Scanning $image..." >&2
    docker pull "$image" > /dev/null 2>&1 || true
    rfscan "$image" > "$TMPLOG" 2>&1

    critical=$(grep -Po '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3}:\s+Critical:\s+\K[0-9]+' "$TMPLOG" || echo "")
    high=$(grep -Po '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2},\d{3}:\s+High:\s+\K[0-9]+' "$TMPLOG" || echo "")

    [[ "$critical" =~ ^[0-9]+$ ]] || critical=0
    [[ "$high" =~ ^[0-9]+$ ]] || high=0

    echo $((critical + high))
  else
    echo ""
  fi
}

i=1
for pair in "${image_pairs[@]}"; do
  IFS='|' read -r cgr_image rf_image <<< "$pair"

  cgr_cves="" rf_cves="" delta=""

  [[ -n "$cgr_image" ]] && cgr_cves=$(get_cve_count "$cgr_image")
  [[ -n "$rf_image" ]] && rf_cves=$(get_cve_count "$rf_image")

  # Compute delta only if both are present and numeric
  if [[ "$cgr_cves" =~ ^[0-9]+$ && "$rf_cves" =~ ^[0-9]+$ ]]; then
    delta_val=$((rf_cves - cgr_cves))
    delta=$([[ $delta_val -ge 0 ]] && echo "+$delta_val" || echo "$delta_val")
  elif [[ "$cgr_cves" =~ ^[0-9]+$ && -z "$rf_cves" ]]; then
    delta="+$cgr_cves"
  elif [[ -z "$cgr_cves" && "$rf_cves" =~ ^[0-9]+$ ]]; then
    delta="-$rf_cves"
  fi

  # Output row
  echo "| $i | \`${cgr_image:-}\` | ${cgr_cves:-} | ${delta:-} | ${rf_cves:-} | \`${rf_image:-}\` |" >> "$output_file"
  ((i++))
done

rm -f "$TMPLOG"
echo -e "\n✅ Scan complete. Output saved to \e[32m$output_file\e[0m"
