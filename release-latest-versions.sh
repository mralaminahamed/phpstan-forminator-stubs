#!/usr/bin/env bash

# Generate Forminator stubs from all available versions.
set -e

# Fetch the latest changes from the remote repository.
git fetch --all
git reset --hard origin/main

# Fetch plugin information from WordPress.org.
WC_JSON="$(wget -q -O- "https://api.wordpress.org/plugins/info/1.0/forminator.json")"

# Prepare output file.
OUTPUT_FILE="forminator_versions.txt" > "$OUTPUT_FILE"

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
        echo "Tag exists for version ${VERSION}! Skipping..."
        continue
    fi

    # Clean up source/ directory, keeping composer.json and .gitignore.
    find source/ -mindepth 1 ! -name 'composer.json' ! -name '.gitignore' -exec rm -rf {} +

    # Download the new version.
    wget -P source/ "https://downloads.wordpress.org/plugin/forminator.${VERSION}.zip"
    unzip -q -d source/ "source/forminator.${VERSION}.zip"

    # Generate stubs.
    echo "Generating stubs for version ${VERSION}..."
    ./generate.sh

    # Check if there are any changes to commit.
    if git diff-index --quiet HEAD --; then
        echo "No changes to commit for version ${VERSION}. Skipping tag..."
    else
        # Commit and tag the new version.
        echo "Tagging version ${VERSION}..."
        git add .
        git commit --all -m "Generate stubs for Forminator ${VERSION}"
        git tag "v${VERSION}"
    fi

    # Clean up the source directory to prevent conflicts.
    find source/ -mindepth 1 ! -name 'composer.json' ! -name '.gitignore' -exec rm -rf {} +
done < "$OUTPUT_FILE"

echo "All versions processed."
