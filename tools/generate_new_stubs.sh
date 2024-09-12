#!/usr/bin/env bash
# Generate Forminator stubs from all available versions.

set -euo pipefail

PLUGIN_NAME="forminator"
API_URL="https://api.wordpress.org/plugins/info/1.0/${PLUGIN_NAME}.json"
OUTPUT_FILE="../${PLUGIN_NAME}_versions.txt"
SOURCE_DIR="source"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

cleanup_source_dir() {
    log "Cleaning source directory"
    find "${SOURCE_DIR}/" -mindepth 1 ! -name 'composer.json' ! -name '.gitignore' -exec rm -rf {} +
}

process_version() {
    local version=$1
    log "Processing version ${version}"

    if git rev-parse --quiet --verify "refs/tags/v${version}" >/dev/null; then
        log "Version ${version} already processed. Skipping."
        return 0
    fi

    cleanup_source_dir

    if ! wget -q -P "${SOURCE_DIR}/" "https://downloads.wordpress.org/plugin/${PLUGIN_NAME}.${version}.zip" ||
       ! unzip -q -d "${SOURCE_DIR}/" "${SOURCE_DIR}/${PLUGIN_NAME}.${version}.zip" ||
       ! ./generate.sh; then
        log "Failed to process version ${version}"
        return 1
    fi

    if git diff-index --quiet HEAD --; then
        log "No changes for version ${version}. Skipping tag."
    else
        git add .
        git commit --all -m "Generate stubs for ${PLUGIN_NAME^} ${version}"
        git tag "v${version}"
        log "Version ${version} tagged successfully"
    fi

    cleanup_source_dir
    return 0
}

main() {
    log "Initializing stub generation process"

    git fetch --all
    git reset --hard origin/main

    local plugin_json
    if ! plugin_json=$(wget -q -O- "${API_URL}"); then
        log "Failed to fetch plugin data"
        exit 1
    fi

    local versions
    versions=$(jq -r '."versions" | keys[] | select(. != "trunk")' <<< "${plugin_json}" | sort -V)

    if [ -z "${versions}" ]; then
        log "No versions found"
        exit 1
    fi

    echo "${versions}" > "${OUTPUT_FILE}"

    git tag -d vtrunk 2>/dev/null || true

    while IFS= read -r version; do
        process_version "${version}"
    done < "${OUTPUT_FILE}"

    log "Stub generation process completed"
}

main "$@"
