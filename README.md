# Docker Image Builder

A purpose-built image for building and pushing container images via remote [BuildKit](https://github.com/moby/buildkit) daemons. It carries only what is needed for this role — no Docker Engine daemon, no `git`, no build toolchains.

Published to Docker Hub as [`zappi/image-builder`](https://hub.docker.com/r/zappi/image-builder). Built for `linux/amd64` and `linux/arm64`.

## Contents

| Component | Version |
|-----------|---------|
| Base image | Ubuntu 24.04 LTS |
| [Docker CLI](https://github.com/docker/cli) | 29.3.0 |
| [Docker Buildx plugin](https://github.com/docker/buildx) | 0.31.1 |
| [Amazon ECR Credential Helper](https://github.com/awslabs/amazon-ecr-credential-helper) | 0.12.0 |

The image runs as a non-root `builder` user (UID/GID `1001`).

## Docker CLI Configuration

No `~/.docker/config.json` is baked into the image. It is expected to be provided at runtime — for example, mounted via a Kubernetes ConfigMap.

### AWS ECR Credential Helper Configuration

The config should wire the ECR credential helper for the registries the builder needs to authenticate with:

```json
{
  "credHelpers": {
    "public.ecr.aws": "ecr-login",
    "<account-id>.dkr.ecr.<region>.amazonaws.com": "ecr-login"
  }
}
```

The ECR credential helper (`docker-credential-ecr-login`) is already present in the image. It follows the standard [AWS credential chain](https://docs.aws.amazon.com/sdkref/latest/guide/standardized-credentials.html#credentialProviders), so no static credentials need to be baked into the image.

## Releases

Images are tagged and pushed to Docker Hub on every [GitHub Release](https://github.com/Intellection/docker-image-builder/releases). Tags follow the version in the release (e.g. `zappi/image-builder:1.0.0`).

## References

- [docker/cli](https://github.com/docker/cli)
- [docker/buildx](https://github.com/docker/buildx)
- [awslabs/amazon-ecr-credential-helper](https://github.com/awslabs/amazon-ecr-credential-helper)
