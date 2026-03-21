module Utility where

import XMonad
import Data.List (isInfixOf)
import Data.Char (toLower)
import Config

isBrowser = ask >>= \w -> liftX $ do
  cls <- fmap (map toLower) (runQuery className w)
  res <- fmap (map toLower) (runQuery resource w)
  return $ any (\sig -> sig `isInfixOf` cls || sig `isInfixOf` res) browsers
