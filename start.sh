ODOO="18"

. include/functions.sh

which pg_config || sudo apt-get install -y postgresql-common libpq-dev python3-dev libldap2-dev  libsasl2-dev
which pg_config || exit 2

DEBIAN=""
[ -e /etc/debian_version ] && grep trixie /etc/debian_version && DEBIAN="TRIXIE"

if [ "$DEBIAN" = "TRIXIE" ]
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

if [ $ODOO == "12" ] || [ $ODOO == "13" ] || [ $ODOO == "14" ]
then

. include/old-odoo.sh

else

  PYTHONLIB=$(python3 --version | cut -d'.' -f1,2 | sed -e 's/ /-/' | sed 's/P/p/')
  PYTHON=$(python3 --version | cut -d'.' -f1,2 | sed -e 's/ //' | sed 's/P/p/')

  # which python3.10 && PYTHON="python3.10" && PYTHONLIB="python-3.10"

  [ ! -e venv ] && echo "Run " $PYTHON -m venv venv
  [ ! -e venv ] && $PYTHON -m venv venv
  . venv/bin/activate

  [ -e /home/linuxconsole2024/x86_64/lib/$PYTHON/site-packages/ ] && export PYTHONPATH=/home/linuxconsole2024/x86_64/lib/$PYTHON/site-packages/:$PYTHONPATH

 [ $ODOO == "16" ] && $PYTHON -m pip install psutil reportlab

fi

[ ! -e odoo-$ODOO ] && git clone --depth 1 -b $ODOO".0" https://github.com/odoo/odoo && mv odoo odoo-$ODOO

if [ -e /home/linuxconsole2024/x86_64/ ] 
then
  cd odoo-$ODOO
  grep psycopg2 requirements.txt && patch -p1 < ../linuxconsole-odoo.patch 
  cd ..
  $PYTHON -m pip install -r odoo-$ODOO/requirements.txt || exit 1
else
  $PYTHON -m pip install -r requirements/odoo-$ODOO-requirements.txt || $PYTHON -m pip install -r odoo-$ODOO/requirements.txt || exit 1
fi

echo > opt.txt

. include/addons-oca.sh
#. include/addons.sh
. include/oca-pr.sh

OPT=""

source opt.txt
rm opt.txt

# connector
$PYTHON -m pip install cachetools
MODULE="base"

echo " OPT : $OPT, MODULE: $MODULE"

$PYTHON ./odoo-$ODOO/odoo-bin -d odoo-$ODOO --db_host localhost --db_port=54$ODOO -r odoo -w odoo -i $MODULE -u $MODULE --without-demo=all --addons-path=$PWD/odoo-$ODOO/addons$OPT
