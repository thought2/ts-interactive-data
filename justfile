purs_args := "--stash --censor-lib --censor-codes=ImplicitQualifiedImport"
cfg_test := "--config test.dhall"

build-strict:
    spago build --purs-args "--strict {{purs_args}}"

build:
    spago build --purs-args "{{purs_args}}"

test-strict:
    spago {{cfg_test}} test --purs-args "--strict {{purs_args}}"

test: test-purs test-ts

test-purs:
    spago {{cfg_test}} test --purs-args "{{purs_args}}"

test-ts:
    yarn run mocha --require ts-node/register 'ts-test/**/*.ts'

clean:
    rm -rf .spago output .psa-stash .parcel-cache

ide:
    spago {{cfg_test}} test --purs-args "{{purs_args}} --json-errors"

format:
    purs-tidy format-in-place 'src/**/*.purs'
    purs-tidy format-in-place 'test/**/*.purs'

check-format:
    purs-tidy check 'src/**/*.purs'
    purs-tidy check 'test/**/*.purs'

check-git-clean:
    [ -z "$(git status --porcelain)" ]

ci: check-format build-strict test-strict check-git-clean

gen-ts:
    spago run --main TS.InteractiveData.TsBridge.Main
    node scripts/copy-dts.js
    yarn run prettier --ignore-path "" --write output/*/index.d.ts