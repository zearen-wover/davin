module Conlang.Davɪn.Njojsɪþ.Test (tests) where

import Conlang.Davɪn.Njojsɪþ.Internal
import Conlang.Davɪn.Njojsɪþ.Letters

import Test.HUnit

import Test.Util (assertPreludeError)

e' = stem e
i' = stem i
ej = sprout j $ stem e
en = root n $ stem e
ed = root d $ stem e
ejd = root d $ sprout j $ stem e
end = nasal $ root d $ stem e
enz = nasal $ root z $ stem e
inz = nasal $ root z $ stem i

tests :: Test
tests = test
  [ "ordering" ~:
    [ "lexicographicOrder" ~:
      [ lexicographicOrder [] ~?= EQ
      , lexicographicOrder [EQ, EQ, EQ] ~?= EQ
      , lexicographicOrder [EQ, EQ, LT] ~?= LT
      , lexicographicOrder [EQ, LT, EQ] ~?= LT
      , lexicographicOrder [GT, LT] ~?= GT
      ]
    , "Consonant" ~:
      [ compare p k ~?= LT
      , compare p b ~?= LT
      , compare b f ~?= LT
      , compare ʃ ʃ ~?= EQ
      , compare ʒ þ ~?= GT
      , compare ŋ p ~?= GT
      ]
    , "Syllable" ~:
      [ compare i' e' ~?= LT
      , compare e' ej ~?= LT
      , compare inz enz ~?= LT
      , compare ed ed ~?= EQ
      , compare inz inz ~?= EQ
      , compare en end ~?= GT
      , compare end ed ~?= GT
      , compare ed ej ~?= GT
      ]
    , "Letter" ~:
      [ compare (loneCon r) (loneCon j) ~?= LT
      , compare (loneCon w) (loneCon ʒ) ~?= GT
      , compare (loneCon d) (loneCon s) ~?= LT
      , compare (loneCon h) (loneCon l) ~?= GT
      , compare (loneCon x) (loneCon x) ~?= EQ
      , compare (loneCon w) (loneCon w) ~?= EQ
      , compare (loneCon g) (Syl ej) ~?= LT
      , compare (Syl inz) (loneCon h) ~?= GT
      , compare (Syl i') (Syl inz) ~?= LT
      , compare (Syl enz) (Syl ed) ~?= GT
      , compare (Syl ejd) (Syl ejd) ~?= EQ
      , compare (Syl e') (Special '.') ~?= LT
      , compare (Special ' ') (Syl en) ~?= GT
      , compare (Special '1') (Special '4') ~?= LT
      , compare (Special '2') (Special '1') ~?= GT
      , compare (Special '!') (Special '!') ~?= EQ
      ]
    ]
  , "constructor" ~:
    [ "mkCon" ~:
      [ mkCon C_t True False ~?= Consonant
        { _conRoot = C_t
        , _conVoiced = True
        , _conFricative = False
        }
      ]
    , "Letters" ~:
      [ "Consonant" ~:
        [ p ~?= Consonant
            { _conRoot = C_p
            , _conVoiced = False
            , _conFricative = False
            }
        , d ~?= Consonant
            { _conRoot = C_t
            , _conVoiced = True
            , _conFricative = False
            }
        , ʃ ~?= Consonant
            { _conRoot = C_þ
            , _conVoiced = False
            , _conFricative = True
            }
        , ɣ ~?= Consonant
            { _conRoot = C_k
            , _conVoiced = True
            , _conFricative = True
            }
        , n ~?= Consonant
            { _conRoot = C_r
            , _conVoiced = False
            , _conFricative = True
            }
        ]
      , "Sprout" ~:
        [ w ~?= S_w
        , l ~?= S_l
        ]
      , "Stem" ~:
        [ y ~?= V_y
        , a ~?= V_a
        , u ~?= V_u
        ]
      ]
    ]
  , "operator" ~:
    [ "nasal" ~:
      [ test $ assertPreludeError "Expected error" (nasal $ stem e)
      , test $ assertPreludeError "Expected error" (nasal $ root r $ stem e)
      , (nasal $ root t $ stem e) ~?= Syllable
          { _sylStem = e
          , _sylSprout = Nothing
          , _sylNasal = True
          , _sylRoot = Just t
          }
      ]
    ]
  ]
