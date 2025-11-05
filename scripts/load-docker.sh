#!/bin/bash

set -e
set -u
set -o pipefail

readonly ROOT_DIR="$(cd "$(dirname "${0}")/.." && pwd)"
readonly BUILD_DIR="${ROOT_DIR}/build"

function main {
  local image_name image_tag buildpackage_path
  
  if [[ "${#}" -lt 2 ]]; then
    usage
    exit 1
  fi
  
  image_name="${1}"
  image_tag="${2}"
  buildpackage_path="${3:-${BUILD_DIR}/buildpackage.cnb}"
  
  if [[ ! -f "${buildpackage_path}" ]]; then
    echo "Error: buildpackage not found at ${buildpackage_path}" >&2
    exit 1
  fi
  
  local temp_tar
  temp_tar=$(mktemp /tmp/buildpack-XXXXXX.tar)
  trap 'rm -f "${temp_tar}"' EXIT
  
  echo "Converting OCI archive to Docker tar format..."
  skopeo copy \
    "oci-archive://${buildpackage_path}" \
    "docker-archive:${temp_tar}:${image_name}:${image_tag}"
  
  echo "Loading image into Docker..."
  docker load -i "${temp_tar}"
  
  # temp_tar will be cleaned up by trap on EXIT
  
  echo "✅ Successfully loaded ${image_name}:${image_tag} into Docker"
}

function usage() {
  cat <<-USAGE
load-docker.sh <image-name> <image-tag> [buildpackage-path]

Loads a buildpackage .cnb file into Docker as a Docker image.

ARGUMENTS
  image-name          The name of the Docker image (e.g., neeto-deploy-ruby)
  image-tag           The tag for the Docker image (e.g., 0.47.11)
  buildpackage-path   Path to the buildpackage.cnb file (default: build/buildpackage.cnb)

EXAMPLES
  ./scripts/load-docker.sh neeto-deploy-ruby 0.47.11
  ./scripts/load-docker.sh neeto-deploy-ruby 0.47.11 build/custom.cnb
USAGE
}

main "${@:-}"


