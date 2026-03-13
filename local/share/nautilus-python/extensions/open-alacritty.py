import os

from gi.repository import Nautilus, GObject

class AlacrittyExtension(GObject.GObject, Nautilus.MenuProvider):
  def __init__(self):
    pass

  def menu_activate_cb(self, menu, slot):
    location = slot.get_location().get_path()
    os.system(f"alacritty --working-directory '{location}' &")

  def get_background_items(self, *args):
    item = Nautilus.MenuItem(name  = "open Alacritty",
                             label = "open in Alacritty",
                             tip   = "open Alacritty in this directory")
    item.connect('activate', self.menu_activate_cb, args[-1])
    return [item]
