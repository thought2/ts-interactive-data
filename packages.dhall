
let upstream =
  https://github.com/purescript/package-sets/releases/download/psc-0.15.8-20230517/packages.dhall
    sha256:8b94a0cd7f86589a6bd06d48cb9a61d69b66a94b668657b2f10c8b14c16e028c

in upstream


with marked =
  { repo = "ssh://git@github.com/thought2/purescript-marked.git"
  , version = "e9505e2438fdf5dd975fcac96a759189b9574563"
  , dependencies = [ "console", "dts", "effect", "either", "integers", "labeled-data", "maybe", "newtype", "nullable", "prelude", "ts-bridge", "unsafe-coerce", "untagged-union", "variant", "variant-encodings" ]
  }


with data-mvc =
  { repo = "https://github.com/thought2/purescript-data-mvc.git"
  , version = "b7d9be8e404530c46f4f6ce7ba540f637220250f"
  , dependencies = [ "heterogeneous", "maybe", "newtype", "prelude", "record", "variant" ]
  }


with ts-bridge =
  { repo = "https://github.com/thought2/purescript-ts-bridge.git"
  , version = "3fe0e5dd6276822e1c43c1040356e3977559c26d"
  , dependencies = [ "aff", "aff-promise", "arrays", "console", "dts", "effect", "either", "foldable-traversable", "foreign-object", "literals", "maybe", "newtype", "node-buffer", "node-fs", "node-fs-aff", "node-path", "node-process", "nullable", "optparse", "ordered-collections", "ordered-set", "partial", "prelude", "record", "safe-coerce", "strings", "transformers", "tuples", "typelevel-prelude", "unsafe-coerce", "untagged-union", "variant", "variant-encodings" ]
  }


with virtual-dom-react-basic =
  { repo = "https://github.com/thought2/purescript-virtual-dom-react-basic.git"
  , version = "cbbdcd7acbb7d17cba03fb24f1c96da13a3dfb15"
  , dependencies = [ "arrays", "console", "effect", "foreign", "foreign-object", "maybe", "prelude", "react-basic", "react-basic-dom", "react-basic-hooks", "strings", "tuples", "unsafe-coerce", "virtual-dom", "web-dom" ]
  }


with virtual-dom-halogen =
  { repo = "https://github.com/thought2/purescript-virtual-dom-halogen.git"
  , version = "da50bb47a82fa887bef83d660f86df1d41b0dc80"
  , dependencies = [ "aff", "bifunctors", "effect", "foreign", "foreign-object", "halogen", "prelude", "safe-coerce", "strings", "tuples", "unsafe-coerce", "virtual-dom", "web-events", "web-html" ]
  }


with virtual-dom =
  { repo = "https://github.com/thought2/purescript-virtual-dom.git"
  , version = "8d68396155cfc308ba1f7ad7d11743b3b7f6ce38"
  , dependencies = [ "either", "foldable-traversable", "foreign", "maybe", "prelude", "strings", "these", "transformers", "tuples", "variant" ]
  }


with virtual-dom-styled =
  { repo = "ssh://git@github.com/thought2/purescript-virtual-dom-styled.git"
  , version = "c03248943699c52b034ff75ea00b49faaa125570"
  , dependencies = [ "prelude" ]
  }


with labeled-data =
  { repo = "https://github.com/thought2/purescript-labeled-data.git"
  , version = "02647c4a175d73fad22d8ecba4e8c618744d0404"
  , dependencies = [ "aff", "effect", "either", "maybe", "prelude", "record", "tuples", "type-equality", "unsafe-coerce", "variant" ]
  }


with variant-encodings =
  { repo = "https://github.com/thought2/purescript-variant-encodings.git"
  , version = "ec064edfd885f4efd0eb924ae4e26752ccf975c2"
  , dependencies = [ "prelude", "unsafe-coerce", "variant" ]
  }


with dts =
  { repo = "https://github.com/thought2/purescript-dts.git"
  , version = "0f71dd4a8ea966835eee31684e7b004c683e4f72"
  , dependencies = [ "arrays", "console", "effect", "maybe", "newtype", "ordered-collections", "ordered-set", "prelude", "tuples" ]
  }


with interactive-data-core =
  { repo = "https://github.com/thought2/purescript-interactive-data-core.git"
  , version = "7c60b863f9f70cf5466d3bdb9d67d0a6f7eff6d7"
  , dependencies = [ "data-mvc", "effect", "either", "heterogeneous", "identity", "newtype", "prelude", "profunctor", "record", "record-extra", "typelevel-prelude", "variant" ]
  }


with interactive-data =
  { repo = "ssh://git@github.com/thought2/purescript-interactive-data.git"
  , version = "f6d4e7342763c05a12f8339bef5dfb9db21f1b52"
  , dependencies = [ "argonaut", "argonaut-generic", "arrays", "convertable-options", "data-mvc", "dodo-printer", "either", "foldable-traversable", "identity", "integers", "interactive-data-core", "labeled-data", "maybe", "newtype", "numbers", "ordered-collections", "partial", "prelude", "record", "routing-duplex", "spec", "strings", "these", "tuples", "type-equality", "typelevel-prelude", "unordered-collections", "unsafe-coerce", "variant", "virtual-dom", "virtual-dom-styled" ]
  }


with data-functions =
  { repo = "ssh://git@github.com/thought2/purescript-data-functions.git"
  , version = "8707ec9f38faf43e5fbed190338580980be00557"
  , dependencies = [ "heterogeneous", "prelude" ]
  }


with xml-parser =
  { repo = "https://github.com/thought2/purescript-xml-parser.git"
  , version = "62e31fbf37c7dc9d064fdec79d73749dfb720b6b"
  , dependencies = [ "arrays", "control", "either", "lists", "prelude", "string-parsers", "strings" ]
  }


with purs-virtual-dom-assets =
  { repo = "ssh://git@github.com/thought2/purs-virtual-dom-assets.git"
  , version = "30f931b052f7b3298d38bb626ee5897c5bc20877"
  , dependencies = [ "aff", "arrays", "bifunctors", "console", "effect", "either", "exceptions", "foldable-traversable", "lists", "maybe", "node-buffer", "node-child-process", "node-fs", "node-path", "node-process", "optparse", "prelude", "string-parsers", "strings", "sunde", "transformers", "xml-parser" ]
  }


with ts-interactive-data =
  { repo = "ssh://git@github.com/thought2/ts-interactive-data.git"
  , version = "d79bd8b1ea7c1141c2ed5ff175dda2c407fc4ddf"
  , dependencies = [ "prelude" ]
  }

