export PATH := "node_modules/.bin:" + env_var('PATH')
purs_args := "--stash --censor-lib --censor-codes=ImplicitQualifiedImport"
cfg_test := "--config test.dhall"

build:
    spago build

test-strict:
    spago {{cfg_test}} test --purs-args "--strict {{purs_args}}"

test: test-purs

dev: clean-parcel
    parcel demo/basic/index.html

dist-examples:
    #!/usr/bin/env bash
    set -euxo pipefail
    rm -f output/package.json
    rm -rf .parcel-cache
    rm -rf dist
    for dir in demo/*/; do \
        echo Building $name; \
        main_dir="ts-interactive-data"; \
        name=$(basename $dir); \
        parcel build --dist-dir dist/$main_dir/$name --public-url /$main_dir/$name/ $dir/index.html ; \
    done

test-purs:
    spago {{cfg_test}} test --purs-args "{{purs_args}}"

clean: clean-parcel
    rm -rf .spago output .psa-stash 
    
clean-parcel:
    rm -rf .parcel-cache

dist:
    rm -rf output
    just dist_

dist_:
    rm -rf dist
    spago build
    just gen-ts
    rm -rf dist
    tsc
    cp -r output dist/output
    rm -rf dist/output/*/externs.cbor

ide:
    spago build --json-errors

format:
    purs-tidy format-in-place 'purs-pkgs/*/src/**/*.purs'
    purs-tidy format-in-place 'purs-pkgs/*/test/**/*.purs'

check-git-clean:
    [ -z "$(git status --porcelain)" ]

ci: clean format build gen check-git-clean

gen: gen-readme gen-ts

gen-ts:
    spago run --main TsBridge.InteractiveData.Main
    node scripts/copy-dts.js
    yarn run prettier --ignore-path "" --write output/*/index.d.ts

gen-readme:
    node scripts/gen-readme.js
    doctoc README.md