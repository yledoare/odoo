if [ -e addons ]
then
    install -d addons-$ODOO
    cd addons-$ODOO
	ls ../addons | while read ADDON
	do
    [ -e $ADDON ] && continue
	  install -d $ADDON
	  cd $ADDON
          echo "OPT=\$OPT,$PWD/$ADDON" >> ../../opt.txt
	  cat ../../addons/$ADDON | while read GIT
	  do
      FIRST=$(echo $GIT | cut -d' ' -f1) 
      # Skip commented line
		  [ "$FIRST" != "#" ] && git clone --depth 1 -b $ODOO".0" $GIT
	  done
	  cd ..
	done
    cd ..
fi
