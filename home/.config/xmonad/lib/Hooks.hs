module Hooks where

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Actions.SpawnOn (spawnOn, manageSpawn)

import Config
import Utility

defaultStartupHook = do
  spawnOnce "xmobar"
  spawnOn workspace1 defaultTerminal
  spawnOn workspace2 defaultBrowser

defaultManageHook = composeAll
  [ manageSpawn 
  , manageDocks
  , isBrowser             --> doShift workspace1
  , className =? "Fcitx5" --> doIgnore
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
