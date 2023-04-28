locals {
  default_version = coalesce(var.distribution_version, "1.15.1")

  default_helm_config = {
    name             = "undefined"
    chart            = "undefined"
    repository       = "https://istio-release.storage.googleapis.com/charts"
    version          = local.default_version
    namespace        = "istio-system"
    create_namespace = true
    description      = "Istio service mesh"
  }

  default_base_helm_values    = "base"
  default_istiod_helm_values  = "istiod"
  default_gateway_helm_values = "gateway"

  base_helm_config = merge(
    local.default_helm_config,
    { name = "istio-base", chart = "base" },
    var.base_helm_config,
    { values = concat(local.default_base_helm_values, lookup(var.base_helm_config, "values", [])) }
  )

  istiod_helm_config = merge(
    local.default_helm_config,
    { name = "istio-istiod", chart = "istiod" },
    var.istiod_helm_config,
    { values = concat(local.default_istiod_helm_values, lookup(var.istiod_helm_config, "values", [])) }
  )

  gateway_helm_config = merge(
    local.default_helm_config,
    { name = "istio-ingressgateway", chart = "gateway" },
    var.gateway_helm_config,
    { values = concat(local.default_gateway_helm_values, lookup(var.gateway_helm_config, "values", [])) }
  )

  argocd_gitops_config = {
    enable = true
  }
}
