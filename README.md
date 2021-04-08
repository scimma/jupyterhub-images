# jupyterhub-images

This is a little repo for managing the "singleuser" image used in SCiMMA's
Jupyterhub instances.

The "singleuser" image is the environment that users get which runs their
notebooks. It's where we install stuff like common Python libraries.

The image is built with a [Dockerfile](./Dockerfile) which lists out
dependencies. It is based on the `jupyter/scipy-notebook` base image, pinned to
a arbitrarily-picked version. The version is pinned just so that building the
image stays consistent, but it _should_ be safe to update it over time.

## Building and releasing a new version of the container

The general workflow for updating the singleuser image that's actually deployed
is as follows:

 1. Make edits to the Dockerfile
 2. Build the container
 3. Push to an AWS ECR registry

Our jupyterhub instance is set up to always pull the "`latest`" version of the
singleuser image when a user starts a server, so once this is done, new users
will get your updates automatically.


### Building and pushing the container

There's a script that will handle building and pushing for you. Just run:
```
./deploy/build_and_push.sh dev  # or 'prod'
```

This will build the container and push it to ECR for you in the `dev`
environment (you can also pass in `prod` instead to push there).

You can try out a build with `docker build .`. That will at least tell you
whether your commands have a syntax error, or something, without pushing.

There's currently no way to test your changes locally. The only way to test is
to push to the [development instance of
JupyterHub](https://jupyter.dev.scimma.org).

#### How this works

Docker uses _names_ to identify built container images. The names themselves can
be URLs which denote a remote repository where the container can be stored.

Our images are stored in two repositories (ie, two names) - one each for the
`prod` and `dev` environments:

| env | name |
|-----|------|
| dev | 585193511743.dkr.ecr.us-west-2.amazonaws.com/scimma-jupyterhub-singleuser-dev |
| prod | 585193511743.dkr.ecr.us-west-2.amazonaws.com/scimma-jupyterhub-singleuser-prod |

You provide a tag at build time, like this:

```sh
docker build --tag 585193511743.dkr.ecr.us-west-2.amazonaws.com/scimma-jupyterhub-singleuser-dev
```

Once built, a tagged container can be _pushed_ to the ECR repository. To do
this, you need to first log in to the ECR repository, which you do with your AWS
credentials.

Using the AWS CLI, you can get a login password with `aws ecr
get-login-password`. You can pipe this to `docker-login` to actually log in.

As a script, that looks like this:

```sh
aws ecr get-login-password | docker login --username AWS --password-stdin 585193511743.dkr.ecr.us-west-2.amazonaws.com
```

Once you're logged in, you can push the (already-built) container into ECR like
this:

```
docker push 585193511743.dkr.ecr.us-west-2.amazonaws.com/scimma-jupyterhub-singleuser-dev
```

This will update the `latest` tag to point to your new container version.
