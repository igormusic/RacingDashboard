using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class SettingsMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :mnuDistance) {
            Sys.println("Distance");
            Ui.pushView(new DistancePicker(), new DistancePickerDelegate(), Ui.SLIDE_IMMEDIATE);
        } else if (item == :mnuTime) {
            Sys.println("Time");
            Ui.pushView(new TimePicker(), new TimePickerDelegate(), Ui.SLIDE_IMMEDIATE);
        }else if (item == :mnuHR) {
            Sys.println("HR");
            Ui.pushView(new HRPicker(), new HRPickerDelegate(), Ui.SLIDE_IMMEDIATE);
        }
    }

}