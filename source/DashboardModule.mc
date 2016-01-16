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
	
	 function getFormatedTime()
    {
    	var timeInSeconds = getTime();
    	var seconds = timeInSeconds % 60;
    	var elapsedTimeInMinutes = (timeInSeconds - seconds)/60;
    	var minutes = elapsedTimeInMinutes % 60;
    	var hours = 0 ;
    	
    	if(elapsedTimeInMinutes > 60)
    	{
    		hours = (timeInSeconds - seconds  - minutes * 60) / 3600;
    	}
    	
    	var result = hours.format("%1d") + ":" + minutes.format("%02d") + ":" + seconds.format("%02d");
    	
    	Sys.println("getFormatedTime(" + timeInSeconds.format("%d") + ")=" + result);
    
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