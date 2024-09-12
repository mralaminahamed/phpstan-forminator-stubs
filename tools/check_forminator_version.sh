#!/usr/bin/env bash

# Check for new Forminator plugin versions

set -euo pipefail

PLUGIN_NAME="forminator"
API_URL="https://api.wordpress.org/plugins/info/1.0/${PLUGIN_NAME}.json"
LOCAL_VERSIONS_FILE="../${PLUGIN_NAME}_versions.txt"

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

get_latest_wp_version() {
    local plugin_json
    if ! plugin_json=$(wget -q -O- "${API_URL}"); then
        log "Failed to fetch plugin data"
        exit 1
    fi

    echo "${plugin_json}" | jq -r '.version'
}

get_latest_local_version() {
    if [ ! -f "${LOCAL_VERSIONS_FILE}" ]; then
        echo ""
        return
    fi

    sort -V "${LOCAL_VERSIONS_FILE}" | tail -n 1
}

main() {
    log "Initiating version check"

    local wp_version
    wp_version=$(get_latest_wp_version)

    local local_version
    local_version=$(get_latest_local_version)

    if [ -z "${local_version}" ]; then
        log "No local versions found"
        log "Latest WordPress.org version: ${wp_version}"
        log "Run the main script to process all versions"
        exit 0
    fi

    log "WordPress.org version: ${wp_version}"
    log "Local version: ${local_version}"

    if [ "${wp_version}" = "${local_version}" ]; then
        log "Local version is up to date"
    elif [ "$(echo -e "${wp_version}\n${local_version}" | sort -V | tail -n 1)" = "${wp_version}" ]; then
        log "New version available: ${wp_version}"
        log "Run the main script to process the new version"
    else
        log "Warning: Local version (${local_version}) is ahead of WordPress.org version (${wp_version})"
        log "This may indicate a version numbering issue or API inconsistency"
    fi
}

main "$@"
