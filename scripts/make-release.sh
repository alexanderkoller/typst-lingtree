#!/usr/bin/env bash

set -euo pipefail

PACKAGE="lingtree"
ROOT=$(cd "$(dirname "$0")/.." && pwd)

usage() {
  echo "Usage: $0 VERSION"
  echo "Example: $0 0.1.0"
}

if [[ $# -ne 1 ]]; then
  usage >&2
  exit 2
fi

VERSION=$1
if [[ ! "$VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+([+-][0-9A-Za-z.-]+)?$ ]]; then
  echo "Version must be a SemVer triple such as 0.1.0." >&2
  exit 2
fi

RELEASE_DIR="$ROOT/release/preview/$PACKAGE/$VERSION"
BUILD_DIR=$(mktemp -d)
trap 'rm -rf "$BUILD_DIR"' EXIT

cd "$ROOT"

# Keep the source manifest and README imports on the version being released.
sed -E "s/^version = \"[^\"]+\"/version = \"$VERSION\"/" typst.toml > "$BUILD_DIR/typst.toml"
mv "$BUILD_DIR/typst.toml" typst.toml
sed -E "s#@preview/$PACKAGE:[0-9]+\.[0-9]+\.[0-9]+([+-][0-9A-Za-z.-]+)?#@preview/$PACKAGE:$VERSION#g" README.md > "$BUILD_DIR/README.md"
mv "$BUILD_DIR/README.md" README.md

echo "Compiling tests and example..."
for source in tests/*.typ examples/demo.typ; do
  output="$BUILD_DIR/$(basename "${source%.typ}").pdf"
  typst compile --root "$ROOT" "$source" "$output"
done

echo "Assembling $PACKAGE $VERSION..."
rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR/src" "$RELEASE_DIR/docs" "$RELEASE_DIR/examples" "$RELEASE_DIR/output/pdf"
cp typst.toml README.md LICENSE lib.typ "$RELEASE_DIR/"
cp src/*.typ "$RELEASE_DIR/src/"
cp docs/reference.md "$RELEASE_DIR/docs/"
cp -R docs/images "$RELEASE_DIR/docs/"
cp examples/demo.typ "$RELEASE_DIR/examples/"
cp output/pdf/lingtree-demo.pdf "$RELEASE_DIR/output/pdf/"

# Exercise package resolution against precisely the files being submitted.
PACKAGE_PATH="$BUILD_DIR/packages"
mkdir -p "$PACKAGE_PATH/preview/$PACKAGE"
cp -R "$RELEASE_DIR" "$PACKAGE_PATH/preview/$PACKAGE/$VERSION"
printf '#import "@preview/%s:%s": syntree\n#syntree[[S [NP release] [VP works]]]\n' \
  "$PACKAGE" "$VERSION" > "$BUILD_DIR/import-test.typ"
typst compile --package-path "$PACKAGE_PATH" \
  "$BUILD_DIR/import-test.typ" "$BUILD_DIR/import-test.pdf"

echo "Release snapshot ready at release/preview/$PACKAGE/$VERSION"
echo "Submit it with: ../typst-publish/typst-publish.sh"
