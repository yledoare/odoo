DEBIAN=""
[ -e /etc/debian_version ] && grep trixie /etc/debian_version && DEBIAN="TRIXIE"

if [ "$DEBIAN" = "TRIXIE" ] || [ -e /home/linuxconsole2024/x86_64/lib ]
then
	if [ ! -e usr ]
	then
	  for PKG in libjpeg62-turbo
	  do
		install-local-deb bookworm $PKG
	  done
	  wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox_0.12.6.1-3.bookworm_amd64.deb
	  dpkg -x wkhtmltox_0.12.6.1-3.bookworm_amd64.deb .
	fi
export PATH=$PWD/usr/bin:$PWD/usr/local/bin:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/usr/lib/x86_64-linux-gnu/
fi

wkhtmltopdf -V || exit 1
