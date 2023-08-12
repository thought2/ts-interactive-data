export PATH := "node_modules/.bin:" + env_var('PATH')

build:
    spago build

build-strict:
    spago build --json-errors | node scripts/filter-warnings.js

test:
    spago test

dev: clean-parcel
    parcel demo/basic/index.html | node scripts/filter-warnings.js

build-ide:
    spago build --json-errors | node scripts/filter-warnings.js

format:
    purs-tidy format-in-place 'purs-pkgs/*/src/**/*.purs'
    purs-tidy format-in-place 'purs-pkgs/*/test/**/*.purs'

install-git-hooks:
    rm -rf .git/hooks
    ln -s ../git-hooks .git/hooks

# Dist

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

# Clean

clean: clean-parcel
    rm -rf .spago output .psa-stash 
    
clean-parcel:
    rm -rf .parcel-cache

# CI

ci: clean
    just ci_

ci_: format build-strict gen check-git-clean

check-git-clean:
    [ -z "$(git status --porcelain)" ]

# Generate

gen: gen-readme gen-ts

gen-ts:
    spago run --main TsBridge.InteractiveData.Main
    node scripts/copy-dts.js
    yarn run prettier --ignore-path "" --write output/*/index.d.ts

gen-readme:
    node scripts/gen-readme.js
    doctoc README.md