using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Dashboard as ds;
using Toybox.System as Sys;

class DistancePicker extends Ui.Picker {

    function initialize() {
        
        var title = new Ui.Text({:text=>"Race distance (km)", :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color=>Gfx.COLOR_WHITE});
        var separator = new Ui.Text({:text=>".", :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_CENTER, :color=>Gfx.COLOR_WHITE});
        Picker.initialize({:title=>title, :pattern=>[new NumberFactory(0,100,1), separator, new NumberFactory(0,9,1,{:font=>Gfx.FONT_NUMBER_MEDIUM})]});
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class DistancePickerDelegate extends Ui.PickerDelegate {
    function onCancel() {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
        var separator = ":";
        var distance = 0;
        
        Sys.println("DistancePickerDelegate onAccept");
        
        //for(var i=0;i<3;i++)
        //{
        //	if(values[i] == null)
        //	{
        //		Sys.println("values[" + i.format("%d") + "]= null");	
        //	}
        //	else
        //	{
        //		Sys.println("values[" + i.format("%d") + "]= " + values[i]);
        //	}
        //}
        
        if ((values[0] != null) && (values[2]!= null))
        {
        	 distance = values[0] + values[2]/10.0;
        }
        
        ds.setDistance(distance);
       
        App.getApp().setProperty("distance", distance);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
