import XMonad
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicLog
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Actions.SpawnOn (manageSpawn)
import XMonad.Util.Run (spawnPipe)
import System.IO (hPutStrLn)

import Config
import Utility
import Bindkeys
import Hooks

main = do
  xmproc <- spawnPipe "xmobar"
  xmonad $ docks $ ewmh $ def
    { modMask            = mod4Mask
    , terminal           = defaultTerminal
    , borderWidth        = 2
    , focusedBorderColor = colorActive
    , normalBorderColor  = colorNormal
    , workspaces         = defaultWorkspaces
    , layoutHook         = avoidStruts $ layoutHook def
    , manageHook         = manageSpawn <+> defaultManageHook
    , startupHook        = defaultStartupHook
    , logHook            = dynamicLogWithPP defaultPrettyPrinter { ppOutput = hPutStrLn xmproc }
    } `additionalKeysP` (defaultKeys defaultBrowser defaultTerminal)
