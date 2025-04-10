variable "PWD" {default="" }

group "default" {
  targets = [
    "core"
  ]
}

target "core" {
  target = "core"
  tags = ["ghcr.io/djbender/test-ga-caching:latest", "ghcr.io/djbender/test-ga-caching:noble"]
  context = "${PWD}/core/noble"
  platforms = ["linux/amd64", "linux/arm64"]
  cache-from = ["type=gha,scope=core/noble"]
  cache-to = ["type=gha,scope=core/noble,mode=max"]
}
