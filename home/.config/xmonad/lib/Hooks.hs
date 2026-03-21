module Hooks where

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Util.SpawnOnce (spawnOnce)
import Config
import Utility

defaultStartupHook = do
  spawnOnce defaultTerminal

defaultManageHook = composeAll
  [ isBrowser             --> doShift workspace1
  , className =? "Fcitx5" --> doIgnore
  , manageDocks
  , manageHook def
  ]

defaultPrettyPrinter = def
  { ppCurrent         = xmobarColor colorActive "" . wrap "[" "]"
  , ppVisible         = xmobarColor colorActive ""
  , ppHidden          = xmobarColor colorHidden ""
  , ppHiddenNoWindows = xmobarColor colorInactive ""
  , ppUrgent          = xmobarColor colorUrgent "" . wrap "!" "!"
  , ppSep             = " | "
  , ppTitle           = xmobarColor colorActive "" . shorten 60
  }
