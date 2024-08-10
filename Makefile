# Copyright 2024 dah4k
# SPDX-License-Identifier: MIT-0

DOCKER      ?= docker
PRODUCTS    ?= chromium firefox torbrowser libreoffice
TAG_PREFIX  ?= local

_ANSI_NORM  := \033[0m
_ANSI_CYAN  := \033[36m

help usage:
	@grep -hE '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
		| awk 'BEGIN {FS = ":.*?##"}; {printf "$(_ANSI_CYAN)%-20s$(_ANSI_NORM) %s\n", $$1, $$2}'

all: $(PRODUCTS) ## Build all container images

$(PRODUCTS):
	$(DOCKER) build --file Dockerfile.$@ --tag $(TAG_PREFIX)/$@ .

list: ## List all container images
	@for x in $(subst -,:,$(PRODUCTS)); do \
		if test -t 1; then \
			printf "$(_ANSI_CYAN)%s$(_ANSI_NORM)\n" $$x; \
		else \
			echo $$x; \
		fi; \
	done

files/chrome.json:
	curl -L -o $@ https://raw.githubusercontent.com/jessfraz/dotfiles/master/etc/docker/seccomp/chrome.json

clean: ## Prune container images
	$(DOCKER) image prune --force
	$(DOCKER) system prune --force

distclean: ## Delete and prune built container images
	$(DOCKER) rmi --force $(addprefix $(TAG_PREFIX)/,$(PRODUCTS))
	$(DOCKER) image prune --force
	$(DOCKER) system prune --force

.PHONY: help usage clean distclean
