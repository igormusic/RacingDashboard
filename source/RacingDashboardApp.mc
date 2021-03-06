using Toybox.Application as App;
using Toybox.WatchUi as Ui;
using Toybox.Position as Position;
using Dashboard as ds;

class RacingDashboardApp extends App.AppBase {

    function initialize() {
        AppBase.initialize();
        
        setDefaults();
    }
    
    function setDefaults()
    {      
        ds.setDistance(10);
        ds.setMaxHR(160);
        ds.setMinHR(150);
		ds.setTime(40*60);
    	
    }

    //! onStart() is called on application start up
    function onStart() {
    
    	Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
    
    }

    //! onStop() is called when your application is exiting
    function onStop() {
       
        Position.enableLocationEvents(Position.LOCATION_DISABLE, method(:onPosition));
    }

    function onPosition(info) {
    }
    //! Return the initial view of your application here
    function getInitialView() {
        return [ new RacingDashboardView(), new RacingDashboardDelegate() ];
		//return [new RacingView(), new RacingViewDelegate()];
		//return [new Rez.Menus.MainMenu(), new MainMenuDelegate()];

    }

}
