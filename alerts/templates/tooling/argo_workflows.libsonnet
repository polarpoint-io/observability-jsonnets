{
  prometheusAlerts+:: {
    groups+: [
      {
        name: 'argo_workflows',
        rules: [
          {
            alert: 'ArgoWorkflowsPodMissing',
            expr: |||
              (
                argo_pod_missing
              )
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Argo Workflows is under high loads and the Controller pod is missing for longer than 5 minutes',
              description: 'Argo Workflows is under high loads and the Controller pod is missing for longer than 5 minutes',
            },
          },
          {
            alert: 'ArgoWorkflowsHighControllerErrorCount',
            expr: |||
              (
                argo_workflows_error_count > 0
              )
            ||| % $._config,
            'for': '5m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              summary: 'Argo Workflows has a high number of workflow pods in error state',
              description: 'Argo Workflows has a high number of workflow pods in error state',
            },
          },
        ],
      },
    ],
  },
}
