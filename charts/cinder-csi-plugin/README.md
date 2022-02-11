# Cinder CSI volume provisioner

Deploys a Cinder csi provisioner to your cluster, with the appropriate storageClass.

## How To install
- Enable deployment of storageclasses using `storageClass.enabled`
- Tag the retain or delete class as default class using `storageClass.delete.isDefault` in your value yaml
- Set `storageClass.<reclaim-policy>.allowVolumeExpansion` to `true` or `false`

First add the repo:

    helm repo add kungze https://kungze.github.io/charts
    helm repo update

If you are using Helm v3:

    helm install cinder-csi kungze/cinder-csi-plugin

If you are using Helm v2:

    helm install --name cinder-csi kungze/cinder-csi-plugin
