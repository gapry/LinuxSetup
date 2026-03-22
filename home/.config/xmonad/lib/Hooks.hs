module Hooks where

import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Actions.SpawnOn (spawnOn, manageSpawn)

import Config
import Utility

defaultStartupHook = do
  spawnOnce "trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 0 --transparent true --alpha 0 --tint 0x002b36 --height 22"
  spawnOnce "nm-applet"
  spawnOnce "volumeicon"
  spawnOn workspace1 defaultTerminal
  spawnOn workspace2 defaultBrowser

defaultManageHook = composeAll
  [ manageSpawn
  , manageDocks
  , checkDock             --> doIgnore
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
