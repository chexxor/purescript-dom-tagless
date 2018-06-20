module Test.Main where
  
import Prelude

import DOM.Tagless.Class as D


program :: forall dom element. Monad dom => Element element =>
    dom element
program = do
  doc :: forall document. Document dom document => document
    <- document
  span :: forall element. Element dom element => element 
    <- createElement (TagName "span") doc
  setAttribute "id" "an-id" span
  setAttribute "class" "a-class" span
  body :: forall element. Element dom element => element
    <- querySelector (Selector "body")
  appendChild span' body
  pure unit

main :: Effect Unit
main = program
