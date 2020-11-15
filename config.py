# This is configuration file for keyhac
# http://crftwr.github.io/keyhac/doc/ja/

from keyhac import *
 
def configure(keymap):
    def turn_on_ime():
        keymap.wnd.setImeStatus(1)

    def turn_off_ime():
        keymap.wnd.setImeStatus(0)

    keymap_global = keymap.defineWindowKeymap()

    # sands
    keymap.replaceKey("Space", "RShift")
    keymap_global["O-RShift"] = "Space"

    # IME
    keymap_global["O-LCtrl"] = turn_on_ime
    keymap_global["O-RCtrl"] = turn_off_ime

    # swap colon and semicolon
    keymap_global["Shift-Semicolon"] = "Colon"
    keymap_global["Semicolon"] = "Shift-Semicolon"

    keymap_global["LCtrl-A"] = "Home"
    keymap_global["LCtrl-E"] = "End"
    keymap_global["LCtrl-D"] = "Delete"
    keymap_global["LCtrl-F"] = "Right"
    keymap_global["LCtrl-B"] = "Left"
    keymap_global["LCtrl-P"] = "Up"
    keymap_global["LCtrl-N"] = "Down"
