#!/bin/bash

# Version information, variables used by IcnsXtr
VERSION="1.0.0"
COPYRIGHT="Copyright (c) 2024, Carnations Botánica"
CWD=$(pwd)
INPUT_DIR="$CWD/input"
OUTPUT_DIR="$CWD/output"


# Function to display the help message
show_help() {
  echo "IcnsXtr - Version $VERSION"
  echo "$COPYRIGHT"
  echo
  echo "Usage:"
  echo "  ./icnsxtr.sh <command>"
  echo
  echo "Commands:"
  echo "  help      Show this help message"
  echo "  start     Extract PNGs from an .icns file"
  echo "  list      List available .icns files in the current directory"
  echo "  open      Open the output folder of extracted PNGs"
  echo
}

# Function for 'start'
start_extraction() {
  echo "Starting extraction process..."

  if [ -d "$INPUT_DIR" ]; then
    icns_files=$(find "$INPUT_DIR" -maxdepth 1 -type f -name "*.icns")

    if [ -z "$icns_files" ]; then
      echo "No .icns files found in $INPUT_DIR."
    else
      for file in $icns_files; do
        icns_name=$(basename "$file" .icns)
        output_subdir="$OUTPUT_DIR/$icns_name"

        # Check if the output subdirectory already exists
        if [ -d "$output_subdir" ]; then
          echo "Output folder already exists: $output_subdir"
        else
          # Create the output subdirectory for the current .icns file
          mkdir -p "$output_subdir"
          echo "Created output folder: $output_subdir"
        fi
        
        echo "Processing: $icns_name.icns"

        # Extract the PNGs from the .icns file into the output folder
        if sips -s format png "$file" --out "$output_subdir"; then
          echo "Extraction complete for $icns_name.icns"
        else
          echo "Error extracting $icns_name.icns"
        fi
      done
    fi
  else
    echo "Input directory does not exist: $INPUT_DIR"
  fi
}

# Function for 'list'
list_icns_files() {
  # echo "Listing .icns files in $INPUT_DIR..."
  if [ -d "$INPUT_DIR" ]; then
    icns_files=$(find "$INPUT_DIR" -maxdepth 1 -type f -name "*.icns")
    
    if [ -z "$icns_files" ]; then
      echo "No .icns files found in $INPUT_DIR."
    else
      echo "Found the following .icns files:"
      for file in $icns_files; do
        echo "  - $(basename "$file")"
      done
    fi
  else
    echo "Input directory does not exist: $INPUT_DIR"
  fi
}

# Function for 'open'
open_output_folder() {
  echo "Opening the output folder ($OUTPUT_DIR)..."
  open "$OUTPUT_DIR"
}

# Main script logic, ensuring a command gets used
if [ "$#" -lt 1 ]; then
  echo "Error: No command provided. Use './icnsxtr.sh help' for usage."
  exit 1
fi

COMMAND=$1

# Handle different command cases
case "$COMMAND" in
  help)
    show_help
    ;;
  start)
    start_extraction
    ;;
  list)
    list_icns_files
    ;;
  open)
    open_output_folder
    ;;
  *)
    echo "Unknown command: $COMMAND"
    echo "Use './icnsxtr.sh help' for a list of available commands."
    exit 1
    ;;
esac
