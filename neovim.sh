#!/usr/bin/env sh

NEOVIM_STABLE_URL="https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz"
NEOVIM_NIGHTLY_URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz"

if [ "${USER}" != "root" ]; then
	echo "Needs super-user privileges to install."
	return 1
fi

uninstall () {
	rm -f /usr/bin/nvim
	rm -fr /usr/lib/nvim
	rm -fr /usr/share/nvim/
	rm -f /usr/share/applications/nvim.desktop
	rm -f /usr/man/man1/nvim.1
}

case "${1}" in
	-h|--help)
		echo "Run this script as superuser to install the latest stable neovim release."
		echo "Use -n or --nightly option to install the latest nightly release."
		echo "Use -u or --uninstall option to uninstall neovim."
		return 0
		;;
	-n|--nightly)
		DOWNLOAD_URL="${NEOVIM_NIGHTLY_URL}"
		;;
	-u|--uninstall)
		uninstall
		return 0
		;;
	*)
		DOWNLOAD_URL="${NEOVIM_STABLE_URL}"
		;;
esac

# download latest release
[ -f /tmp/neovim.tar.gz ] && rm -rf /tmp/neovim.tar.gz
if ! wget -O /tmp/neovim.tar.gz "${DOWNLOAD_URL}"; then
	echo "Error while downloading latest version."
	return 1
fi

uninstall

if ! tar -xv -C /usr --strip-components=1 -f /tmp/neovim.tar.gz; then
	echo "Error while installing neovim files."
	return 1
fi

# add neovim as alternative to editor and vi
update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 110
update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 110

# clean temporary files
rm -fr /tmp/neovim.tar.gz
