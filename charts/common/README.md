# Openstack Kolla Helm Common Library Chart

Openstack Kolla Helm 公共库，用于生成一些公用得函数和模板等...

## Use

```yaml
dependencies:
  - name: common
    version: 0.x.x
    repository: https://kungze.github.io/charts
```

```bash
$ helm dependency update
```

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.names.fullname" . }}
data:
  myvalue: "Hello World"
```

## Parameters

### Image

| Helper identifier           | Description                                          | Expected Input                                                                                          |
|-----------------------------|------------------------------------------------------|---------------------------------------------------------------------------------------------------------|
| `common.images.image`       | Return the proper and full image name                | `dict "imageRoot" .Values.path.to.the.image "global" $`, see [ImageRoot](#imageroot) for the structure. |

### Labels

| Helper identifier           | Description                                          | Expected Input    |
|-----------------------------|------------------------------------------------------|-------------------|
| `common.labels.standard`    | Return Kubernetes standard labels                    | `.` Chart context |
| `common.labels.matchLabels` | Return the proper Docker Image Registry Secret Names | `.` Chart context |

### TplValues

| Helper identifier         | Description                            | Expected Input                                                                                                                                           |
|---------------------------|----------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| `common.tplvalues.render` | Renders a value that contains template | `dict "value" .Values.path.to.the.Value "context" $`, value is the value should rendered as template, context frequently is the chart context `$` or `.` |
