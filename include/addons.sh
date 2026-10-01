if [ -e addons ]
then
  install -d addons-$ODOO
  cd addons-$ODOO
	ls ../addons | while read ADDON
	do
	  echo "Addon : $ADDON"
          # [ -e $ADDON ] && continue
	  install -d $ADDON
	  cd $ADDON
          echo "OPT=\$OPT,$PWD/$ADDON" >> ../../opt.txt
	  cat ../../addons/$ADDON | while read GIT
	  do
            # Skip commented line
            FIRST=$(echo $GIT | cut -d' ' -f1) 
	    if [ "$FIRST" != "#" ] 
	    then
	      [ ! -e $GIT ] && git clone --depth 1 -b $ODOO".0" $GIT || git clone --depth 1 $GIT 
	    fi
	  done
	  cd ..
	done
  cd ..
fi
