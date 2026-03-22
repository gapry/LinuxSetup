import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Actions.SpawnOn (manageSpawn)

import Config
import Utility
import Bindkeys
import Hooks

main = xmonad 
     . docks 
     . withEasySB xmobarStatusBar def 
     . ewmh 
     $ def
  { modMask            = mod4Mask
  , terminal           = defaultTerminal
  , borderWidth        = 2
  , focusedBorderColor = colorActive
  , normalBorderColor  = colorNormal
  , workspaces         = defaultWorkspaces
  , manageHook         = manageSpawn <> defaultManageHook
  , startupHook        = startupHook def <+> defaultStartupHook
  } `additionalKeysP` (defaultKeys defaultBrowser defaultTerminal)
