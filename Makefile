JSONNET_FMT := jsonnetfmt -n 2 --max-blank-lines 2 --string-style s --comment-style s

all: clean fmt generate_alerts generate_rules dashboards_out lint check_alerts check_rules

fmt:
	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		xargs -n 1 -- $(JSONNET_FMT) -i

.phony: generate_alerts
generate_alerts:
	TEMPLATE_TYPE=alerts bash scripts/generate_rules.sh

.phony: generate_rules
generate_rules:
	TEMPLATE_TYPE=rules bash scripts/generate_rules.sh

dashboards_out: mixin.libsonnet config.libsonnet $(wildcard dashboards/*)
	@mkdir -p dashboards_out
	jsonnet -J vendor -m dashboards_out dashboards.jsonnet

lint:
	find . -name 'vendor' -prune -o -name '*.libsonnet' -print -o -name '*.jsonnet' -print | \
		while read f; do \
			$(JSONNET_FMT) "$$f" | diff -u "$$f" -; \
		done

check_rules:
	TEMPLATE_TYPE=rules bash scripts/check_rules.sh

check_alerts:
	TEMPLATE_TYPE=alerts bash scripts/check_rules.sh

clean:
	rm -rf dashboards_out rules/generates/*.yaml alerts/generates/*.yaml
