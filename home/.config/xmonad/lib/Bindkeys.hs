module Bindkeys where

import XMonad
import qualified XMonad.StackSet as W
import Config

defaultKeys browser terminal = 
  [ ("M-w", screenWorkspace 0 >>= flip whenJust (windows . W.view))
  , ("M-e", screenWorkspace 1 >>= flip whenJust (windows . W.view))
  , ("M-S-w", screenWorkspace 0 >>= flip whenJust (windows . W.shift))
  , ("M-S-e", screenWorkspace 1 >>= flip whenJust (windows . W.shift))
  , ("M-s", spawn browser)
  , ("M-<Return>", spawn terminal)
  , ("M-<Space>", sendMessage NextLayout)
  , ("M-q", spawn "xmonad --recompile; xmonad --restart")
  ]
