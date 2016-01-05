using Toybox.WatchUi as Ui;
using Toybox.System as Sys;

class MainMenuDelegate extends Ui.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item) {
        if (item == :mnuStartRace) {
            Ui.pushView(new RacingView(), new RacingViewDelegate(), Ui.SLIDE_UP); 
        } else if (item == :mnuSettings) {
             Ui.pushView(new Rez.Menus.SettingsMenu(), new SettingsMenuDelegate(), Ui.SLIDE_UP);
    	}
    }

}