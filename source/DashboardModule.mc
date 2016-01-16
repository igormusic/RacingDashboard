using Toybox.Application as App;
using Toybox.System as Sys;

module Dashboard
{


	function setTime(timeInSeconds)
	{
		var app = App.getApp();

        app.setProperty("time_prop", timeInSeconds);
	}
	
	function getTime()
	{
		var app = App.getApp();

        return app.getProperty("time_prop");
	}
	
	function setDistance(distanceInKM)
	{
		var app = App.getApp();
    	
    	app.setProperty("distance_prop", distanceInKM);
	}
	
	function getDistance()
	{
		var app = App.getApp();
    	
    	return app.getProperty("distance_prop");
	}
	
	function setMaxHR(maxHR)
	{
		var app = App.getApp();
        app.setProperty("maxHR_prop", maxHR);
	}
	
	function getMaxHR()
	{
		var app = App.getApp();
        return app.getProperty("maxHR_prop");
	}
	
	function setMinHR(minHR)
	{
		var app = App.getApp();
        return app.setProperty("minHR_prop", minHR);
	}
	
	function getMinHR()
	{
		var app = App.getApp();
        return app.getProperty("minHR_prop");
	}
	
	function getFormatedTime(elapsedTimeInMs)
    {
    	var sign ="";
    	
    	if(elapsedTimeInMs<0)
    	{
    		sign ="-";
    		elapsedTimeInMs = - elapsedTimeInMs;
    	}
    	
    	var elapsedTimeInSeconds = elapsedTimeInMs / 1000;
    	var seconds = elapsedTimeInSeconds % 60;
    	var elapsedTimeInMinutes = (elapsedTimeInSeconds - seconds)/60;
    	var minutes = elapsedTimeInMinutes % 60;
    	var hours = 0 ;
    	
    	if(elapsedTimeInMinutes > 60)
    	{
    		hours = (elapsedTimeInSeconds - seconds * 60 - minutes * 3600) / 3600;
    	}
    	
    	var result;
    	
    	if (hours>0)
    	{
    		result = sign + hours.format("%1d") + ":" + minutes.format("%02d") + ":" + seconds.format("%02d");
    	}
    	else
    	{
    		result  = sign + minutes.format("%02d") + ":" + seconds.format("%02d");
    	}
    	
    	Sys.println("getFormatedTime(" + elapsedTimeInMs.format("%d") + ")=" + result);
    
    	return result;	
    }
	
    
    function getExpectedSpeed()
	{
		var distanceInMeters = getDistance() * 1000.0;
		var speed = distanceInMeters.toFloat() / getTime().toFloat();
		
		return speed;    	
    }
    
    function getSecondsAhead(actualDistance, actualSeconds)
    {
    	var expectedSeconds = (actualDistance.toFloat() / getDistance().toFloat() * getTime().toFloat()).toLong();
    	var ahead = expectedSeconds - actualSeconds;
    	return ahead;
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
    
    //metersPerSecond: original speed
    //paceSecondsDelta: how many seconds pace should be faster/slower than original speed
    //return: speed adjusted for pace that is faster/slower number of seconds
    function getAdjsutedSpeed(metersPerSecond, paceSecondsDelta)
    {
    
    	var secondsPerKM = (1000.0 / metersPerSecond) + paceSecondsDelta;
    	
    	var result = 1000.0 / secondsPerKM;
    
    	return result;	
    }
    
   
    function getMinExpectedSpeed(secondsLate)
    {
    	
    	var distanceInMeters = getDistance() * 1000.0;
		var speed = distanceInMeters.toFloat() / (getTime()+secondsLate).toFloat();
		
		return speed;
    }
    
    function getMaxExpectedSpeed(secondsEarly)
    {
    	
    	var distanceInMeters = getDistance() * 1000;
		var speed = distanceInMeters.toFloat() / (getTime()-secondsEarly).toFloat();
		
		return speed;
    }

}