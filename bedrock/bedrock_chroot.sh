#!/bin/sh
# shellcheck shell=sh # Written to be posix compatible

# BEDROCK LINUX STRATA CHROOTER #
# UPSTREAM_VERSION="3.0.0"

: '
Invoke with root device, mount point, strata name and shell path.
E.g: "script.sh /dev/sda1 /mnt/bedrock_chroot gentoo /bin/bash"

If no arguments are passed then the values are obtained from
interactive user input.
'

# For capturing Bugs
# kills the script if anything returns false
set -e

# Overwrites
alias print="printf '%s'"
# eprintln: prints to standard error
alias eprintln="printf '%s\n' >&2"

# Simplified assertion
die() {
	case "$2" in
	*)
		eprintln "FATAL: $2!"
		exit "$1"
		;;
	esac
}

# Check for root
checkRoot() {
	if ! [ "$(id -u)" = 0 ]; then
		die 13 "The Script needs to be executed as Root/Superuser"
	fi
}

isExecutable() {
	if ! command -v "$1" >/dev/null; then
		die 8 "'$1' is not executable on this system"
	fi
}

live_bedrock_sys_check=""
if [ "$live_bedrock_sys_check" ] && [ -d "/bedrock" ]; then
	die 1 "Found bedrock system, refusing to run"
fi

for bin in "mkdir" "mount" "chroot"; do
	isExecutable "$bin"
done

checkRoot

if [ ! "$1" ]; then
	while [ -z "$root_drive" ]; do
		print "Root drive (e.g: /dev/sda1): "
		read -r root_drive
	done

	while [ -z "$mount_point" ]; do
		print "Mount point (e.g: /mnt/bedrock_chroot): "
		read -r mount_point
	done

	if [ -d "$mount_point" ]; then
		die 1 "Mount point '$mount_point' exists. Refusing to proceed"
	fi

	mkdir --parents "$mount_point"

	mount "$root_drive" "$mount_point"

	while [ -z "$strata_name" ]; do
		print "Strata name (e.g: gentoo): "
		read -r strata_name
	done

	if [ ! -d "$mount_point/bedrock/strata/$strata_name" ]; then
		die 1 "Strata '$strata_name' does not exist"
	fi

	mount --rbind /dev "$mount_point/bedrock/strata/$strata_name/dev"
	mount -t proc /proc "$mount_point/bedrock/strata/$strata_name/proc"
	mount --rbind /sys "$mount_point/bedrock/strata/$strata_name/sys"
	mount --rbind /tmp "$mount_point/bedrock/strata/$strata_name/tmp"

	# "--make-rslave" operations are needed for systemd
	if [ -d "$mount_point/bedrock/strata/$strata_name/usr/lib/systemd" ]; then
		mount --make-rslave "$mount_point/bedrock/strata/$strata_name/dev"
		mount --make-rslave "$mount_point/bedrock/strata/$strata_name/sys"
	fi

	while [ -z "$strata_shell_path" ]; do
		print "Strata shell path (e.g: /bin/bash): "
		read -r strata_shell_path
	done

	if [ ! -f "$mount_point/bedrock/strata/$strata_name/$strata_shell_path" ]; then
		die 1 "Shell binary in path '$mount_point/bedrock/strata/$strata_name/$strata_shell_path' does not exist"
	fi

	chroot "$mount_point/bedrock/strata/$strata_name" "$strata_shell_path"
else
	if [ ! "$2" ]; then
		die 1 "Mount point unspecified"
	fi

	if [ -d "$2" ]; then
		die 1 "Mount point '$2' exists. Refusing to proceed"
	fi

	if [ ! "$3" ]; then
		die 1 "Strata unspecified"
	fi

	if [ ! "$4" ]; then
		die 1 "Strata shell path unspecified"
	fi

	mkdir --parents "$2"
	mount "$1" "$2"

	if [ ! -d "$2/bedrock/strata/$3" ]; then
		die 1 "Strata '$3' does not exist"
	fi

	mount --rbind /dev "$2/bedrock/strata/$3/dev"
	mount -t proc /proc "$2/bedrock/strata/$3/proc"
	mount --rbind /sys "$2/bedrock/strata/$3/sys"
	mount --rbind /tmp "$2/bedrock/strata/$3/tmp"

	# "--make-rslave" operations are needed for systemd
	if [ -d "$2/bedrock/strata/$3/usr/lib/systemd" ]; then
		mount --make-rslave "$2/bedrock/strata/$3/dev"
		mount --make-rslave "$2/bedrock/strata/$3/sys"
	fi

	if [ ! -f "$2/bedrock/strata/$3/$4" ]; then
		die 1 "Shell binary in path '$2/bedrock/strata/$3/$4' does not exist"
	fi

	chroot "$2/bedrock/strata/$3" "$4"
fi
