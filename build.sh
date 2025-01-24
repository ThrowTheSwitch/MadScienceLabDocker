#!/bin/bash

# Script argument handling reference: https://joshtronic.com/2023/03/12/parsing-arguments-in-shell-script/

# Default image name (can be overridden by CLI argument)
IMAGE="throwtheswitch/madsciencelab"

##
## Usage output
##

# Function to print usage instructions
function usage {
  echo ""
  echo "Usage: $0 [--dir <dir>]* [--variant <name>] [-b|--build] [-v|--version <ver>] [-i|--image <name>] [--platform] [--push|--validate] [-d|--debug] [--verbose] "
  echo ""
  echo "throwtheswitch/madsciencelab Dockerfile + asset generation with multi-platform Docker image build"
  echo ""
  echo "File generation options:"
  echo "      --dir       Add <dir> to be processed in addition to build/base"
  echo "                  May be specified multiple times"
  echo "                  Last instance provides variant name"
  echo "      --variant   Override auto-discovered variant name"
  echo ""
  echo "Docker image build options:"
  echo "  -b, --build     Build Docker image after generating a Dockerfile [defaults to local image on host]"
  echo "  -v, --version   Docker image version, ex: '1.2.3' [default: 'latest']"
  echo "  -i, --image     Override image name [default: '$IMAGE']"
  echo "      --platform  Docker target platforms, ex: 'linux/arm64,linux/amd64'"
  echo "      --push      Push a multi-platform Docker image build to its repository (only with --platform)"
  echo "      --validate  Execute a multi-platform build (only with --platform)"
  echo "  -d, --debug     Produce full Docker image build log"
  echo ""
  echo "Script options:"
  echo "      --verbose   Print script steps"
  echo "  -h, --help      Print this usage message"
  exit 1
}

# If no command line parameters, print usage and exit
if [ $# -eq 0 ]; then usage; fi

##
## Defaults
##

# Docker image tag / version handling
IMAGE_TAG="latest"   # Docker image tag (can include 'latest')
CONTAINER_VERSION="" # Version provided to running container via environment variable (blank or a version string)

# Variant handling
VARIANT_NAME_OVERRIDE=false
VARIANT_NAME_RENAME=""
VARIANT_NAME=""
VARIANT_DIR_PATH=""

# First, necessary base directory in list of directories to process
DOCKERFILE_GEN_DIRS="--dir=build/base"

# Docker buildx platforms list (empty defaults to host platform where build is happening)
PLATFORMS=""
# Docker buildx command line argument
PLATFORM_ARGS=""

# Default to standard, simple `docker build`
BUILD_ACTION="build"

# Special build action flags
MULTIPLATFORM_BUILD=false
PUSH=false
VALIDATE=false

##
## Command line argument handling
##

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  case $1 in

    --dir)
      if [ -z "$2" ]; then
        echo ""
        echo "ERROR: Directory name required for --dir"
        usage
      fi

      if [[ ! -d "$2" ]]; then
        echo ""
        echo "ERROR: Invalid directory $2. Path does not exist."
        exit 1
      fi

      # Variant name defaults to last provided --dir option
      VARIANT_NAME=`basename "$2"`
      # Variant directory is last provided in --dir list
      VARIANT_DIR_PATH="$2"
      # Concatenate to list of --dir arguments for `filegen` utility
      DOCKERFILE_GEN_DIRS="$DOCKERFILE_GEN_DIRS --dir=$2"
      shift
      shift
      ;;

    --variant)
      # Capture varient name override, including blank option
      # Since we can't control order of CLI args, we save and process later
      VARIANT_NAME_RENAME="$2"
      VARIANT_NAME_OVERRIDE=true
      shift
      shift
      ;;

    -b|--build)
      BUILD=true
      shift
      ;;

    -v|--version)
      if [ -z "$2" ]; then
        echo ""
        echo "ERROR: No argument provided for --version"
        usage
      fi

      CONTAINER_VERSION="$2"
      shift
      shift
      ;;

    -i|--image)
      if [ -z "$2" ]; then
        echo ""
        echo "ERROR: No name provided for --image"
        usage
      fi

      IMAGE="$2"
      shift
      shift
      ;;

    --platform)
      if [ -z "$2" ]; then
        echo ""
        echo "ERROR: One or more platforms required by --platform"
        usage
      fi

      PLATFORMS="$2"
      PLATFORM_ARGS="--platform=$2"
      shift
      shift
      ;;

    --push)
      # Override default of image build with push to repository
      PUSH=true
      shift
      ;;

    --validate)
      # Override default of image build with push to repository
      VALIDATE=true
      shift
      ;;

    -d|--debug)
      # Force the Docker build to skip caching and produce a full progress dump for review
      LOG_ARGS="--no-cache --progress=plain"
      shift
      ;;

    --verbose)
      VERBOSE=true
      shift
      ;;

    -h|--help)
      usage
      ;;

    *)
      echo "Invalid option: $1"
      usage
      ;;
  esac
done


# If platforms blank, ensure --push or --validate not set
if [ -z "$PLATFORMS" ]; then
  if [ "$PUSH" = true ]; then
    echo ""
    echo "ERROR: --push only available in combination with --platform"
    usage
  fi

  if [ "$VALIDATE" = true ]; then
    echo ""
    echo "ERROR: --validate only available in combination with --platform"
    usage
  fi

# If platforms not blank, ensure --push or --validate used properly and add to BUILD_ACTION accordingly
else
  if [ "$PUSH" = true && "$VALIDATE" = true ]; then
    echo ""
    echo "ERROR: --validate and --push are mutually exclusive options"
    usage
  fi
fi

# After build option combination validation above, set our build options
if [ "$PUSH" = true ]; then
  BUILD_ACTION="buildx build --push"
  MULTIPLATFORM_BUILD=true
elif [ "$VALIDATE" = true ]; then
  BUILD_ACTION="buildx build -o type=image"
  MULTIPLATFORM_BUILD=true
fi


# Print script statements to STDOUT if --verbose set
if [ "$VERBOSE" = true ]; then
  set -x
fi

# Reset variant name auto discovered from --dir list
if $VARIANT_NAME_OVERRIDE; then
  VARIANT_NAME="$VARIANT_NAME_RENAME"
fi

# Add variant suffix to image name
if [ -n "$VARIANT_NAME" ]; then
  IMAGE="$IMAGE-$VARIANT_NAME"
fi

# Create Docker image tag other than 'latest', if version string provided
if [ -n "$CONTAINER_VERSION" ]; then
  IMAGE_TAG="$CONTAINER_VERSION"
fi

##
## File Generation
##


echo "🎯 Target Docker image $IMAGE:$IMAGE_TAG"
echo ""

# Generate the Welcome file displayed within the shell at container launch
bin/filegen welcome $DOCKERFILE_GEN_DIRS build/base/templates/welcome.erb "$VARIANT_DIR_PATH"/assets/shell/welcome
if [ $? -ne 0 ]; then
  echo "❌ ERROR: Could not generate welcome file(s)"
  echo ""
  exit 1
fi

echo ""

# Generate the Dockerfile
bin/filegen dockerfile $DOCKERFILE_GEN_DIRS --variant="$VARIANT_NAME" build/base/templates/Dockerfile.erb "$VARIANT_DIR_PATH"/docker/Dockerfile
if [ $? -ne 0 ]; then
  echo "❌ ERROR: Could not generate Dockerfile"
  echo ""
  exit 1
fi

echo ""

##
## Docker Image Build
##

# Build the Dockerfile we just created with any additional options
if [ "$BUILD" = true ]; then

  # If a multi-platform build option is set, enable multi-platform builder
  if [ $MULTIPLATFORM_BUILD == true ]; then
    # If a buildx builder doesn't already exist, set one up
    if ! (docker buildx ls 2>&1 | grep -q 'madsciencelab-builder'); then
      docker buildx create --name madsciencelab-builder
      if [ $? -ne 0 ]; then
        echo "❌ ERROR: Could not create multi-platform Docker builder"
        echo ""
        exit 1
      fi
    fi

    # Ensure we're using a buildx builder
    docker buildx use madsciencelab-builder
    if [ $? -ne 0 ]; then
      echo "❌ ERROR: Could not enable multi-platform Docker builder"
      echo ""
      exit 1
    fi
  fi
  
  # Perform multi-platform build with output as an image or optionally a direct push to the repository
  # Always echo this command to the command line
  (set -x; docker $BUILD_ACTION $LOG_ARGS -t "$IMAGE":"$IMAGE_TAG" $PLATFORM_ARGS --build-arg CONTAINER_VERSION="$CONTAINER_VERSION" --build-arg IMAGE_NAME="$IMAGE" -f "$VARIANT_DIR_PATH"/docker/Dockerfile .)

  # Capture exit code from attempted Docker image build
  success=$?

  # Stop the buildx builder started above
  if [ $MULTIPLATFORM_BUILD == true ]; then
    docker buildx stop madsciencelab-builder
  fi

  operation=""
  platforms=""

  if [ $PUSH == true ]; then
    operation="Built and pushed"
  else
    operation="Built"
  fi

  if [ -z "$PLATFORMS" ]; then
    platforms="host platform"
  else
    # Break up Docker command line option 'platform,platform' to be readable
    platforms="${PLATFORMS/,/, }"
  fi

  if [ $success -eq 0 ]; then
    echo ""
    echo "📦 $operation $IMAGE:$IMAGE_TAG for $platforms"
    echo ""
  else
    echo ""
    echo "❌ ERROR: Could not build $IMAGE:$IMAGE_TAG for $platforms"
    echo ""    
  fi
fi
