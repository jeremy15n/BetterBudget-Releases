#!/usr/bin/env bash
# Scan selected GitHub release assets with VirusTotal API v3 and write results to VIRUSTOTAL_RESULTS.md.
set -euo pipefail

: "${VT_API_KEY:?VT_API_KEY is required (repo secret)}"
: "${GITHUB_TOKEN:?}"
: "${GITHUB_EVENT_PATH:?}"
: "${GITHUB_REPOSITORY:?}"
: "${GITHUB_WORKSPACE:?}"
: "${GITHUB_DEFAULT_BRANCH:?Set GITHUB_DEFAULT_BRANCH (default branch name)}"

# Files ≤ this size use POST /files; larger files use GET /files/upload_url then POST (VT public API).
VT_DIRECT_MAX_BYTES="${VT_DIRECT_MAX_BYTES:-${VT_MAX_BYTES:-33554432}}"
# VirusTotal documents ~650 MB max for large upload URLs.
VT_LARGE_MAX_BYTES="${VT_LARGE_MAX_BYTES:-681574400}"
VT_REGEX="${VT_REGEX:-\\.(exe|msi)$}"
VT_POLL_SECS="${VT_POLL_SECS:-15}"
VT_POLL_ATTEMPTS="${VT_POLL_ATTEMPTS:-40}"

TAG="$(jq -r '.release.tag_name' "${GITHUB_EVENT_PATH}")"
export TAG

mapfile -t ASSET_LINES < <(jq -c '.release.assets // [] | .[]' "${GITHUB_EVENT_PATH}")

report_lines=()
report_lines+=("Scanned from workflow [\`${GITHUB_WORKFLOW}\`](${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID}) at \`${GITHUB_SHA:0:7}\`.")
report_lines+=("")
report_lines+=("| Asset | Size | SHA256 | Malicious | Suspicious | Harmless | Undetected | [VirusTotal](https://www.virustotal.com/) |")
report_lines+=("| --- | ---: | --- | ---: | ---: | ---: | ---: | --- |")

scanned=0
considered=0

vt_get_json() {
  local url=$1
  curl -fsS "$url" -H "x-apikey: ${VT_API_KEY}"
}

vt_poll_analysis() {
  local analysis_id=$1
  local attempt=0 status=""
  local ar
  while (( attempt < VT_POLL_ATTEMPTS )); do
    sleep "${VT_POLL_SECS}"
    ar="$(vt_get_json "https://www.virustotal.com/api/v3/analyses/${analysis_id}")"
    status="$(echo "${ar}" | jq -r '.data.attributes.status')"
    case "${status}" in
      completed) echo "${ar}"; return 0 ;;
      queued|in-progress) attempt=$((attempt + 1)) ;;
      *) echo "Unexpected VirusTotal status '${status}': ${ar}" >&2; return 1 ;;
    esac
  done
  echo "Timed out waiting for VirusTotal analysis ${analysis_id}" >&2
  return 1
}

scan_asset_file() {
  local path=$1 name=$2
  local sha resp analysis_id ar bytes upload_url
  sha="$(sha256sum "${path}" | awk '{print $1}')"
  bytes="$(stat -c%s "${path}")"

  if (( bytes > VT_LARGE_MAX_BYTES )); then
    report_lines+=("| \`${name}\` | $(numfmt --to=iec "${bytes}") | \`${sha}\` | — | — | — | — | Skipped (>${VT_LARGE_MAX_BYTES} bytes; over VirusTotal large-upload limit) |")
    return 0
  fi

  if (( bytes <= VT_DIRECT_MAX_BYTES )); then
    resp="$(curl -sS -X POST "https://www.virustotal.com/api/v3/files" \
      -H "x-apikey: ${VT_API_KEY}" \
      --form "file=@${path}")"
  else
    upload_url="$(curl -sS "https://www.virustotal.com/api/v3/files/upload_url" \
      -H "x-apikey: ${VT_API_KEY}" | jq -r '.data // empty')"
    if [[ -z "${upload_url}" ]]; then
      echo "VirusTotal upload_url failed for '${name}'" >&2
      return 1
    fi
    resp="$(curl -sS -X POST "${upload_url}" \
      -H "x-apikey: ${VT_API_KEY}" \
      --form "file=@${path}")"
  fi

  analysis_id="$(echo "${resp}" | jq -r '.data.id // empty')"
  if [[ -z "${analysis_id}" ]]; then
    echo "VirusTotal upload failed for '${name}': ${resp}" >&2
    return 1
  fi

  ar="$(vt_poll_analysis "${analysis_id}")"
  local mal sus harm und
  mal="$(echo "${ar}" | jq -r '.data.attributes.stats.malicious // 0')"
  sus="$(echo "${ar}" | jq -r '.data.attributes.stats.suspicious // 0')"
  harm="$(echo "${ar}" | jq -r '.data.attributes.stats.harmless // 0')"
  und="$(echo "${ar}" | jq -r '.data.attributes.stats.undetected // 0')"

  local vt_link="https://www.virustotal.com/gui/file/${sha}"
  report_lines+=("| \`${name}\` | $(numfmt --to=iec "$(stat -c%s "${path}")") | \`${sha}\` | ${mal} | ${sus} | ${harm} | ${und} | [View](${vt_link}) |")
  scanned=$((scanned + 1))
}

tmpdir="$(mktemp -d)"
trap 'rm -rf "${tmpdir}"' EXIT

for line in "${ASSET_LINES[@]:-}"; do
  [[ -n "${line}" ]] || continue
  id="$(echo "${line}" | jq -r '.id')"
  name="$(echo "${line}" | jq -r '.name')"
  size="$(echo "${line}" | jq -r '.size')"
  url="$(echo "${line}" | jq -r '.url')"

  if [[ ! "${name}" =~ $VT_REGEX ]]; then
    continue
  fi

  considered=$((considered + 1))

  dest="${tmpdir}/${name}"
  curl -fsSL \
    -H "Accept: application/octet-stream" \
    -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    -H "X-GitHub-Api-Version: 2022-11-28" \
    -o "${dest}" \
    "${url}"

  scan_asset_file "${dest}" "${name}"
done

if (( scanned == 0 && considered == 0 )); then
  report_lines+=("| — | — | — | — | — | — | — | No assets matched \`${VT_REGEX}\` (or release has no assets). |")
fi

report_lines+=("")
report_lines+=("_VirusTotal [terms](https://docs.virustotal.com/docs/terms-of-service) apply; results are indicative, not a guarantee._")

VT_BLOCK="$(printf '%s\n' "${report_lines[@]}")"

RESULTS_FILE="${VT_RESULTS_FILE:-VIRUSTOTAL_RESULTS.md}"

cd "${GITHUB_WORKSPACE}"

git config user.name "github-actions[bot]"
git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

git fetch origin "${GITHUB_DEFAULT_BRANCH}"
git pull --rebase origin "${GITHUB_DEFAULT_BRANCH}"

{
  printf '%s\n' "# VirusTotal release scans"
  printf '%s\n' ""
  printf '%s\n' "Results below are produced when a [release](${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/releases) is **published**. Workflow: [\`${GITHUB_WORKFLOW}\`](${GITHUB_SERVER_URL}/${GITHUB_REPOSITORY}/actions/runs/${GITHUB_RUN_ID})."
  printf '%s\n' ""
  printf '%s\n' "## ${TAG}"
  printf '%s\n' ""
  printf '%s\n' "${VT_BLOCK}"
} >"${RESULTS_FILE}"

if git diff --quiet "${RESULTS_FILE}"; then
  echo "${RESULTS_FILE} unchanged; nothing to commit."
  exit 0
fi

git add "${RESULTS_FILE}"
git commit -m "docs: VirusTotal results for ${TAG}"
git push origin "${GITHUB_DEFAULT_BRANCH}"

echo "Committed VirusTotal summary to ${RESULTS_FILE} on ${GITHUB_DEFAULT_BRANCH} for release ${TAG}."
