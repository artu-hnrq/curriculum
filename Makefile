# Development management facilities
#
# This file specifies useful routines to streamline development management.
# See https://www.gnu.org/software/make/.


# Consume environment variables
ifneq (,$(wildcard .env))
	include .env
endif

# Tool configuration
SHELL := /bin/bash
GNUMAKEFLAGS += --no-print-directory

# Path record
ROOT_DIR ?= $(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SOURCE_DIR ?= src
DATA_DIR ?= .contentlayer
LIB_DIR ?= lib
DIST_DIR ?= dist

# Target files
ENV_FILE ?= .env
MD ?= $(RESUME).md
CSS ?= $(SOURCE_DIR)/$(RESUME).css
HTML ?= $(DIST_DIR)/$(RESUME).html
PDF ?= $(DIST_DIR)/$(RESUME).pdf

EPHEMERAL_ARCHIVES ?= \
	$(DIST_DIR) \
	$(LIB_DIR) \
	**/$(DATA_DIR)

# Executables definition
DOCKER ?= docker run \
			--rm \
			--volume $(ROOT_DIR):/data \
			--workdir /data \
			--user $(shell id -u):$(shell id -g)

# Behavior definition
RESUME ?= resume


%: # Treat unrecognized targets
	@ printf "\033[31;1mUnrecognized routine: '$(*)'\033[0m\n"
	$(MAKE) help

help:: ## Show this help
	@ printf '\033[33;1mGNU-Make available routines:\n'
	egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;1m%-20s\033[0m %s\n", $$1, $$2}'

init:: veryclean ## Initialize development environment
	npm install

build:: start ## Transpile source code
	npm run build
	cp --force --recursive $(DATA_DIR) $(LIB_DIR)

dev:: start dir ## Run typescript code
	npm run dev -- $(HTML)

execute:: start compile run ## Export environment configuration

start:: clean ## Run contentlayer
	npm run start
	cp --force --recursive $(DATA_DIR) $(SOURCE_DIR)

compile:: dir ## Treat Markdown content processing
	npm run compile -- $(HTML)

preview:: ## Execute resume generation
	npm run preview -- $(HTML) -o $(HTML)

run:: dir ## Execute resume generation
	$(DOCKER) surnet/alpine-wkhtmltopdf:3.19.0-0.12.6-small \
		--page-size A4 \
		--dpi 300 \
		--user-style-sheet $(CSS) \
		$(HTML) \
		$(PDF)

dir:: ## Create project directories
	mkdir --parent $(DIST_DIR)
	cp --force $(CSS) $(DIST_DIR)

clean:: ## Delete project ephemeral archives
	-rm -fr $(EPHEMERAL_ARCHIVES)

veryclean:: clean ## Delete all generated files
	-rm -fr node_modules


.EXPORT_ALL_VARIABLES:
.ONESHELL:
.PHONY: help init execute compile run dir clean veryclean
