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
      echo "MODULE=$ADDON" >> ../opt.txt
	  done
	done
  cd ..
fi
