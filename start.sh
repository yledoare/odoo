ODOO="11"
PYTHONLIB="python-3.7"
PYTHON="python3.7"

docker ps |grep docker-db-1 

if [ $? = 1 ] && [ -e docker ]
then
	cd docker
	docker-compose up -d
	cd ..
fi

if [ ! -e usr ]
then
	for PKG in libicu63 libnode64 nodejs node-less python3-pyldap python3-vatnumber python3-suds python3-gevent python3-feedparser python3-html2text python3-reportlab python3-psycopg2 python3-psutil libffi6 python3-pip python3-distutils python3-venv python-pip-whl $PYTHON lib$PYTHON-stdlib $PYTHON-minimal $PYTHON-venv lib$PYTHON-minimal
	do
		[ -e download ] && rm download
  		wget -q https://packages.debian.org/buster/amd64/$PKG/download 

		URL=$(grep ftp.fr.debian.org download | cut -d '"' -f2)
		if [ "$URL" = "" ]
		then
  			URL=$( grep http://security.debian.org/debian-security/ download  | cut -d '"' -f2)
		fi
		echo "\n \n Get $URL .. "
		wget -q $URL
		pwd
		ls
		DEB=$(basename $URL)
		dpkg -x $DEB .
		rm $DEB
	done
	find usr/lib/$PYTHON -type f -print0 | xargs -0 sed -i "s|usr|$PWD/usr|g"
        sed -i "s|usr|$PWD/usr|g" usr/bin/lessc 
        sed -i "s|../lib/less|$PWD/usr/lib/nodejs/less/lib/less|g" usr/bin/lessc 
fi

export PATH=$PWD/usr/bin:$PWD/usr/local/bin:$PATH
export PYTHONPATH=$PWD/usr/lib/$PYTHONLIB/:$PWD/usr/local/lib/$PYTHONLIB/dist-packages:/home/yann/.local/lib/$PYTHONLIB/site-packages/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/usr/lib/x86_64-linux-gnu/

$PYTHON -m pip install setuptools
$PYTHON -m pip install wheel
$PYTHON -m pip install markupsafe==2.0.1

# [ ! -e venv ] && $PYTHON -m venv venv
# . venv/bin/activate

[ ! -e odoo-$ODOO ] && git clone --depth 1 -b $ODOO".0" https://github.com/odoo/odoo && mv odoo odoo-$ODOO

#[ -e /home/linuxconsole2024/x86_64/ ] && grep psycopg2 odoo-$ODOO/requirements.txt && cd odoo-$ODOO && pwd && patch -p1 < ../linuxconsole-odoo.patch && cd ..

$PYTHON -m pip install -r odoo-$ODOO-requirements.txt || exit 1

[ -e addons ] && OPTS="--addons-path=$PWD/addons,$PWD/odoo-$ODOO/addons"

#[ -e /home/linuxconsole2024/x86_64/lib/python3.10/site-packages/ ] && export PYTHONPATH=/home/linuxconsole2024/x86_64/lib/python3.10/site-packages/:$PYTHONPATH
$PYTHON ./odoo-$ODOO/odoo-bin -d odoo-$ODOO --db_host localhost --db_port=54$ODOO -r odoo -w odoo -i base $OPTS
