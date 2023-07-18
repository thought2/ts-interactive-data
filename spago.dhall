{ name = "ts-interactive-data"
, dependencies =
  [ "aff-promise"
  , "data-mvc"
  , "dts"
  , "effect"
  , "either"
  , "integers"
  , "interactive-data"
  , "interactive-data-core"
  , "labeled-data"
  , "maybe"
  , "nullable"
  , "prelude"
  , "react-basic"
  , "record"
  , "these"
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
