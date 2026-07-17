# Ruby Paketo Buildpack

## `gcr.io/paketo-buildpacks/ruby`

The Ruby Paketo Buildpack provides a set of collaborating buildpacks that
enable the building of a Ruby-based application. These buildpacks include:
- [Bundle Install](https://github.com/paketo-buildpacks/bundle-install)
- [Bundler](https://github.com/paketo-buildpacks/bundler)
- [MRI](https://github.com/paketo-buildpacks/mri)
- [Node Engine](https://github.com/paketo-buildpacks/node-engine)
- [Passenger](https://github.com/paketo-buildpacks/passenger)
- [Puma](https://github.com/paketo-buildpacks/puma)
- [Rackup](https://github.com/paketo-buildpacks/rackup)
- [Rails Assets](https://github.com/paketo-buildpacks/rails-assets)
- [Rake](https://github.com/paketo-buildpacks/rake)
- [Thin](https://github.com/paketo-buildpacks/thin)
- [Unicorn](https://github.com/paketo-buildpacks/unicorn)
- [Yarn Install](https://github.com/paketo-buildpacks/yarn-install)
- [Yarn](https://github.com/paketo-buildpacks/yarn)

The buildpack supports building simple Ruby applications or applications which
utilize [Bundler](https://bundler.io/) for managing their dependencies. Usage
examples can be found in the
[`samples` repository under the `ruby` directory](https://github.com/paketo-buildpacks/samples/tree/main/ruby).

#### The Ruby buildpack is compatible with the following builder(s):
- [Paketo Jammy Full Builder](https://github.com/paketo-buildpacks/builder-jammy-full)
- [Paketo Jammy Base Builder](https://github.com/paketo-buildpacks/builder-jammy-base)

## Packaging

To package this buildpack for consumption:

```bash
./scripts/package.sh --version <version-number>
```

For example:
```bash
./scripts/package.sh --version 0.47.14
```

This will create a `buildpackage.cnb` file and a `buildpack-release-artifact.tgz` archive in the `build/` directory.

## Publishing

To publish this buildpack to ECR:

```bash
# First, authenticate with ECR (if not already authenticated)
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin 348674388966.dkr.ecr.us-east-1.amazonaws.com

# Then publish the buildpack
./scripts/publish.sh \
  --archive-path build/buildpack-release-artifact.tgz \
  --image-ref 348674388966.dkr.ecr.us-east-1.amazonaws.com/neeto-deploy/paketo/buildpack/ruby:<version>
```

For example:
```bash
./scripts/publish.sh \
  --archive-path build/buildpack-release-artifact.tgz \
  --image-ref 348674388966.dkr.ecr.us-east-1.amazonaws.com/neeto-deploy/paketo/buildpack/ruby:0.47.14
```

The script will automatically publish the composite buildpack as a multi-arch image to ECR.
