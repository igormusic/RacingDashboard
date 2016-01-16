using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Dashboard as ds;

class TimePicker extends Ui.Picker {

    function initialize() {
        
        var title = new Ui.Text({:text=>"Target time", :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color=>Gfx.COLOR_WHITE});
        var separator = new Ui.Text({:text=>":", :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_CENTER, :color=>Gfx.COLOR_WHITE});
        Picker.initialize({:title=>title, :pattern=>[new NumberFactory(0,10,1), separator,new NumberFactory(0,59,1), separator, new NumberFactory(0,59,1,{:font=>Gfx.FONT_NUMBER_MEDIUM})]});
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class TimePickerDelegate extends Ui.PickerDelegate {
    function onCancel() {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
        var timeInSeconds = values[0]*3600 + values[2] *60 +values[4];
        
        ds.setTime(timeInSeconds);
       
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
