module DOM.Tagless.Class where
  
import Prelude

import Data.Nullable (Nullable)
import Effect (Effect)


class WindowTC win where

  -- Returns a reference to the document contained in the window.
  document :: forall document. DocumentTC win document => win document


-- A String containing one or more selectors to match.
-- This string must be a valid CSS selector string.
newtype Selector = Selector String
newtype TagName = TagName String

-- The Document interface represents any web page loaded in the browser and serves as an entry
--   point into the web page's content, which is the DOM tree.
-- https://developer.mozilla.org/en-US/docs/Web/API/Document
-- A `Document` is also a `Node`.
class (NodeTC m document) <= DocumentTC m document where

  -- Create the HTML element specified by `TagName`.
  createElement :: forall element. ElementTC m element =>
      TagName -> document -> m element

  -- Returns the first Element within the document that matches the specified selector,
  --   or group of selectors.
  querySelector :: forall element. ElementTC m element =>
      Selector -> document -> m (Nullable element)



-- Element is the most general base class from which all objects in a Document inherit.
--   It only has methods and properties common to all kinds of elements. More specific classes
--   inherit from Element. Most functionality is specified further down the class hierarchy.
-- https://developer.mozilla.org/en-US/docs/Web/API/Element
-- An `Element` is also a `Node`.
-- For now, will presume `m` contains a single `Document`.
class (NodeTC m element) <= ElementTC m element where

  -- Sets the value of an attribute on the specified element.
  --   If the attribute already exists, the value is updated;
  --   otherwise a new attribute is added with the specified name and value.
  -- The first argument is the attribute name, the second is the value,
  --   and they are added to the second element.
  setAttribute :: String -> String -> element -> m Unit

  -- Returns the value of a specified attribute on the element.
  --   If the given attribute does not exist, the value returned will
  --   either be null or "" (the empty string).
  getAttribute :: String -> element -> m (Nullable String)


-- Node is an interface from which a number of DOM API object types inherit.
--   It allows those types to be treated similarly; for example, inheriting the same set of methods,
--   or being tested in the same way.
-- https://developer.mozilla.org/en-US/docs/Web/API/Node
class NodeTC m node where

  -- Appends the first argument to the child node list of the second.
  appendChild :: node -> node -> m Unit





------------------------------------------
---------- Instances for Effect ----------
------------------------------------------




foreign import data Document :: Type
foreign import data Element :: Type
foreign import data Node :: Type

foreign import documentImpl :: Effect Document
foreign import createElementImpl :: String -> Document -> Effect Element
foreign import querySelectorImpl :: String -> Effect (Nullable Element)
foreign import getAttributeImpl :: String -> Element -> Effect String
foreign import setAttributeImpl :: String -> String -> Element -> Effect Unit
foreign import appendChildImpl :: Node -> Node -> Effect Unit


-- ERROR:
-- Could not match type    Document  with type    document0
instance windowEffect :: WindowTC Effect where

  -- document :: forall document. DocumentTC win document => win document
  
  document :: DocumentTC Effect Document => Effect Document

  -- document :: forall document. DocumentTC Effect document => Effect document
  -- document :: Effect Document
  document = documentImpl


instance documentEffect :: DocumentTC Effect Document where

  -- Create the HTML element specified by `TagName`.
  createElement :: forall element. ElementTC element =>
      TagName -> Document -> Effect element
  createElement (TagName name) doc = createElementImpl name doc

  -- Returns the first Element within the document that matches the specified selector,
  --   or group of selectors.
  querySelector :: forall element. ElementTC element =>
      Selector -> Document -> Effect (Nullable element)
  querySelector (Selector s) doc = querySelectorImpl s doc



-- Element is the most general base class from which all objects in a Document inherit.
--   It only has methods and properties common to all kinds of elements. More specific classes
--   inherit from Element. Most functionality is specified further down the class hierarchy.
-- https://developer.mozilla.org/en-US/docs/Web/API/Element
-- An `Element` is also a `Node`.
-- For now, will presume `m` contains a single `Document`.
instance elementEffect :: ElementTC Effect Element where

  setAttribute :: String -> String -> Element -> Effect Unit
  setAttribute name value elem = setAttributeImpl name value elem

  getAttribute :: String -> Element -> Effect String
  getAttribute attrName elem = getAttributeImpl attrName elem


-- Node is an interface from which a number of DOM API object types inherit.
--   It allows those types to be treated similarly; for example, inheriting the same set of methods,
--   or being tested in the same way.
-- https://developer.mozilla.org/en-US/docs/Web/API/Node
instance nodeEffect :: NodeTC Effect Node where

  -- Appends the first argument to the child node list of the second.
  appendChild :: Node -> Node -> Effect Unit
  appendChild n1 n2 = appendChildImpl n1 n2

