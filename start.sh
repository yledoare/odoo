ODOO=11
docker ps |grep docker-db-1 

if [ $? = 1 ] && [ -e docker ]
then
	cd docker
	docker-compose up -d
	cd ..
fi

if [ ! -e usr ]
then
	for PKG in python-reportlab python3-psycopg2 python3-psutil libffi6 python3-pip python3-distutils python3-venv python-pip-whl python3.7 libpython3.7-stdlib python3.7-minimal python3.7-venv libpython3.7-minimal # python3-minimal libpython3-stdlib python3-venv
	do
		[ -e download ] && rm download
  		wget https://packages.debian.org/buster/amd64/$PKG/download 

		URL=$(grep ftp.fr.debian.org download | cut -d '"' -f2)
		if [ "$URL" = "" ]
		then
  			URL=$( grep http://security.debian.org/debian-security/ download  | cut -d '"' -f2)
		fi
		wget $URL
		pwd
		ls
		DEB=$(basename $URL)
		dpkg -x $DEB .
		rm $DEB
	done
	find usr/lib/python3.7 -type f -print0 | xargs -0 sed -i "s|usr|$PWD/usr|g"
fi

export PATH=$PWD/usr/bin:$PWD/usr/local/bin:$PATH
export PYTHONPATH=$PWD/usr/lib/python3.7/:$PWD/usr/local/lib/python3.7/dist-packages:/home/yann/.local/lib/python3.7/site-packages/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$PWD/usr/lib/x86_64-linux-gnu/

# [ ! -e get-pip.py ] && wget https://bootstrap.pypa.io/pip/3.7/get-pip.py && python 3.7 get-pip.py

python3.7 -m pip install setuptools
python3.7 -m pip install wheel
python3.7 -m pip install markupsafe==2.0.1
# [ ! -e venv ] && python3.7 -m venv venv
#[ $? = 1 ] && exit 1
# . venv/bin/activate
[ ! -e odoo-$ODOO ] && git clone --depth 1 -b 11.0 https://github.com/odoo/odoo && mv odoo odoo-$ODOO
#[ -e /home/linuxconsole2024/x86_64/ ] && grep psycopg2 odoo-$ODOO/requirements.txt && cd odoo-$ODOO && pwd && patch -p1 < ../linuxconsole-odoo.patch && cd ..
python3.7 -m pip install -r odoo-11/requirements.txt

install -d addons
#[ -e /home/linuxconsole2024/x86_64/lib/python3.10/site-packages/ ] && export PYTHONPATH=/home/linuxconsole2024/x86_64/lib/python3.10/site-packages/:$PYTHONPATH
python3.7 ./odoo-$ODOO/odoo-bin -d odoo-$ODOO --db_host localhost -r odoo -w odoo -i base # --addons-path=$PWD/addons,$PWD/odoo/addons #-i
