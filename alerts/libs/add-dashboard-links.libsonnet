local utils = import '../../lib/utils.libsonnet';

local lower(x) =
  local cp(c) = std.codepoint(c);
  local lowerLetter(c) =
    if cp(c) >= 65 && cp(c) < 91
    then std.char(cp(c) + 32)
    else c;
  std.join('', std.map(lowerLetter, std.stringChars(x)));

{
  _config+:: {
    dashboardURLPattern: 'https://dashboard.polarpoint.io',
  },

  prometheusAlerts+::
    local addDashboardURL(rule) = rule {
      [if 'alert' in rule && !('dashboard_url' in rule.annotations) then 'annotations']+: {
        dashboard_url: $._config.dashboardURLPattern,
      },
    };
    utils.mapRuleGroups(addDashboardURL),
}
