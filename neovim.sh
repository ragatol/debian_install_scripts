#!/usr/bin/env sh

NEOVIM_STABLE_URL="https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz"
PAQ_URL="https://github.com/savq/paq-nvim.git"
PAQ_INSTALL_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/pack/paqs/start/paq-nvim"

if [ $USER != "root" ]; then
	echo "Needs super-user privileges to install."
	return 1
fi

# download latest release
if ! wget -O /tmp/neovim.tar.gz "$NEOVIM_STABLE_URL"; then
	echo "Error while downloading latest version."
	return 1
fi
# ok, remover arquivos da instalação anterior
rm /usr/bin/nvim
rm -fr /usr/lib/nvim
rm -fr /usr/share/nvim/
rm /usr/share/applications/nvim.desktop
rm /usr/man/man1/nvim.1
find /usr/locale -name "nvim.mo" -delete

if ! tar -x -C /tmp -f /tmp/neovim.tar.gz; then
	echo "Error while extracting downloaded archive."
	return 1
fi

if ! cp -r /tmp/nvim-linux64/* /usr; then
	echo "Error while installing neovim files."
	return 1
fi

#ok, adicionar nvim como alternativa para editor e vi
update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 110
update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 110

# remover arquivos temporários
rm -fr /tmp/neovim.tar.gz
rm -fr /tmp/nvim-linux64

# install paq if not installed
if ! [ -d $PAQ_INSTALL_PATH ]; then
	git clone --depth=1 $PAQ_URL $PAQ_INSTALL_PATH
fi

