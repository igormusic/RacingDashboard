using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Application as App;
using Toybox.System as Sys;
using Dashboard as ds;

class RacingDashboardView extends Ui.View {

    function initialize() {
        View.initialize();
    }

    //! Load your resources here
    function onLayout(dc) {
        //setLayout(Rez.Layouts.MainLayout(dc));
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    	//showConfig();
    	//Ui.pushView(new Rez.Menus.MainMenu(), new MainMenuDelegate(), Ui.SLIDE_UP);
    }
    
    function showConfig(dc)
    {
    
    	clearScreen(dc);
    	var font = Gfx.FONT_SMALL;
    	var app = App.getApp();

        dc.setColor(Gfx.COLOR_WHITE,Gfx.COLOR_BLACK); 
          
        dc.drawText(25, 40  ,font,"Distance:" ,Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(85, 40  ,font, ds.getDistance().format("%04.2f") ,Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.drawText(25, 60,font,"Time:" ,Gfx.TEXT_JUSTIFY_LEFT);
        dc.drawText(85, 60,font,ds.getFormatedTime() ,Gfx.TEXT_JUSTIFY_LEFT);
        
      	dc.drawText(25, 80,font,"Min HR:"  ,Gfx.TEXT_JUSTIFY_LEFT);
		dc.drawText(85, 80,font,ds.getMinHR().format("%d") ,Gfx.TEXT_JUSTIFY_LEFT);
      	
		dc.drawText(25, 100 ,font,"Max HR:"  ,Gfx.TEXT_JUSTIFY_LEFT);
    	dc.drawText(85, 100 ,font, ds.getMaxHR().format("%d") ,Gfx.TEXT_JUSTIFY_LEFT);
    }
    
    function clearScreen(dc)
	{
	   	// Clear the screen
        dc.setColor(Gfx.COLOR_BLACK, infoColor);
        dc.fillRectangle(0,0,dc.getWidth(), dc.getHeight());
	}

    //! Update the view
    function onUpdate(dc) {
    	
    	
        // Call the parent onUpdate function to redraw the layout
        showConfig(dc);
    }
    
   

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

}
