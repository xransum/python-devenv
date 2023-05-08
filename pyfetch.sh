#!/usr/bin/env bash

# This is a script to easily install localized versions of Python
# 	bash <(curl -skL https://raw.githubusercontent.com/xransum/python-devenv/main/pyfetch.sh) 
# 		--list
# 		--prefix ./lib/
# 		3.9.6 3.8.11

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
LIGHTBLUE='\033[1;34m' # Light Blue
NC='\033[0m' # No Color

SCRIPT_NAME="pyfetch"
HELP=false
LIST_VERSIONS=false
FORCE=false
POSITIONAL_ARGS=()
PREFIX=""

while [[ $# -gt 0 ]]; do
	case $1 in
		-p|--prefix)
			PREFIX="$2"
			shift # past argument
			shift # past value
			;;
		-l|--list)
			LIST_VERSIONS=true
			shift # past argument
			# shift # past value
			;;
		-f|--force)
			FORCE=true
			shift # past argument
			;;
		-h|--help)
			HELP=true
			shift # past argument
			;;
		-*|--*)
			echo "Unknown option $1"
			exit 1
			;;
		*)
			POSITIONAL_ARGS+=("$1") # save positional arg
			shift # past argument
			;;
	esac
done
set -- "${POSITIONAL_ARGS[@]}" # restore positional parameters

function usage() {
	echo ""
	echo "Usage: $SCRIPT_NAME [options] version [version ...]"
	echo "Options:"
	echo "  -p, --prefix <path>  Install to <path> instead of /usr/local"
	echo "  -f, --force          Force installation even if already installed"
	echo "  -l, --list           List available versions"
	echo "  -h, --help           Show this help message and exit"
}

function get_versions() {
	url='https://www.python.org/ftp/python/'
	curl --silent "$url" |
		sed -n 's!.*href="\([0-9]\+\.[0-9]\+\.[0-9]\+\)/".*!\1!p' |
		sort -V |
		while read -r version; do
			echo "$version"
		done
}

if $HELP; then
	usage
	exit 0
fi

if $LIST_VERSIONS; then
	get_versions
	exit 0
fi

if [[ $# -eq 0 ]]; then
	echo "No versions specified"
	usage
	exit 1
fi

for version in "$@"; do
	if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
		echo "Invalid version $version"
		exit 1
	fi
done

if [[ -z "$PREFIX" ]]; then
	echo "No prefix specified"
	echo -e "${YELLOW}Using default prefix: ./lib/${NC}"
	PREFIX="./lib/"
fi

PREFIX="$(readlink -f "$PREFIX")"

if [[ ! -d "$PREFIX" ]]; then
	echo -e "${YELLOW}Prefix directory does not exist: $PREFIX, creating it...${NC}"
	if ! mkdir -p "$PREFIX"; then
		echo -e "${RED}Failed to create prefix directory: $PREFIX${NC}"
		exit 1
	fi
fi

if [[ ! -w "$PREFIX" ]]; then
	echo -e "${RED}Prefix directory is not writable: $PREFIX${NC}"
	exit 1
fi

TEMP_DIR="$(mktemp -d)"

function cleanup() {
	rm -rf "$TEMP_DIR"
}

PYTHON_FTP_URL='https://www.python.org/ftp/python/'
INSTALLED_VERSIONS=()

for version in "$@"; do
	PREFIX_DIR="$PREFIX/Python-${version}"
	FILENAME="Python-${version}.tar.xz"
	url="${PYTHON_FTP_URL}${version}/${FILENAME}"
	
	if [[ -d "$PREFIX_DIR" ]]; then
		if $FORCE; then
			echo -e "${YELLOW}Removing existing Python ${version} installation: ${PREFIX_DIR}${NC}"
			rm -rf "$PREFIX_DIR"
		else
			echo -e "${YELLOW}Python ${version} is already installed: ${PREFIX_DIR}${NC}"
			continue
		fi
	fi
	
	# download the zip file to a temporary directory
	echo -e "${YELLOW}Downloading Python ${version} - URL: ${url}${NC}"
	curl --fail --silent -o "$TEMP_DIR/${FILENAME}" -O "$url";
	if [[ $? -ne 0 ]]; then
		echo -e "${RED}Failed to download Python ${version}${NC}"
		cleanup
		exit 1
	else
		echo -e "${GREEN}Downloaded Python ${version}${NC}"
	fi
	
	# extract the zip file to the prefix directory
	echo -e "${YELLOW}Extracting Python ${version}${NC}"
	tar -xvf "${TEMP_DIR}/${FILENAME}" -C "$PREFIX"
	
	echo -e "${YELLOW}Building Python ${version}${NC}"
	cd "${PREFIX_DIR}"
	
	echo -e "${YELLOW}Running configure${NC}"
	./configure --prefix="${PREFIX_DIR}"
	
	echo -e "${YELLOW}Running make${NC}"
	# Running make
	# Problem: make: *** No targets specified and no makefile found.  Stop.
	# Solution: https://stackoverflow.com/a/3466183/993115
	make
	
	echo -e "${YELLOW}Running make install${NC}"
	if make install; then
		echo -e "${GREEN}Installed Successfully ${version}${NC}"
		INSTALLED_VERSIONS+=("$version")
	else
		echo -e "${RED}Failed to install Python ${version}${NC}"
		cleanup
		exit 1
	fi
	
	# could fail here if libbz2-dev is not installed
done

echo -e "${YELLOW}Cleaning up${NC}"
cleanup

if [[ ${#INSTALLED_VERSIONS[@]} -eq 0 ]]; then
	echo -e "${RED}No versions installed${NC}"
	exit 1
fi

echo -e "${GREEN}Installation Complete${NC}"
echo ""

echo "Use the following commands to use your new Python installation:"
for version in "${INSTALLED_VERSIONS[@]}"; do
	echo -e "  ${LIGHTBLUE}export PATH=$PREFIX/Python-${version}/bin:\$PATH${NC}"
done
echo ""

echo "To permanently add this directory to your PATH, add the following line to your ~/.bashrc file:"
for version in "${INSTALLED_VERSIONS[@]}"; do
	echo -e "  ${LIGHTBLUE}export PATH=$PREFIX/Python-${version}/bin:\$PATH${NC}"
done
echo ""

echo "To use this Python version in a virtual environment, use the following command:"
for version in "${INSTALLED_VERSIONS[@]}"; do
	echo -e "  ${LIGHTBLUE}python${version} -m venv <path>${NC}"
done
echo ""

echo "To use this Python version in a virtual environment with a specific version of Python, use the following command:"
for version in "${INSTALLED_VERSIONS[@]}"; do
	echo -e "  ${LIGHTBLUE}python${version} -m venv --python=$PREFIX/bin/python${version} <path>${NC}"
done
echo ""

