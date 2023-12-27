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
OUTPUT_DIR ?= dist

# Target files
ENV_FILE ?= .env
RESUME ?= resume
MD ?= $(RESUME).md
CSS ?= $(RESUME).css
HTML ?= $(OUTPUT_DIR)/$(RESUME).html
PDF ?= $(OUTPUT_DIR)/$(RESUME).pdf

EPHEMERAL_ARCHIVES ?= \
	$(OUTPUT_DIR)

# Executables definition
DOCKER ?= docker run \
			--rm \
			--volume $(ROOT_DIR):/data \
			--workdir /data \
			--user $(shell id -u):$(shell id -g)


%: # Treat unrecognized targets
	@ printf "\033[31;1mUnrecognized routine: '$(*)'\033[0m\n"
	$(MAKE) help

help:: ## Show this help
	@ printf '\033[33;1mGNU-Make available routines:\n'
	egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;1m%-20s\033[0m %s\n", $$1, $$2}'

init:: veryclean ## Initialize development environment
	npm install

execute:: clean compile run ## Export environment configuration
	
compile:: dir ## Treat Markdown content processing
	node main.js $(MD) $(HTML)

preview:: ## Execute resume generation
	npx http-server -d $(HTML) -o $(HTML) -c-1

run:: dir ## Execute resume generation
	$(DOCKER) surnet/alpine-wkhtmltopdf:3.19.0-0.12.6-small \
		--page-size A4 \
		--dpi 300 \
		--user-style-sheet $(CSS) \
		$(HTML) \
		$(PDF)

dir:: ## Create project directories
	mkdir --parent $(OUTPUT_DIR)

clean:: ## Delete project ephemeral archives
	-rm -fr $(EPHEMERAL_ARCHIVES)

veryclean:: clean ## Delete all generated files
	-rm -fr node_modules


.EXPORT_ALL_VARIABLES:
.ONESHELL:
.PHONY: help init execute compile run dir clean veryclean
