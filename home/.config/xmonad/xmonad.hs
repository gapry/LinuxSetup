import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Util.EZConfig (additionalKeysP)

import Config
import Utility
import Bindkeys
import Hooks

prettyPrinter = statusBarProp "xmobar" (pure defaultPrettyPrinter)

main = xmonad . withEasySB prettyPrinter def . ewmh . docks $ def
  { modMask            = mod4Mask
  , terminal           = defaultTerminal
  , borderWidth        = 2
  , focusedBorderColor = "#268bd2"
  , normalBorderColor  = "#002b36"
  , workspaces         = defaultWorkspaces
  , manageHook         = defaultManageHook
  , startupHook        = defaultStartupHook
  } `additionalKeysP` (defaultKeys defaultBrowser defaultTerminal)
