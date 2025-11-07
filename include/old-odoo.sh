PYTHONLIB="python-3.7"
PYTHON="python3.7"

if [ ! -e usr ]
then
	for PKG in libicu63 libnode64 nodejs node-less python3-pyldap python3-vatnumber python3-suds python3-gevent python3-feedparser python3-html2text python3-reportlab python3-psycopg2 python3-psutil libffi6 python3-pip python3-distutils python3-venv python-pip-whl $PYTHON lib$PYTHON-stdlib $PYTHON-minimal $PYTHON-venv lib$PYTHON-minimal
	do
		install-local-deb buster $PKG
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
