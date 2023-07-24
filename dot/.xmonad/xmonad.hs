import XMonad hiding ((|||))

import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.DynamicBars

import XMonad.Util.Loggers
import XMonad.Util.Run

--import XMonad.Layout.TabBarDecoration as Tab
import XMonad.Layout.BinarySpacePartition as BSP
import XMonad.Layout.Tabbed as Tab
import XMonad.Layout.WindowNavigation as WN
import XMonad.Layout.Groups
import XMonad.Layout.Groups.Examples
import XMonad.Layout.NoFrillsDecoration as NF
import XMonad.Layout.DwmStyle
import XMonad.Layout.LayoutCombinators   -- use the one from LayoutCombinators instead

import XMonad.Layout.SimpleDecoration (shrinkText)
import XMonad.Layout.NoBorders


import XMonad.Util.EZConfig
import XMonad.Config.Desktop
import System.Exit

--import qualified DBus as D
--import qualified DBus.Client as D
import qualified XMonad.StackSet as W

import qualified Codec.Binary.UTF8.String as UTF8

myStartupHook = do
--    spawn "$HOME/.xmonad/run-polybar.sh"
    --spawn "$HOME/.xmonad/run-xmobar.sh"
    spawn "nm-applet &"
    --spawnPipe $ "xmobar -x " ++ show sid
    spawn "xrdb ~/.Xresources"
    spawn "$HOME/.xprofile"

tabConfig = def {
    activeBorderColor = "#7C7C7C",
    activeTextColor = "#CEFFAC",
    activeColor = "#000000",
    inactiveBorderColor = "#7C7C7C",
    inactiveTextColor = "#EEEEEE",
    inactiveColor = "#000000"
}

myTabConfig = def {
                   -- activeColor = "#556064"
                    activeColor = yellow
                  , inactiveColor = "#2F3D44"
                  , urgentColor = "#FDF6E3"
                  , activeBorderColor = "#454948"
                  , inactiveBorderColor = "#454948"
                  , urgentBorderColor = "#268BD2"
                  , activeTextColor = "#80FFF9"
                  , inactiveTextColor = "#1ABC9C"
                  , urgentTextColor = "#1ABC9C"
                  , fontName = "xft:Noto Sans CJK:size=10:antialias=true"
                  }

bLayout = WN.configurableNavigation WN.noNavigateBorders BSP.emptyBSP
tLayout = noBorders (Tab.tabbed shrinkText myTabConfig)
fLayout = noBorders Full
myLayout = avoidStruts (
                            bLayout
                        ||| tLayout
                        ||| fLayout
                       )

--myXmobar = statusbar "xmobar"

--xmonadPath :: String
--xmonadPath = "$HOME/.xmonad/"

--doubleBattery = logCmd $ xmonadPath ++ "get-battery.sh"

myXmobarPP :: PP
myXmobarPP = xmobarPP {
                 ppCurrent = xmobarColor "yellow" "" . wrap "[" "]"
               , ppTitle   = xmobarColor "green"  "" . shorten 40
               , ppVisible = wrap "(" ")"
               , ppUrgent  = xmobarColor "red" "yellow"
               }


myToggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_n)

main = do
    xmonad =<< (statusBar "xmobar ~/.xmonad/xmobar.hs" myXmobarPP myToggleStrutsKey myConfig)
    --xmonad =<< return myConfig

myWorkspaces = ["1","2","3","4","5","6","7","8","9"]
myConfig = (ewmh $ docks $  desktopConfig
        {
            terminal = "urxvt"
            -- Mod key as windows key 
          , modMask = mod4Mask
            -- Mod key as default alt
          --, modMask = mod1Mask
          -- Solarized border
          --, normalBorderColor = "#073642"
          -- seoul256 border
          , normalBorderColor = "#545454"
          --, workspaces = myWorkspaces
          --, focusedBorderColor = "#b58900"
          , focusedBorderColor = yellow
          , borderWidth = 5
          , layoutHook = myLayout
          , logHook = dynamicLog
          , startupHook = myStartupHook
          , handleEventHook = mconcat [docksEventHook, handleEventHook def]
        }
    -- Keybinds
        `removeKeysP`
        removeDefaultKeys
        `additionalKeysP`
        hotkeys)


-- Default Keys to remove
removeDefaultKeys =
        [
           "M-p"
          ,"M-q"
        ]

-- Rebind keys
hotkeys =
        [
        -- Spawn terminal
            ("M-<Return>", spawn "urxvt")
        -- Browser
          , ("M-b", spawn "google-chrome-stable")
        -- rofi
          --, ("M-d", spawn "rofi -show run")
          --, ("M-w", spawn "rofi -show window")
        -- dmenu
          , ("M-d", spawn "dmenu_run")
        -- Window movement
          , ("M-l" , sendMessage $ WN.Go R)
          , ("M-h" , sendMessage $ WN.Go L)
          , ("M-k" , sendMessage $ WN.Go U)
          , ("M-j" , sendMessage $ WN.Go D)
          , ("M-S-l" , sendMessage $ WN.Swap R)
          , ("M-S-h" , sendMessage $ WN.Swap L)
          , ("M-S-k" , sendMessage $ WN.Swap U)
          , ("M-S-j" , sendMessage $ WN.Swap D)
          , ("M-c", sendMessage ToggleStruts)
          , ("M-S-q", kill) -- %! Close the focused window
        -- restart or quit
          , ("M-S-r", spawn "if type xmonad;\
                            \then xmonad --recompile && xmonad --restart;\
                            \else xmessage xmonad not in \\$PATH: \"$PATH\"; fi") -- %! Restart xmonad
          , ("M-S-e" , io (exitWith ExitSuccess)) -- %! Quit xmonad
          --, ("M-w" , sendMessage $ JumpToLayout "Tabbed") -- tablayout
          , ("M-r" , sendMessage $ JumpToLayout "bLayout") -- binary layout
          , ("M-f" , sendMessage $ JumpToLayout "Full") -- fullscreen layout
          , ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@ +1.5%")
          , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume @DEFAULT_SINK@  -1.5%")
          , ("<XF86AudioMute>", spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle")    
          , ("<XF86MonBrightnessUp>", spawn "light -A 10")    
          , ("<XF86MonBrightnessDown>", spawn "light -U 10")
          --, ("M-v", spawn "/home/joseph/Documents/src/vim-anywhere/bin/run")
          , ("M-v", spawn "chromium-browser")
        ]
        ++ -- (++) is needed here because the following list comprehension
         -- is a list, not a single key binding. Simply adding it to the
         -- list of key bindings would result in something like [ b1, b2,
         -- [ b3, b4, b5 ] ] resulting in a type error. (Lists must
         -- contain items all of the same type.)


          [ (otherModMasks ++ "M-" ++ [key], action tag)
            | (tag, key)  <- zip myWorkspaces "123456789"
            , (otherModMasks, action) <- [ ("", windows . W.view) -- was W.greedyView
                                            , ("S-", windows . W.shift)]
          ]


-- Colours
fg        = "#ebdbb2"
bg        = "#282828"
gray      = "#a89984"
bg1       = "#3c3836"
bg2       = "#505050"
bg3       = "#665c54"
bg4       = "#7c6f64"

green     = "#b8bb26"
darkgreen = "#98971a"
red       = "#fb4934"
darkred   = "#cc241d"
yellow    = "#b58900"
blue      = "#83a598"
purple    = "#d3869b"
aqua      = "#8ec07c"
white     = "#eeeeee"

pur2      = "#5b51c9"
blue2     = "#2266d0"


