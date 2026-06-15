#!/usr/bin/env bash
#
# Generate Forminator stubs from all available versions.
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

set -e

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
        echo "Tag exists for version ${VERSION}!"
        continue
    fi

    git -C "$ROOT_DIR" status --ignored --short -- source/ | sed -n -e 's#^!! ##p' | xargs --no-run-if-empty -- rm -rf

    {
        wget -q -P "$ROOT_DIR/source/" "https://downloads.wordpress.org/plugin/forminator.${VERSION}.zip"
        unzip -q -d "$ROOT_DIR/source/" "$ROOT_DIR/source/forminator.${VERSION}.zip"

        echo "Generating stubs ..."
        "$SCRIPT_DIR/generate.sh"

        git -C "$ROOT_DIR" add .
        git -C "$ROOT_DIR" commit --all -m "Generate stubs for Forminator ${VERSION}"
        git -C "$ROOT_DIR" tag "v${VERSION}"
    } || {
        echo "Failed to process version ${VERSION}. Skipping..."
    }

    rm -rf "$ROOT_DIR/source/"*
done < "$OUTPUT_FILE"

echo "All versions processed."
