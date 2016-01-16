using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;
using Dashboard as ds;

class HRPicker extends Ui.Picker {

    function initialize() {
        
        var title = new Ui.Text({:text=>"Min and Max HR", :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color=>Gfx.COLOR_WHITE});
        var minHR = new Ui.Text({:text=>"min HR", :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_CENTER, :color=>Gfx.COLOR_WHITE});
        var maxHR = new Ui.Text({:text=>"max HR", :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_CENTER, :color=>Gfx.COLOR_WHITE});
        Picker.initialize({:title=>title, :pattern=>[minHR, new NumberFactory(100,220,1,{:font=>Gfx.FONT_SMALL}), maxHR,new NumberFactory(100,220,1,{:font=>Gfx.FONT_SMALL})]});
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class HRPickerDelegate extends Ui.PickerDelegate {
    function onCancel() {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
        ds.setMinHR(values[1]);
        ds.setMaxHR(values[3]);
        
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
