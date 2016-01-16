using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.WatchUi as Ui;

class DatePicker extends Ui.Picker {

    function initialize() {
        var months = ["Jan", "Feb", "Mar",
                      "Apr", "May", "Jun",
                      "Jul", "Aug", "Sep",
                      "Oct", "Nov", "Dec"];
        var title = new Ui.Text({:text=>"_date_title_", :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color=>Gfx.COLOR_WHITE});
        var separator = new Ui.Text({:text=>"_ds_", :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_CENTER, :color=>Gfx.COLOR_WHITE});
        Picker.initialize({:title=>title, :pattern=>[new WordFactory(months), separator, new NumberFactory(1,31,1), separator, new NumberFactory(15,18,1,{:font=>Gfx.FONT_NUMBER_MEDIUM})]});
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class DatePickerDelegate extends Ui.PickerDelegate {
    function onCancel() {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {
        var separator = ":";
        var date = values[0] + separator + values[2] + separator + values[4];
        App.getApp().setProperty("date", date);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
