.PHONY: help clean copyImages slides script loadLibs

SCRIPT_FILE=src/jenkinsPipelines.adoc

SRCS=$(wildcard src/*.adoc)
SLIDES=$(patsubst src/%,build/%,$(SRCS:.adoc=.html))
all: $(OBJS)

ASCIIDOCTOR_OPTIONS=-T templates/ -r asciidoctor-kroki
ASCIIDOCTOR_REVEALJS_OPTIONS=-b revealjs -a revealjsdir=../libs/reveal.js

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# ------------------------------------------------------
# GLOBAL
# ------------------------------------------------------

all: clean slides script  ## Clean, Build slides and script

clean: ## Clean current slides and all
	rm -rf build

copyImages:
	mkdir -p build/images
	cp src/images/* build/images

build/%.html : src/%.adoc
	bundle exec asciidoctor-revealjs $(ASCIIDOCTOR_OPTIONS) $(ASCIIDOCTOR_REVEALJS_OPTIONS) -o $@ $<

slides: copyImages $(SLIDES) ## Build the slides for this presentation

script: copyImages ## Build the script for this presentation
	bundle exec asciidoctor $(ASCIIDOCTOR_OPTIONS) -o build/jenkinsPipelines-script.html $(SCRIPT_FILE)

loadLibs: ## Load external libs for proper function
	git clone -b 3.9.2 --depth 1 https://github.com/hakimel/reveal.js.git libs/
