if [ -e addons-pr ]
then
    install -d addons-oca-$ODOO
    cd addons-oca-$ODOO
	ls ../addons-pr | while read ADDON
	do
          echo "OPT=\$OPT,$PWD/$ADDON" >> ../opt.txt
	  cat  ../addons-pr/$ADDON | while read PR
	  do
      echo "Addon $ADDON, PR $PR" && sleep 2
      echo git clone --depth 1 -b $ODOO".0" https://github.com/OCA/$ADDON.git
      [ ! -e $ADDON ] && git clone --depth 1 -b $ODOO".0" https://github.com/OCA/$ADDON.git
      if [ ! -e $PR.patch ]
      then
        wget https://patch-diff.githubusercontent.com/raw/OCA/$ADDON/pull/$PR.patch
        cd $ADDON
        patch -p1 < ../$PR.patch || exit 2
        cd ..
      fi
	  done
	done
    cd ..
fi
