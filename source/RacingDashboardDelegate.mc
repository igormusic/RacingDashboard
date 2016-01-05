using Toybox.WatchUi as Ui;

class RacingDashboardDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new MainMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }
    
    function onSelect()
    {
    	Ui.pushView(new Rez.Menus.MainMenu(), new MainMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

}