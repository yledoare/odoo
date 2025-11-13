domain = [('name','=','emilie')]
records = env["res.partner"].search(domain)
for record in records:
  print(record.name)
  fields = list(record.fields_get().keys())
  for field in fields:
                print(f"{field}: {getattr(record, field, 'N/A')}")
