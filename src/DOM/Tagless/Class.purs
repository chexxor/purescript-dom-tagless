module DOM.Tagless.Class where
  
import Prelude

import Data.Nullable (Nullable)
import Effect (Effect)
import Unsafe.Coerce (unsafeCoerce)



foreign import data Document :: Type
foreign import data Element :: Type
foreign import data Node :: Type

class WindowTC m where

  -- Returns a reference to the document contained in the window.
  document :: m Document


-- A String containing one or more selectors to match.
-- This string must be a valid CSS selector string.
newtype Selector = Selector String
newtype TagName = TagName String

-- The Document interface represents any web page loaded in the browser and serves as an entry
--   point into the web page's content, which is the DOM tree.
-- https://developer.mozilla.org/en-US/docs/Web/API/Document
-- A `Document` is also a `Node`.
class (NodeTC m) <= DocumentTC m where

  -- Create the HTML element specified by `TagName`.
  -- ???
  -- Need to find a different return value than polymorphic `element`, I suspect.
  -- Feels like I want it to be polymorphic, to enable instantiating it to multiple
  --   concrete types. What types? Well, it's only useful for the methods on it,
  --   so maybe it shouldn't have a concrete type.
  createElement :: forall element. ElementTC m =>
      TagName -> Document -> m Element

  -- Returns the first Element within the document that matches the specified selector,
  --   or group of selectors.
  querySelector :: forall element. ElementTC m =>
      Selector -> Document -> m (Nullable Element)



-- Element is the most general base class from which all objects in a Document inherit.
--   It only has methods and properties common to all kinds of elements. More specific classes
--   inherit from Element. Most functionality is specified further down the class hierarchy.
-- https://developer.mozilla.org/en-US/docs/Web/API/Element
-- An `Element` is also a `Node`.
-- For now, will presume `m` contains a single `Document`.
class (NodeTC m) <= ElementTC m where

  -- Sets the value of an attribute on the specified element.
  --   If the attribute already exists, the value is updated;
  --   otherwise a new attribute is added with the specified name and value.
  -- The first argument is the attribute name, the second is the value,
  --   and they are added to the second element.
  setAttribute :: String -> String -> Element -> m Unit

  -- Returns the value of a specified attribute on the element.
  --   If the given attribute does not exist, the value returned will
  --   either be null or "" (the empty string).
  getAttribute :: String -> Element -> m (Nullable String)


-- Node is an interface from which a number of DOM API object types inherit.
--   It allows those types to be treated similarly; for example, inheriting the same set of methods,
--   or being tested in the same way.
-- https://developer.mozilla.org/en-US/docs/Web/API/Node
class NodeTC m where

  -- Appends the first argument to the child node list of the second.
  appendChild :: Node -> Node -> m Unit





------------------------------------------
---------- Instances for Effect ----------
------------------------------------------





foreign import documentImpl :: Effect Document
foreign import createElementImpl :: String -> Document -> Effect Element
foreign import querySelectorImpl :: String -> Document -> Effect (Nullable Element)
foreign import getAttributeImpl :: String -> Element -> Effect (Nullable String)
foreign import setAttributeImpl :: String -> String -> Element -> Effect Unit
foreign import appendChildImpl :: Node -> Node -> Effect Unit


instance windowEffect :: WindowTC Effect where

  document :: Effect Document
  document = documentImpl


-- !!! ERROR: Could not match type  Element  with type  element0

-- Why wouldn't `Effect Element` unify with
--   `ElementTC Effect element => Effect element`
--   when `Element` has an instance of `ElementTC`?
instance documentEffectDocument :: DocumentTC Effect where

  -- createElement :: forall m element. ElementTC m element =>
  --    TagName -> document -> m element

  -- Create the HTML element specified by `TagName`.
  -- createElement :: forall element. ElementTC Effect element =>
  --     TagName -> Document -> Effect element
  createElement :: TagName -> Document -> Effect Element
  createElement (TagName name) doc = createElementImpl name doc

  -- Returns the first Element within the document that matches the specified selector,
  --   or group of selectors.
  querySelector :: Selector -> Document -> Effect (Nullable Element)
  querySelector (Selector s) doc = querySelectorImpl s doc



-- Element is the most general base class from which all objects in a Document inherit.
--   It only has methods and properties common to all kinds of elements. More specific classes
--   inherit from Element. Most functionality is specified further down the class hierarchy.
-- https://developer.mozilla.org/en-US/docs/Web/API/Element
-- An `Element` is also a `Node`.
-- For now, will presume `m` contains a single `Document`.
instance elementEffect :: ElementTC Effect where

  setAttribute :: String -> String -> Element -> Effect Unit
  setAttribute name value elem = setAttributeImpl name value elem

  getAttribute :: String -> Element -> Effect (Nullable String)
  getAttribute attrName elem = getAttributeImpl attrName elem


-- Node is an interface from which a number of DOM API object types inherit.
--   It allows those types to be treated similarly; for example, inheriting the same set of methods,
--   or being tested in the same way.
-- https://developer.mozilla.org/en-US/docs/Web/API/Node
instance nodeEffectNode :: NodeTC Effect where

  -- Appends the first argument to the child node list of the second.
  appendChild :: Node -> Node -> Effect Unit
  appendChild n hostNode = appendChildImpl n hostNode

-- instance nodeEffectElement :: NodeTC Effect where
  
--   appendChild :: Element -> Element -> Effect Unit
--   appendChild e hostElement = (unsafeCoerce appendChildImpl) e hostElement

-- instance nodeEffectDocument :: NodeTC Effect where
--   appendChild :: Document -> Document -> Effect Unit
--   appendChild d hostDocument = pure unit
