#!/usr/bin/env bash
#
# Generate Forminator stubs from the source directory.
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

HEADER=$'/**\n * Generated stub declarations for Forminator.\n * @see https://wpmudev.com/project/forminator-pro/\n * @see https://github.com/mralaminahamed/phpstan-forminator-stubs\n */'

FILE="$ROOT_DIR/forminator-stubs.stub"
FILE_CONSTANTS="$ROOT_DIR/forminator-constants-stubs.stub"
GENERATOR_BIN="$ROOT_DIR/vendor/bin/generate-stubs"
FINDER_FILE="$ROOT_DIR/configs/finder.php"

set -e

test -f "$FILE" || touch "$FILE"
test -f "$FILE_CONSTANTS" || touch "$FILE_CONSTANTS"
test -d "$ROOT_DIR/source/forminator"

"$GENERATOR_BIN" \
    --include-inaccessible-class-nodes \
    --force \
    --finder="$FINDER_FILE" \
    --header="$HEADER" \
    --functions \
    --classes \
    --interfaces \
    --traits \
    --out="$FILE"

"$GENERATOR_BIN" \
    --include-inaccessible-class-nodes \
    --force \
    --finder="$FINDER_FILE" \
    --header="$HEADER" \
    --constants \
    --out="$FILE_CONSTANTS"
