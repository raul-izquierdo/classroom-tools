#!/usr/bin/env bash

show_versions() {
    java -jar roster.jar -V
    java -jar teams.jar -V
    java -jar solutions.jar -V
}

echo "Initial versions of 'roster.jar', 'teams.jar', and 'solutions.jar':"
show_versions

curl -fSL -o roster.jar https://github.com/raul-izquierdo/roster/releases/latest/download/roster.jar || { echo "ERROR: Failed to download roster.jar" >&2; rm -f roster.jar; exit 1; }
curl -fSL -o teams.jar https://github.com/raul-izquierdo/teams/releases/latest/download/teams.jar   || { echo "ERROR: Failed to download teams.jar" >&2; rm -f teams.jar; exit 1; }
curl -fSL -o solutions.jar https://github.com/raul-izquierdo/solutions/releases/latest/download/solutions.jar || { echo "ERROR: Failed to download solutions.jar" >&2; rm -f solutions.jar; exit 1; }

echo "All jars downloaded."

echo "Current versions of 'roster.jar', 'teams.jar', and 'solutions.jar':"
show_versions
