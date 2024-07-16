#!/usr/bin/env bash
#
# Generate Forminator stubs from all the latest versions.
#

set -e

# Fetch plugin information from WordPress.org.
WC_JSON="$(wget -q -O- "https://api.wordpress.org/plugins/info/1.0/forminator.json")"

# Prepare output file.
OUTPUT_FILE="forminator_versions.txt"
> "$OUTPUT_FILE"

# Extract and filter versions, excluding "trunk".
VERSIONS=$(jq -r '."versions" | keys[]' <<<"$WC_JSON" | grep -v "trunk" | sort -V)

# Collect all versions.
for VERSION in $VERSIONS; do
    echo "$VERSION" >> "$OUTPUT_FILE"
done

# Remove the vtrunk tag if it exists.
if git show-ref --tags | grep -q "refs/tags/vtrunk"; then
    git tag -d vtrunk
fi

# Read the collected versions and process each one.
while IFS= read -r VERSION; do
    echo "Processing version ${VERSION} ..."

    if git rev-parse "refs/tags/v${VERSION}" >/dev/null 2>&1; then
        echo "Tag exists for version ${VERSION}!"
        continue
    fi

    # Clean up source/ directory
    git status --ignored --short -- source/ | sed -n -e 's#^!! ##p' | xargs --no-run-if-empty -- rm -rf

    # Try downloading and processing the version, handle errors
    {
        # Get new version
        wget -q -P source/ "https://downloads.wordpress.org/plugin/forminator.${VERSION}.zip"
        unzip -q -d source/ source/forminator.${VERSION}.zip

        # Generate stubs
        echo "Generating stubs ..."
        ./generate.sh

        # Add files
        echo "Adding files ..."
        git add .

        # Tag version
        echo "Tagging version ${VERSION} ..."
        git commit --all -m "Generate stubs for Fluent Form ${VERSION}"
        git tag "v${VERSION}"
    } || {
        echo "Failed to process version ${VERSION}. Skipping..."
    }

    # Clean up downloaded files to prevent conflicts
    echo "Cleaning up source/ directory ..."
    rm -rf source/*
done < "$OUTPUT_FILE"

echo "All versions processed."
