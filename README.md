# observability-jsonnets

build the Prometheus alerts files:
```bash
  make generate_alerts
```

build the Prometheus rules files:
```bash
  make generate_rules
```

Test the validity of the generated yaml

check the Prometheus rules files:
```bash
  make check_rules
```
check the Prometheus alerts files:
```bash
  make check_alerts
```