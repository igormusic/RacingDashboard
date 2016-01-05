using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class SettingsMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :mnuDistance) {
            Sys.println("Distance");
        } else if (item == :mnuTime) {
            Sys.println("Time");
        }else if (item == :mnuHR) {
            Sys.println("HR");
        }
    }

}