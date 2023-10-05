#!/bin/bash

# Script argument handling reference: https://joshtronic.com/2023/03/12/parsing-arguments-in-shell-script/

# Function to print usage instructions
function usage {
  echo ""
  echo "Usage: $0 --variant <name> [-t|--tag <tag>] [-d|--debug] [--verbose] "
  echo ""
  echo "Run Docker image build"
  echo ""
  echo "Options:"
  echo "      --variant   Docker image revision number (defaults to :latest without)"
  echo "  -t, --tag       Docker image revision number (defaults to :latest without)"
  echo "  -d, --debug     Output full Docker image build log"
  echo "      --verbose   Print script steps"
  echo "  -h, --help"
  exit 1
}

TAGNUM="latest"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    --variant)
      VARIANT="$2"
      shift
      shift
      ;;
    -t|--tag)
      TAGNUM="$2"
      shift
      shift
      ;;
    -d|--debug)
      LOG_ARGS="--no-cache --progress=plain"
      shift
      ;;
    --verbose)
      VERBOSE=true
      shift
      ;;
    -h|--help)
      usage
      shift
      ;;
    *)
      echo "Invalid option: $1"
      usage
      ;;
  esac
done

# Print script statments to STDOUT if --verbose set
if [ "$VERBOSE" = true ]; then
  set -x
fi

if [ -z "$VARIANT" ]; then
  echo ""
  echo "ERROR: Missing required argument --variant"
  usage
elif [[ ! -d "build/$VARIANT" ]]; then
  echo ""
  echo "ERROR: Invalid variant $VARIANT. Path build/$VARIANT does not exist."
  usage
fi

docker build $LOG_ARGS -t throwtheswitch/madsciencelab:$TAGNUM-$VARIANT -f build/$VARIANT/Dockerfile .