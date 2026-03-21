import XMonad
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (spawnPipe)
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks

main :: IO ()
main = xmonad $ docks def
    { terminal           = "alacritty"
    , modMask            = mod4Mask
    , borderWidth        = 2
    , normalBorderColor  = "#333333"
    , focusedBorderColor = "#00bbff"
    } `additionalKeys`
    [ ((mod4Mask, xK_p), spawn "dmenu_run") ]
