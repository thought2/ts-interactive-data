export PATH := "node_modules/.bin:" + env_var('PATH')
purs_args := "--stash --censor-lib --censor-codes=ImplicitQualifiedImport"
cfg_test := "--config test.dhall"

build-strict:
    spago build --purs-args "--strict {{purs_args}}"

build:
    spago build

test-strict:
    spago {{cfg_test}} test --purs-args "--strict {{purs_args}}"

test: test-purs

test-purs:
    spago {{cfg_test}} test --purs-args "{{purs_args}}"

clean:
    rm -rf .spago output .psa-stash .parcel-cache

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

ci: format build-strict test-strict check-git-clean

gen-ts:
    spago run --main TsBridge.InteractiveData.Main
    node scripts/copy-dts.js
    yarn run prettier --ignore-path "" --write output/*/index.d.ts

gen-readme:
    node scripts/gen-readme.js