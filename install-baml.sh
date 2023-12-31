#!/bin/bash

set -e
set -o pipefail

# Define color codes
GREEN=$(tput setaf 2)
RED=$(tput setaf 1)
RESET=$(tput sgr0)

# Default settings
RELEASE_TYPE="release%2Fbaml-cli%2F" # Default release type
VERSION="0.7.2"

# Define checksums for each version (update this list as new versions are released)
declare -A CHECKSUMS
CHECKSUMS["0.1.1"]=( "c0923d34630bfbfdc2509f561bc5dd99c298bbddb66eed0dd5564879a7b477fb" "68fbffc4da1168abd4c417b22b16240e658d2b1416bb39aebaf2b8c0b1350811" "ca3c3c1416f962b590e8d3ef551a01beebd8fd419c66d50752f8a97cc0ee5c76" )
CHECKSUMS["0.2.0"]=( "30f2d9217a237fdcae02c438735d865554031329109966246c1321beb904f8ce" "5d45ba13442c2766f594fe9796ff209c91187554d827b6cfaf78f91bb6ce95e2" "da466592458b0bc529d16f9d71e16c4a23c11765bbc1ee1a7549c16ec8e27e23" )
CHECKSUMS["0.2.1"]=( "98bc8bbdb5e17ce5d821c68e04228ab88f4d9ab8a0df954873804d6cad80e5d2" "428f49fe8be046b7c65f928d7025741eb5e74822a6833ee6ab016b6d936dd4d2" "c9a5c345ee9751c357973b117617ed5549dd5d934f5f917c82007d967e17095b" )
CHECKSUMS["0.3.0"]=( "243d5ab7037a13301b0126164202bd1f0db0fedbdca337e8e07e7380db014e25" "f6950b974f7160acb080f1dd8a7634625bf994ecec802c20843388db9e064276" "5273d1c9240f5d32f5881afd0cf67072b5d1bd11beebb819ca7fb1ea649b401a" )
CHECKSUMS["0.3.1"]=( "73be2c8e9cc816d575cd0230ea1900bc45cb21ec43dec3a543c542b1411dd8c6" "1be3a2492ab15531a7b6b46bd5dedc47b40bef71d67ed8cf880a9770e24dc23d" "13ebab0ca8fad0c41d853838553dbf71d4ea6644613f0a51d4580dc92bd50d1c" )
CHECKSUMS["0.4.0"]=( "e5c0f734f933e5df44e9d3c49ff910987fa3daa45692efc939a025e88039b33a" "529d3afb571dbf0be0b10e881520525b73868e2da1376a152ac0aebb6e18c349" "89a2f8db93e3165224298adbd2ce1f29323a0369fc9ae9648d712186ca164e33" )
CHECKSUMS["0.4.1"]=( "dc722d65c540eb9106751fe4c83ba544525d8cacc09bcb4cbc54725d426215a4" "b87ae5b342d2dca38410dfe1c0e051d844e78f31ce3d9c5371039f92859e3fb8" "aeffbd22bcfdcf89a6de9173434e9ca9c315fa3c96cdc3dac2797374fc478e8e" )
CHECKSUMS["0.4.2"]=( "b43787cd903401582c7c7e140e6533428df214124ebbc2d9d1a9691e092ad7c0" "401e308c7b6d22a555feb9adb03f1b7761ff279bde6ec132f23c3b8bc8304471" "c74d4e95d814ba5bc04e68ab251625313d3d3a3dd0c1c328f271cf09ee35bf8a" )
CHECKSUMS["0.4.3"]=( "eaee09dcb4a532b319bfeb72a98a8ecb0ec496abfbcf79c68d7a3ea3f6435d15" "73fd54c8ed26f10655c25340768349e556fd336c309aaa82c2e9d50e2da476c4" "230d638b6282acaaf3f27c75098e53add7ef5d11c9de93c50c1717d83d7433fb" )
CHECKSUMS["0.4.4"]=( "7f713cec336503b5b3c03cd0a0319c49ae8622c1a0e50a93ae6f2bc88e7b51d7" "c8113eedcecaa400199d97d7904eaaf810a3ba66b42ee02ba0fd5c87c442a85e" "a8bd2f9f491008d27010316acbb38f755598c3fd141ba47115ea4733de5a2045" )
CHECKSUMS["0.5.0"]=( "388a055eeac064ea3a0d781435d3851db548348395ead1b0a5ec0b1d4c2ddf54" "268b0f000e452ab729bdde40e15bf120239c176a038fb0796bd1b444d74fe784" "2b87c6fdeb558ee90df269da0d32e985ee7bb93bcca8bb7c88d0e2585c66270f" )
CHECKSUMS["0.6.0"]=( "a3c63274298cd1be6ac89e2d7c92b75fd2bc3271b9feab1792546f531cd6b4ba" "7aa59caa2594f566ffdb706b0fc000a0051ef92e6f6d67544c0677d612a6d32b" "f7e60b9a995ba22182428c526231d33eac03b2cdc856dce53cb06fbb7352d00a" )
CHECKSUMS["0.6.1"]=( "918cb877f08cae722af9fc6e80b1310db7c496eaf8e5b62a9913a116deb989c3" "ab2d4e47f5596d1784f1e75ba39a803fb88032886c81f2b9c13056a46c1fdcfd" "01fdfc558c4d93ad955dd709862f53f62bfa798cd0ccaa7cf9dd6f66c89db7e4" )
CHECKSUMS["0.6.2"]=( "4f40fa90d5f2634e7d22f4a050ec7edd8754843bef3d170a3ef63b78fefed02a" "17fe0565c15c383fff19ba31322bd7eecb8245a4e318574cdeeacffb4cdfadee" "60c20c0bff0b5b5d3c6f73e376380f2a77754983e22c575c87ec780343a76f8d" )
CHECKSUMS["0.7.0"]=( "5166b9910ad67f30e82eb9d5bc8245ce53b03d2702cdbfa20e5c563faa65f21b" "9f3f65f6ef69cbeb52423d799364e0a2e4f16d1cb4b5fd62b7d21f7ff78628a1" "9fddc0e6e6368b732528b283e4e6b6c7991019e45f90683495d1cec917ef7b5c" )
CHECKSUMS["0.7.1"]=( "3f2dcd5ac4d06c4749824bad3731a2c28ff4856e274bab097dc96770df6509ca" "a6a9bd61d256bffcf71324b490a6a491e2fc30694568bc1d0aee9b99ca9303c0" "d1a26e278c4a796bd33c1f809935a80dacf7329e3b17545fd5b0e271ec94ec27" )
CHECKSUMS["0.7.2"]=( "82d327d78c2451638ac24cebb1b379fca967a6a41f5672096466dca6c5718875" "14c8b5fbbe37d99f0c8745647939f7479406ed9fe7128e64a12353fd12fd4faf" "ead3f240f592e554ef3d5d8a222270d6de80bc3f73b79c32b69cae3613678beb" )
# ADD CHECKSUMS HERE

BINARY_NAME="baml"
LOG_FILE="install_log.txt"

# List of possible versions (update this list as new versions are released)
POSSIBLE_VERSIONS=(
    "0.1.1"
"0.2.0"
"0.2.1"
"0.3.0"
"0.3.1"
"0.4.0"
"0.4.1"
"0.4.2"
"0.4.3"
"0.4.4"
"0.5.0"
"0.6.0"
"0.6.1"
"0.6.2"
"0.7.0"
"0.7.1"
"0.7.2"
# ADD VERSIONS HERE
)

# Function to log messages
log_message() {
    local message="$1"
    local color="$2"
    echo "$(date '+%Y-%m-%d %H:%M:%S') - ${color}${message}${RESET}" | tee -a $LOG_FILE
}

# Error trap function
handle_error() {
    log_message "Error: An error occurred in the script" $RED
    exit 1
}

# Set the error trap
trap 'handle_error' ERR

# Function to get the latest version from a major version
get_latest_version() {
    local major_version=$1
    local matching_versions=($(echo "${POSSIBLE_VERSIONS[@]}" | grep "^${major_version}"))
    
    if [ ${#matching_versions[@]} -eq 0 ]; then
        echo ""
    else
        printf "%s\n" "${matching_versions[@]}" | sort -V | tail -n1
    fi
}

# Parse command-line arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        --nightly)
        RELEASE_TYPE="unstable%2Fcli%2F"
        shift
        ;;
        --version=*)
        input_version="${1#*=}"
        
        # Check if the input version is fully specified or not
        if [[ $input_version =~ ^[0-9]+$ ]]; then
            # Major version only
            latest_version=$(get_latest_version "${input_version}\.")
        elif [[ $input_version =~ ^[0-9]+\.[0-9]+$ ]]; then
            # Major and minor version
            latest_version=$(get_latest_version "${input_version}\.")
        else
            # Full version specified
            latest_version=$input_version
        fi

        if [ -z "$latest_version" ]; then
            log_message "Error: No versions found for version $input_version. Available versions are: ${POSSIBLE_VERSIONS[*]}" $RED
            exit 1
        fi
        VERSION=$latest_version
        shift
        ;;
        *)
        log_message "Error: Invalid argument $1" $RED
        exit 1
        ;;
    esac
done

# Construct download URLs based on release type and version
URL_LINUX="https://github.com/GlooHQ/baml/releases/download/${RELEASE_TYPE}v${VERSION}/baml-linux-x86_64.tar.gz"
URL_MAC_INTEL="https://github.com/GlooHQ/baml/releases/download/${RELEASE_TYPE}v${VERSION}/baml-apple-intel.tar.gz"
URL_MAC_ARM="https://github.com/GlooHQ/baml/releases/download/${RELEASE_TYPE}v${VERSION}/baml-apple-arm.tar.gz"

# Detect operating system and set the appropriate URL
OS=$(uname -s)
ARCH=$(uname -m)

case $OS in
    Linux) URL=$URL_LINUX;;
    Darwin)
        case $ARCH in
            x86_64) URL=$URL_MAC_INTEL;;
            arm64) URL=$URL_MAC_ARM;;
            *) log_message "Error: Unsupported architecture $ARCH on macOS" $RED; exit 1;;
        esac
    ;;
    *) log_message "Error: Unsupported operating system $OS" $RED; exit 1;;
esac

# Create a temporary directory
TEMP_DIR=$(mktemp -d)

# Change to temp directory
cd $TEMP_DIR

# Get the file name from the URL
FILENAME=$(basename $URL)

# Download the tar.gz file
HTTP_STATUS=$(curl -L -O -w "%{http_code}" -s $URL/ooo -o $FILENAME)
if [ "$HTTP_STATUS" -ne 200 ]; then
    log_message "Error: Failed to download the file. HTTP Status: $HTTP_STATUS. Please check https://github.com/GlooHQ/baml/releases/tag/$RELEASE_TYPE/cli/v$VERSION exists." $RED
    exit 1
fi

# Only perform checksum verification for stable releases
if [ "$RELEASE_TYPE" != "unstable" ]; then
    # Compute SHA-256 checksum
    COMPUTED_CHECKSUM=$(sha256sum $FILENAME | awk '{ print $1 }')

    # Verify checksum
    case $OS in
        Linux) EXPECTED_CHECKSUM=${CHECKSUMS[$VERSION][0]};;
        Darwin)
            case $ARCH in
                x86_64) EXPECTED_CHECKSUM=${CHECKSUMS[$VERSION][1]};;
                arm64) EXPECTED_CHECKSUM=${CHECKSUMS[$VERSION][2]};;
            esac
        ;;
    esac
    if [ "$COMPUTED_CHECKSUM" != "$EXPECTED_CHECKSUM" ]; then
        log_message "Error: Checksum verification failed for $FILENAME" $RED
        exit 1
    fi
fi

# Unzip the file
tar -xvzf $FILENAME

# Make the binary executable
chmod +x $BINARY_NAME

# Move the binary to your PATH
sudo mv $BINARY_NAME /usr/local/bin/

# Verify installation
if which $BINARY_NAME > /dev/null; then
    VERSION=$($BINARY_NAME --version)
    log_message "$BINARY_NAME installed successfully, version: $VERSION" $GREEN
else
    log_message "Error: Failed to install $BINARY_NAME" $RED
    exit 1
fi
