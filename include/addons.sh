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

if [ -e myaddons ]
then
  install -d myaddons-$ODOO
  cd myaddons-$ODOO
	ls ../myaddons | while read ADDON
	do
    echo "OPT=\$OPT,$PWD" >> ../opt.txt
	  cat ../myaddons/$ADDON | while read GIT
	  do
      FIRST=$(echo $GIT | cut -d' ' -f1) 
      # Skip commented line
      ADDON=$(echo $GIT | cut -d'/' -f5 | sed -e 's/.git//')
      echo git clone --depth 1 -b $ODOO".0" $GIT
		  [ "$FIRST" != "#" ] && [ ! -e $ADDON ] && git clone --depth 1 -b $ODOO".0" $GIT
		  [ "$FIRST" != "#" ] && [ ! -e $ADDON ] && git clone --depth 1 $GIT
      [ "$FIRST" != "#" ] && [ ! -e $ADDON ] && exit 1
      MODULE=$ADDON
	  done
	done
  cd ..
fi
