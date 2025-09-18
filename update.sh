#!/usr/bin/env bash
# Linux/macOS equivalent of update.cmd
# This script guides the user through updating the roster and then runs the Teams tool.

set -o pipefail

# Step prompts
echo "[Step 1] Get an updated file of students (for example, \"alumnosMatriculados.xls\")."
read -r -p "Press Enter when you have the updated file to continue..." _

echo "[Step 2] Get an updated roster file (\"classroom_roster.csv\")."
read -r -p "Press Enter when you have the updated file to continue..." _

# Run roster update
echo "Running: java -jar roster.jar update"
java -jar roster.jar update
rc=$?

# Handle return codes from roster update
case "$rc" in
  1)
    echo
    echo The roster requires changes. Please follow these steps:
    echo 1. Apply the suggested changes to the roster using the web interface.
    echo 2. Download an updated "classroom_roster.csv".
    echo 3. Run this script "./update.sh" again to continue once you've made the changes.
    exit 1
    ;;
  2)
    echo
    echo "An error occurred while analysing the roster. Stopping."
    exit 2
    ;;
  0)
    # Continue if success (exit code 0)
    echo "The roster is updated. Continuing..."
    echo "Running: java -jar teams.jar"
    java -jar teams.jar
    rc2=$?
    exit "$rc2"
    ;;
  *)
    echo
    echo "Unexpected exit code $rc from 'java -jar roster.jar update'. Stopping."
    exit "$rc"
    ;;
fi
