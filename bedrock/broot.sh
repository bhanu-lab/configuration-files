#!/bin/sh
# shellcheck shell=sh # Written to be posix compatible

# BEDROCK LINUX STRATUM CHROOTER #

# Invoke with root device, mount point, stratum name and shell path.
# E.g: "broot.sh /dev/sda1 /mnt gentoo /bin/bash"


# For capturing Bugs
# kills the script if anything returns false
set -e

# VERSION="2.0.0"

# eprintln: prints to standard error
alias eprintln="printf '%s\n' >&2"

# Simplified assertion
die() {
    case "$2" in
        *) eprintln "FATAL: $2!" ; exit "$1" ;;
    esac
}

# Check for root
checkRoot() {
    if ! [ "$(id -u)" = 0 ]; then
        die 13 "The Script needs to be executed as Root/Superuser"
    fi
}

checkRoot

mount "$1" "$2"

mount --rbind /dev "$2/bedrock/strata/$3/dev"
mount -t proc /proc "$2/bedrock/strata/$3/proc"
mount --rbind /sys "$2/bedrock/strata/$3/sys"
mount --rbind /tmp "$2/bedrock/strata/$3/tmp"
# "--make-rslave" operations are needed for systemd
mount --make-rslave "$2/bedrock/strata/$3/dev"
mount --make-rslave "$2/bedrock/strata/$3/sys"

chroot "$2/bedrock/strata/$3" "$4"
