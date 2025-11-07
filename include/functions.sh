install-local-deb () {
  debian=$1
  deb=$2
  echo "Installing $deb"
		[ -e download ] && rm download
  		wget -q https://packages.debian.org/$debian/amd64/$deb/download 

		URL=$(grep ftp.fr.debian.org download | cut -d '"' -f2)
		if [ "$URL" = "" ]
		then
  			URL=$( grep http://security.debian.org/debian-security/ download  | cut -d '"' -f2)
		fi
		echo -e "\n Get $URL .. "
		wget -q $URL
		DEB=$(basename $URL)
		dpkg -x $DEB .
		rm $DEB
		touch $debian-$deb-ok
}
