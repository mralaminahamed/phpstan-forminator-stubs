#!/usr/bin/env bash
#
# Generate Forminator stubs from the latest versions.
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

set -e

git -C "$ROOT_DIR" fetch --all
git -C "$ROOT_DIR" reset --hard origin/main

WC_JSON="$(wget -q -O- "https://api.wordpress.org/plugins/info/1.0/forminator.json")"

OUTPUT_FILE="$ROOT_DIR/forminator_versions.txt"
> "$OUTPUT_FILE"

VERSIONS=$(jq -r '."versions" | keys[]' <<<"$WC_JSON" | grep -v "trunk" | sort -V)
for VERSION in $VERSIONS; do
    echo "$VERSION" >> "$OUTPUT_FILE"
done

if git -C "$ROOT_DIR" show-ref --tags | grep -q "refs/tags/vtrunk"; then
    git -C "$ROOT_DIR" tag -d vtrunk
fi

while IFS= read -r VERSION; do
    echo "Processing version ${VERSION} ..."

    if git -C "$ROOT_DIR" rev-parse "refs/tags/v${VERSION}" >/dev/null 2>&1; then
        echo "Tag exists for version ${VERSION}! Skipping..."
        continue
    fi

    rm -rf "$ROOT_DIR/source/forminator" 2>/dev/null || true
    rm -f "$ROOT_DIR/source/forminator."*.zip 2>/dev/null || true

    wget -q -P "$ROOT_DIR/source/" "https://downloads.wordpress.org/plugin/forminator.${VERSION}.zip"
    unzip -q -o -d "$ROOT_DIR/source/" "$ROOT_DIR/source/forminator.${VERSION}.zip"

    echo "Generating stubs for version ${VERSION}..."
    "$SCRIPT_DIR/generate.sh"

    if git -C "$ROOT_DIR" diff-index --quiet HEAD --; then
        echo "No changes to commit for version ${VERSION}. Skipping tag..."
    else
        git -C "$ROOT_DIR" add .
        git -C "$ROOT_DIR" commit --all -m "Generate stubs for Forminator ${VERSION}"
        git -C "$ROOT_DIR" tag "v${VERSION}"
    fi

    rm -rf "$ROOT_DIR/source/forminator" 2>/dev/null || true
    rm -f "$ROOT_DIR/source/forminator."*.zip 2>/dev/null || true
done < "$OUTPUT_FILE"

echo "All versions processed."
