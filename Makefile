# Copyright 2024 dah4k
# SPDX-License-Identifier: MIT-0

DOCKER      ?= docker
PRODUCTS    ?= chromium firefox torbrowser
TAG_PREFIX  ?= local

_ANSI_NORM  := \033[0m
_ANSI_CYAN  := \033[36m

all: $(PRODUCTS) ## Build all container images

$(PRODUCTS):
	$(DOCKER) build --file Dockerfile.$@ --tag $(TAG_PREFIX)/$@ .

clean: ## Prune container images
	$(DOCKER) image prune --force
	$(DOCKER) system prune --force

distclean: ## Delete and prune built container images
	$(DOCKER) rmi --force $(addprefix $(TAG_PREFIX)/,$(PRODUCTS))
	$(DOCKER) image prune --force
	$(DOCKER) system prune --force

help usage:
	@grep -hE '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?##"}; {printf "$(_ANSI_CYAN)%-20s$(_ANSI_NORM) %s\n", $$1, $$2}'

.PHONY: help usage clean distclean
