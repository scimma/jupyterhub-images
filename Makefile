.PHONY: build
build:
	docker build .

.PHONY: push
push:
	docker push 585193511743.dkr.ecr.us-west-2.amazonaws.com/jupyterhub-singleuser-dev
