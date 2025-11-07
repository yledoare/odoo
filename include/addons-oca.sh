if [ -e addons-oca ]
then
    install -d addons-oca-$ODOO
    cd addons-oca-$ODOO
	ls ../addons-oca | while read ADDON
	do
          echo "OPT=\$OPT,$PWD/$ADDON" >> ../opt.txt
	  cat  ../addons-oca/$ADDON | while read GIT
	  do
		[ ! -e $ADDON ] && echo "Clone $ADDON" && git clone --depth 1 -b $ODOO".0" $GIT
	  done
	done
    cd ..
fi
