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

# Target files
ENV_FILE ?= .env
RESUME ?= resume

EPHEMERAL_ARCHIVES ?= \
	$(OUTPUT) 

# Executables definition
DOCKER ?= docker run \
			--rm \
			--volume $(ROOT_DIR):/data \
			--workdir /data


%: # Treat unrecognized targets
	@ printf "\033[31;1mUnrecognized routine: '$(*)'\033[0m\n"
	$(MAKE) help

help:: ## Show this help
	@ printf '\033[33;1mGNU-Make available routines:\n'
	egrep -h '\s##\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[37;1m%-20s\033[0m %s\n", $$1, $$2}'

execute:: clean ## Export environment configuration
	$(DOCKER) pandoc/latex \
		$(RESUME).md \
		--output $(RESUME).pdf \
		--strip-comments

clean:: ## Delete project ephemeral archives
	-rm -fr $(EPHEMERAL_ARCHIVES)

veryclean:: clean ## Delete all generated files


.EXPORT_ALL_VARIABLES:
.ONESHELL:
.PHONY: help execute clean veryclean
