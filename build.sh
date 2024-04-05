#!/bin/bash

# Script argument handling reference: https://joshtronic.com/2023/03/12/parsing-arguments-in-shell-script/

# Function to print usage instructions
function usage {
  echo ""
  echo "Usage: $0 --variant <name> [-t|--tag <tag>] [-d|--debug] [--verbose] "
  echo ""
  echo "Dockerfile generation with optional Docker image build"
  echo ""
  echo "Options:"
  echo "      --variant   Dockerfile containing directory"
  echo "  -t, --tag       Docker image revision number (defaults to :latest without)"
  echo "  -b, --build     Build the Docker image after generating a Dockerfile"
  echo "  -d, --debug     Output full Docker image build log"
  echo "      --verbose   Print script steps"
  echo "  -h, --help"
  exit 1
}

TAGNUM="latest"
TAG=""
VARIANT_NAME=""
VARIANT_DIR=""
DOCKERFILE_GEN_DIRS=""

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
    -b|--build)
      BUILD=true
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

# If `--variant` omitted
if [ -z "$VARIANT" ]; then
  echo ""
  echo "ERROR: Missing required argument --variant"
  usage

# `--variant base` provided
elif [ "$VARIANT" == "base" ]; then
  VARIANT_NAME=""
  VARIANT_DIR="build/base"
  DOCKERFILE_GEN_DIRS="--dir=build/base"
  TAG="$TAGNUM"

# `--variant` provided
else
  VARIANT_NAME="$VARIANT"
  VARIANT_DIR="build/$VARIANT"
  DOCKERFILE_GEN_DIRS="--dir=build/base --dir=$VARIANT_DIR"
  TAG="$TAGNUM-$VARIANT"
fi

if [[ ! -d "$VARIANT_DIR" ]]; then
  echo ""
  echo "ERROR: Invalid variant $VARIANT. Path $VARIANT_DIR does not exist."
  usage
fi

# Generate the Welcome file used by container shell at startup
bin/filegen welcome $DOCKERFILE_GEN_DIRS --version=$TAGNUM build/base/welcome.erb $VARIANT_DIR/assets/shell/welcome

echo ""

# Generate the Dockerfile
bin/filegen dockerfile $DOCKERFILE_GEN_DIRS --variant=$VARIANT build/base/Dockerfile.erb $VARIANT_DIR/Dockerfile

echo ""

# Build the Dockerfile we just created
if [ "$BUILD" = true ]; then
  docker build $LOG_ARGS -t throwtheswitch/madsciencelab:$TAG -f $VARIANT_DIR/Dockerfile .
fi



