{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'argocd',
        rules: [
          {
            alert: 'ArgoCDAppOutOfSync',
            expr: |||
              (
                argocd_app_info{sync_status="OutOfSync"} > 0
              )
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'ArgoCD Application {{ $labels.name }} is OutOfSync for longer than 5 minutes',
              description: 'ArgoCD Application {{ $labels.name }} is OutOfSync for longer than 5 minutes',
            },
          },
          {
            alert: 'ArgoCDAppProgressing',
            expr: |||
              (
                argocd_app_info{health_status="Progressing"} > 0
              )
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'ArgoCD Application {{ $labels.name }} Progressing longer than 5 minutes',
              description: 'ArgoCD Application {{ $labels.name }} Progressing longer than 5 minutes',
            },
          },
          {
            alert: 'ArgoCDAppUnknown',
            expr: |||
              (
                argocd_app_info{health_status="Unknown"} > 0
              )
            ||| % $._config,
            'for': '1m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'ArgoCD Application {{ $labels.name }} Unknown for 1 minute',
              description: 'ArgoCD Application {{ $labels.name }} Unknown for 1 minute',
            },
          },
          {
            alert: 'ArgoCDAppMissing',
            expr: |||
              (
                argocd_app_info{health_status="Missing"} > 0
              )
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'ArgoCD Application {{ $labels.name }} Missing for 5 minutes',
              description: 'ArgoCD Application {{ $labels.name }} Missing for 5 minutes',
            },
          },
          {
            alert: 'ArgoCDAppDegraded',
            expr: |||
              (
                argocd_app_info{health_status="Degraded"} > 0
              )
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'ArgoCD Application {{ $labels.name }} Degraded for 5 minutes',
              description: 'ArgoCD Application {{ $labels.name }} Degraded for 5 minutes',
            },
          },
          {
            alert: 'ArgoAppMissing',
            expr: |||
              (
                absent(argocd_app_info)
              )
            ||| % $._config,
            'for': '15m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: '[ArgoCD] No reported applications',
              description: 'ArgoCD has not reported any applications data for the past 15 minutes which\n               means that it must be down or not functioning properly.  This needs to be\n               resolved for this cluster to continue to maintain state',
            },
          },
          {
            alert: 'ArgoAppNotSynced',
            expr: |||
              (
                argocd_app_info{sync_status!="Synced"} == 1
              )
            ||| % $._config,
            'for': '12h',
            labels: {
              severity: 'warning',
            },
            annotations: {
              summary: '[{{`{{$labels.name}}`}}] Application not synchronized',
              description: 'The application [{{`{{$labels.name}}`}} has not been synchronised for over\n               12 hours which means that the state of ArgoCD applications on this cluster \n               have drifted away from the git state',
            },
          },
        ],
      },
    ],
  },
}
