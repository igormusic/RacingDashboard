
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.Lang as Lang;
using Toybox.Math as Math;
using Toybox.Time as Time;
using Toybox.Time.Gregorian as Calendar;
using Toybox.Timer as Timer;
using Toybox.WatchUi as Ui;
using Toybox.Application as App;
using Toybox.Activity as Act;
using Toybox.ActivityRecording as Record;
using Dashboard as ds;

var session;
var lowColor = Gfx.COLOR_BLUE;
var okColor = Gfx.COLOR_GREEN;
var hiColor = Gfx.COLOR_YELLOW;
var infoColor =  Gfx.COLOR_WHITE;

class RacingView extends Ui.View 
{

	 var timer;
    //! Constructor
    function initialize()
    {
    	View.initialize();
    	
    	// Set up a 1Hz update timer because we aren't registering
        // for any data callbacks that can kick our display update.
        timer = new Timer.Timer();
        timer.start( method(:onTimer), 500, true );
    	
    	startRecording();
    }
    
    function startRecording()
    {
    	 if( Toybox has :ActivityRecording ) {
            if( ( session == null ) || ( session.isRecording() == false ) ) {
                session = Record.createSession({:name=>"Race", :sport=>Record.SPORT_RUNNING});
                session.start();
                Ui.requestUpdate();
            }
        }
    }
    
    function stopRecording()
    {
     if( Toybox has :ActivityRecording ) {
            if( ( session != null ) && session.isRecording() ) {
                session.stop();
                session.save();
                session = null;
                Ui.requestUpdate();
            }
        }
    }

    //! Load resources
    function onLayout()
    {
  
    }

    function onShow()
    {
    }

    //! Nothing to do when going away
    function onHide()
    {
    }

 	function onTimer()
    {
        //Kick the display update
        Ui.requestUpdate();
    }

    
    //! Handle the update event
    function onUpdate(dc)
    {
       	clearScreen(dc);
       	
      	var activity = Act.getActivityInfo();
    	
    	var currentHeartRate = 0;
    	var averageSpeed = 0;
    	var elapsedDistance = 0;
    	var elapsedTime = 0;
    	var currentCadence = 0;

		if(activity != null)
		{
			if(activity.currentHeartRate !=null)
			{
				currentHeartRate = activity.currentHeartRate;
			}
			
			if(activity.averageSpeed !=null)
			{
				averageSpeed = activity.averageSpeed;
			}
			
			if(activity.elapsedDistance !=null)
			{
				elapsedDistance = activity.elapsedDistance;
			}
	
			if(activity.currentCadence !=null)
			{
				currentCadence = activity.currentCadence;
			}
			
			if(activity.elapsedTime !=null)
			{
				elapsedTime = activity.elapsedTime;
			}
		}
		
		//assume +- 0.75% tolerance for HR gauge, and 0.25% tolerance for green section 
        var totalTolerance = ds.getTime() * 0.75 / 100;
        var greenTolerance = ds.getTime() * 0.25 / 100;
        var minSpeed = ds.getMinExpectedSpeed(totalTolerance);
        var maxSpeed = ds.getMaxExpectedSpeed(totalTolerance);
        var minGreen = ds.getMinExpectedSpeed(greenTolerance);
        var maxGreen = ds.getMaxExpectedSpeed(greenTolerance); 
        var secondsAhead = ds.getSecondsAhead(elapsedDistance, elapsedTime);
        var timeAhead = getFormatedTime(secondsAhead);
		
		Sys.println("currentHeartRate=" + currentHeartRate.format("%d"));
		Sys.println("averageSpeed=" + averageSpeed.format("%d"));
		Sys.println("elapsedDistance=" + elapsedDistance.format("%d"));
		Sys.println("currentCadence=" + currentCadence.format("%d"));
		Sys.println("elapsedTime=" + elapsedTime.format("%d"));
       	Sys.println("totalTolerance=" + totalTolerance.format("%f"));
       	Sys.println("greenTolerance=" + greenTolerance.format("%f"));
       	Sys.println("minSpeed=" + minSpeed.format("%f"));
       	Sys.println("maxSpeed=" + maxSpeed.format("%f"));
       	Sys.println("minGreen=" + minGreen.format("%f"));
       	Sys.println("maxGreen=" + maxGreen.format("%f"));
       	Sys.println("secondsAhead=" + secondsAhead.format("%f"));
       	
        drawHRGauge(dc, currentHeartRate, ds.getMinHR(), ds.getMaxHR(), 140.0, 180.0);
            
        //drawPaceGauge(dc, averageSpeed,  getSpeedFromPace(4.0, 18.0),getSpeedFromPace(4.0, 6.0),getSpeedFromPace(4.0, 14.0),getSpeedFromPace(4.0, 10.0)); 
    	drawPaceGauge(dc, averageSpeed,  minSpeed,minGreen,maxSpeed,maxGreen);
    	drawDistanceGauge(dc, elapsedDistance, ds.getDistance());
    	
    	//activity.elapsedTime - in ms
    	drawTime(dc,getFormatedTime(elapsedTime),timeAhead);
    	drawCadence(dc, currentCadence);
    }
    
    function getFormatedTime(elapsedTimeInMs)
    {
    	var elapsedTimeInSeconds = elapsedTimeInMs / 1000;
    	var seconds = elapsedTimeInSeconds % 60;
    	var elapsedTimeInMinutes = (elapsedTimeInSeconds - seconds)/60;
    	var minutes = elapsedTimeInMinutes % 60;
    	var hours = 0 ;
    	
    	if(elapsedTimeInMinutes > 60)
    	{
    		hours = (elapsedTimeInSeconds - seconds * 60 - minutes * 3600) / 3600;
    	}
    	
    	var result = hours.format("%1d") + ":" + minutes.format("%02d") + ":" + seconds.format("%02d");
    	
    	Sys.println("getFormatedTime(" + elapsedTimeInMs.format("%d") + ")=" + result);
    
    	return result;	
    }
    
    function getActivityInfo()
    {
    	var activity = Act.getActivityInfo();
    	
    	var result = { :currentHeartRate => 0 ,:averageSpeed => 0, :elapsedDistance => 0, :elapsedTime => 0, :currentCadence => 0};

		if(activity == null)
		{
			Sys.println("Act.getActivityInfo() returned null");
			return result;
		}
			
		if(activity.currentHeartRate !=null)
		{
			result.currentHeartRate = activity.currentHeartRate;
		}
		
		if(activity.averageSpeed !=null)
		{
			result.averageSpeed = activity.averageSpeed;
		}
		
		if(activity.elapsedDistance !=null)
		{
			result.elapsedDistance = activity.elapsedDistance;
		}

		if(activity.currentCadence !=null)
		{
			result.currentCadence = activity.currentCadence;
		}
		
		if(activity.elapsedTime !=null)
		{
			result.elapsedTime = activity.elapsedTime;
		}
				
		return result;	    	
    }

	function clearScreen(dc)
	{
	   	// Clear the screen
        dc.setColor(Gfx.COLOR_BLACK, infoColor);
        dc.fillRectangle(0,0,dc.getWidth(), dc.getHeight());
	}
	
	function boundValue(value, min, max)
	{
		var result = value;
    	
    	if(value < min)
    	{
    		result = min;
    	} else if (value > max)
    	{
    		result = max;
    	}
    	
    	return result;
	}
	
	function drawCadence(dc, currentCadence)
	{
		var cY = dc.getHeight() / 2.0;
		var text = currentCadence.format("%d");
		var font = Gfx.FONT_LARGE;
		var numberHeight = dc.getFontHeight(font)/2;
		var numberWidth = dc.getTextWidthInPixels(text, font);
        
        dc.setColor(infoColor,Gfx.COLOR_TRANSPARENT);   
        dc.drawText(dc.getWidth() - numberWidth, cY - numberHeight  ,font,text,Gfx.TEXT_JUSTIFY_LEFT);
	}
	
	function drawTime(dc, currentTime, diff)
	{
		var cY = dc.getHeight() / 2.0;
		var font = Gfx.FONT_MEDIUM;
		var numberHeight = dc.getFontHeight(font)/2;
        
        dc.setColor(infoColor,Gfx.COLOR_TRANSPARENT);   
        dc.drawText(0, cY - 2.0 * numberHeight  ,font,currentTime,Gfx.TEXT_JUSTIFY_LEFT);
        
        dc.setColor(hiColor,Gfx.COLOR_TRANSPARENT); 
        dc.drawText(0, cY - 0.2 * numberHeight ,Gfx.FONT_LARGE,diff,Gfx.TEXT_JUSTIFY_LEFT);	
	}
	
	function drawDistanceGauge(dc, currentDistance, maxDistance)
	{
		var r = dc.getWidth() / 2.5 ;
		var cY = dc.getHeight() / 2.0;
		var cX = dc.getWidth() / 2.0;
		var font = Gfx.FONT_LARGE;
		
		//distance in km
		currentDistance = currentDistance / 1000.0;
		var numberOfBlocks = 20;
		var blocksComplete = (currentDistance / maxDistance) * numberOfBlocks;
		
		if (blocksComplete >  numberOfBlocks)
		{
			blocksComplete = numberOfBlocks;
		}

        dc.setPenWidth(7);
        
        for( var i = 0; i < numberOfBlocks; i++ ) {
 			if (i<= blocksComplete)
 			{
 				dc.setColor(infoColor,Gfx.COLOR_TRANSPARENT);
 			}
 			else
 			{
 				dc.setColor(Gfx.COLOR_DK_GRAY,Gfx.COLOR_TRANSPARENT);
 			}
 			
 			dc.drawArc(cX, cY , r ,  Gfx.ARC_CLOCKWISE,200+(i+1)*7-2, 200+i*7);
		}
		
		dc.setColor(infoColor,Gfx.COLOR_TRANSPARENT);
		var numberHeight = dc.getFontHeight(font)/2;
        dc.drawText(cX, cY  + r - numberHeight * 3 ,font,currentDistance.format("%.2f") + " k",Gfx.TEXT_JUSTIFY_CENTER);        
	}

    function drawPaceGauge(dc, currentSpeed, minSpeed, maxSpeed, greenLow, greenMax)
    {
    	var r = dc.getWidth() / 2.5 ;
		var cY = dc.getHeight() / 2.0;
		var cX = dc.getWidth() / 2.0;

        dc.setPenWidth(7);
        
        dc.setColor(lowColor,Gfx.COLOR_TRANSPARENT);        
        dc.drawArc(cX, cY , r ,  Gfx.ARC_CLOCKWISE,  160, 120);
        
        dc.setColor(okColor,Gfx.COLOR_TRANSPARENT);    
		dc.drawArc(cX, cY , r ,  Gfx.ARC_CLOCKWISE, 120,60);
        
        dc.setColor(hiColor,Gfx.COLOR_TRANSPARENT);        
        dc.drawArc(cX, cY , r ,  Gfx.ARC_CLOCKWISE, 60, 20);
        
        if(currentSpeed<  greenLow){
      		dc.setColor(lowColor, Gfx.COLOR_TRANSPARENT);
      	}
      	
      	if(currentSpeed > greenMax){
      		dc.setColor(hiColor, Gfx.COLOR_TRANSPARENT);
      	}
      	  	        
      	if(currentSpeed >= greenLow and currentSpeed <=greenMax){
        	dc.setColor(okColor, Gfx.COLOR_TRANSPARENT);
        }
        
        var numberHeight = dc.getFontHeight(Gfx.FONT_LARGE)/2;
        dc.drawText(cX, cY  - r + numberHeight / 2 ,Gfx.FONT_LARGE,speedToPace(currentSpeed),Gfx.TEXT_JUSTIFY_CENTER);
        
       
        drawPaceTriangle(dc, currentSpeed, cX, cY, r, minSpeed,maxSpeed);
    }
    
    function speedToPace(metersPerSecond) {
    	
    	if(metersPerSecond == 0)
    	{
    		return "0:00";
    	}
    
   		var secondsPerKM = 1000.0 / metersPerSecond;
   	 	
   	 	var minutesPerKM = secondsPerKM / 60;
   	 	var minutes = minutesPerKM.toLong();
   	 	
   	 	var seconds = secondsPerKM - minutes * 60;
   	 	
   	 	var result = minutes.format("%d") + ":" + seconds.format("%02d");
   	 	
   	 	Sys.println("speedToPace(" + metersPerSecond.format("%f") +")=" + result);
    
    	return result;
    }
   function drawPaceTriangle(dc, currentSpeed, cX, cY, r, min,max)
    {
    	var speed = boundValue(currentSpeed, min, max);
    	
    	//Sys.println("Current Speed: " + currentSpeed.format("%f") + ", Min: " + min.format("%f") +", Max: " + max.format("%f")+", speed :" + speed.format("%f"));
    	
        var angle = (speed - min)/(max-min) * (140.0/180.0) *2 * Math.PI + 2*  Math.PI * (20.0 / 180.0);
        
        //scale full circle angle to arc
        angle = angle/2.0  +  Math.PI ;
        
        var x1 = Math.cos(angle)* r * 1.05 + cX;
        var y1 = Math.sin(angle) * r * 1.05 + cY;
        
        var x2 = Math.cos(angle-0.1) *r*0.95 + cX;
        var y2 = Math.sin(angle-0.1) *r*0.95 + cY;
        
        var x3 = Math.cos(angle+0.1) *r*0.95 + cX;
        var y3 = Math.sin(angle+0.1) *r*0.95 + cY;
        
        dc.setPenWidth(5);
        
        dc.setColor(infoColor,infoColor); 
        dc.fillPolygon([ [x1, y1], [x2, y2], [x3, y3]]);
    }
    
    function getSpeedFromPace(minutesPerKm, secondsPerKm)
    {
    	var result;
    	result = 1000.0 / (minutesPerKm * 60.0 + secondsPerKm);
    	
    	Sys.println("getSpeedFromPace(" + minutesPerKm.format("%d") + ":" + secondsPerKm.format("%d") +")=" + result.format("%f"));
    	
    	return result;
    }
    
    function drawHRGauge(dc, currentHR , greenLow, greenHi, min, max)
    {
    	var width, height;

        width = dc.getWidth();
        height = dc.getHeight();

		var numberHeight = dc.getFontHeight(Gfx.FONT_TINY)/2;
		var r = width /7.5 ;
		var cY = height/2.0 ;
		var cX = (width /2.0) ;
		var font = Gfx.FONT_LARGE;

        dc.setPenWidth(10);
        
        dc.setColor(lowColor,Gfx.COLOR_TRANSPARENT);        
        dc.drawArc(cX, cY , r ,  Gfx.ARC_CLOCKWISE,   valueToAngle(0.0,min,max), valueToAngle(greenLow,min,max));
        
        dc.setColor(okColor,Gfx.COLOR_TRANSPARENT);    
		dc.drawArc(cX, cY , r ,  Gfx.ARC_CLOCKWISE, valueToAngle(greenLow,min,max),valueToAngle(greenHi,min,max));
        
        dc.setColor(hiColor,Gfx.COLOR_TRANSPARENT);        
        dc.drawArc(cX, cY , r ,  Gfx.ARC_CLOCKWISE, valueToAngle(greenHi,min,max), valueToAngle(max,min,max));
        
        var hr = boundValue(currentHR, min, max);
        
		drawHrTriangle(dc, hr, cX, cY, r, min,max);
      	
      	if(currentHR<  greenLow){
      		dc.setColor(lowColor, Gfx.COLOR_TRANSPARENT);
      	}
      	
      	if(currentHR > greenHi){
      		dc.setColor(hiColor, Gfx.COLOR_TRANSPARENT);
      	}
      	  	        
      	if(currentHR >= greenLow and currentHR <=greenHi){
        	dc.setColor(okColor, Gfx.COLOR_TRANSPARENT);
        }
        
        numberHeight = dc.getFontHeight(font)/2;
        dc.drawText(cX, cY - numberHeight ,font,currentHR.format("%3u"),Gfx.TEXT_JUSTIFY_CENTER);
    }
    
    function drawHrTriangle(dc, currentHR, cX, cY, r, min,max)
    {
        var angle = valueToRadians(currentHR,min,max);
        var x1 = Math.cos(angle)* r * 1.2 + cX;
        var y1 = Math.sin(angle) * r * 1.2 + cY;
        
        var x2 = Math.cos(angle-0.2) *r*0.8 + cX;
        var y2 = Math.sin(angle-0.2) *r*0.8 + cY;
        
        var x3 = Math.cos(angle+0.2) *r*0.8 + cX;
        var y3 = Math.sin(angle+0.2) *r*0.8 + cY;
        
        dc.setPenWidth(5);
        
        dc.setColor(infoColor,infoColor); 
        dc.fillPolygon([ [x1, y1], [x2, y2], [x3, y3]]);
    }
    
    function valueToAngle(value, min, max)
    {
    	//MOD(630 - (G4 - 120) * (360/80), 360)
     	var result =  (630.0 - (value - min) * 360.0/(max- min));
    	
    	Sys.println("valueToAngle(" + value.format("%f") + ")=" + result.format("%f"));
    	
   		return result;
    }
    
    function valueToRadians(value, min, max)
    {
    	var result;
    	// Math.PI ;  //(G4-120)/(200-120)* 2 * PI() + 3*PI()/2
 
    	result =  (value - min)/(max-min)* 2 * Math.PI +  Math.PI/2;
    	
    	Sys.println("valueToRadians(" + value.format("%f") + ")=" + result.format("%f"));
    	
    	return result;
    }
}
