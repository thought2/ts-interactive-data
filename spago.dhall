{ name = "ts-interactive-data"
, dependencies =
  [ "aff-promise"
  , "dts"
  , "effect"
  , "either"
  , "integers"
  , "interactive-data"
  , "interactive-data-core"
  , "maybe"
  , "nullable"
  , "prelude"
  , "ts-bridge"
  , "tuples"
  , "unsafe-coerce"
  , "variant"
  , "virtual-dom"
  , "virtual-dom-react-basic"
  , "virtual-dom-styled"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs" ]
}
