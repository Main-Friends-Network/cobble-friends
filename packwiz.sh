#!/bin/sh

# Nutzung:
# ./packwiz.sh <packwiz-Befehl> [Optionen]
# Beispiel:
# ./packwiz.sh modrinth add sodium

set -e
IMAGE="packwiz:latest"

# Aktuelles Verzeichnis + /pack als Volume mounten
docker run --rm -it \
    -v "$(pwd)/pack:/workspace" \
    -w /workspace \
    "$IMAGE" "$@"