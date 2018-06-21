module Test.Main where
  
import DOM.Tagless.Class
import Prelude

import Data.Nullable (Nullable)
import Effect (Effect)


program :: forall dom element. Monad dom => WindowTC dom =>
    dom Element
program = do
  -- !!!
  -- How to compose these instructions?
  --   They are all in different monads -- `WindowTC`, `DocumentTC`, `ElementTC`, ...
  --   Do we need a `MonadDOM` into which to lift each of these?
  doc :: Document
    <- document
  let
    span :: DocumentTC doc => doc Element
    span = createElement (TagName "span") doc
    span' :: ElementTC element => element Element
    span' = do
      setAttribute "id" "an-id" span
      setAttribute "class" "a-class" span
  body :: Nullable Element
    <- querySelector (Selector "body") doc
--   appendChild span body
  pure span

main :: Effect Unit
main = program
