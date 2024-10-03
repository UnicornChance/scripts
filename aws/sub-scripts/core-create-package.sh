#!/bin/bash

# Exit immediately if any command exits with a non-zero status
set -e

SCRIPT_DIR="$1"

source "$SCRIPT_DIR/config.env"

### Build / Create Core package
echo -e "\tCreate Core Package.\n"

# Change to the directory where the core package should be built
cd "$UDS_CORE_PATH"

# Run the uds command in the correct directory
if ! ZARF_ARCHITECTURE="$ZARF_ARCHITECTURE" uds run -f "tasks/create.yaml" standard-package --no-progress --set FLAVOR="$FLAVOR"; then
    echo -e "\tERROR: Failed to create Core Package. Exiting.\n"
    exit 1
fi

echo -e "\tCompleted Core Package Creation.\n"

cd $SCRIPT_DIR