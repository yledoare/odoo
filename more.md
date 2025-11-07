# Unit test

$PYTHON ./odoo-$ODOO/odoo-bin -i animal -r odoo -w odoo --test-enable ...

# Enable logo if needed

Technical -> System parameters
key : url

web.base.url : replace http://localhost:8069

# Report in HTML

http://localhost:8069/my/orders/1?report_type=html

# wkhtmltopdf wraper

> #!/bin/sh
> install -d $HOME/odoo-debug
> echo $@ >> $HOME/odoo-debug/cmd
> cp $HOME/tmp/*.html $HOME/odoo-debug
> $HOME/src/odoo/usr/local/bin/wkhtmltopdf-bin $@
