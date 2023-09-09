#!/usr/bin/env sh

NEOVIM_STABLE_URL="https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz"

if [ $USER != "root" ]; then
	echo "Needs super-user privileges to install."
	return 1
fi

# download latest release
if ! wget -O /tmp/neovim.tar.gz "$NEOVIM_STABLE_URL"; then
	echo "Error while downloading latest version."
	return 1
fi

# remove old neovim installation
rm /usr/bin/nvim
rm -fr /usr/lib/nvim
rm -fr /usr/share/nvim/
rm /usr/share/applications/nvim.desktop
rm /usr/man/man1/nvim.1
find /usr/local -name "nvim.mo" -delete

if ! tar -x -C /tmp -f /tmp/neovim.tar.gz; then
	echo "Error while extracting downloaded archive."
	return 1
fi

if ! cp -r /tmp/nvim-linux64/* /usr; then
	echo "Error while installing neovim files."
	return 1
fi

# add neovim as alternative to editor and vi
update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 110
update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 110

# clean temporary files
rm -fr /tmp/neovim.tar.gz
rm -fr /tmp/nvim-linux64

