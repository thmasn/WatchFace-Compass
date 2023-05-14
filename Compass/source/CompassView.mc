import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.Sensor;
using Toybox.Timer;

class CompassView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        startTimer();
    }

    var center;
    var textInfo = "no info";
    // Update the view
    function onUpdate(dc as Dc) as Void {
        center = dc.getWidth()/2;
        getNewAccelData();

        // Get and show the current time
        /*var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);*/
        var timeLabel = View.findDrawableById("TimeLabel") as Text;
        timeLabel.setText(textInfo);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        drawCompassArrow(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }
    
    function startTimer() as Void{
        textInfo = "starting";
        var dataTimer = new Timer.Timer();
        dataTimer.start(method(:timerCallback), 1000, true); // A one-second timer
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    var primaryColor = 0xFFFFFF;
    var secondaryColor = 0x2669a3;


    var compassArrowPoints = [[0,-80],[40,60],[0,20],[-40,60]];

    function fillPolygonTransformed(points as Lang.Array<Lang.Array<Lang.Numeric>>) as Void{
        //var newPoints = points.copy();
        var size = points.size();
        for (var i = 0; i < size; i += 1) {
            //newPoints[i] = points[i];
            points[i][0] += center;
            points[i][1] += center;
        }
    }
    //rotation is clockwise, in radians
    function rotatePoint2d(point as Lang.Array<Lang.Numeric>, rotation){
        var cos = Math.cos(rotation);
        var sin = Math.sin(rotation);
        var x = cos*point[0] - sin*point[1];
        var y = sin*point[0] + cos*point[1];
        return [x,y];
    }
    function drawOutlineTransformed(dc as Dc, points as Lang.Array<Lang.Array<Lang.Numeric>>) as Void{
        var size = points.size();
        var rotation = .1;
        for (var i = 0; i < size; i += 1) {
            
            var p1 = points[i];
            p1 = rotatePoint2d(p1, rotation);
            var p2 = points[(i+1)%size];
            p2 = rotatePoint2d(p2, rotation);

            dc.drawLine(center + p1[0],
                        center + p1[1],
                        center + p2[0],
                        center + p2[1]);
        }
    }

    function timerCallback() as Void {
        textInfo = "updating";
	    //self.requestUpdate();
    }
    function getNewAccelData(){
        textInfo = "updating";
        var sensorInfo = Sensor.getInfo();
        /*
        if (sensorInfo has :accel && sensorInfo.accel != null) {
            var accel = sensorInfo.accel;
            var xAccel = accel[0];
            var yAccel = accel[1];
            textInfo = "x: " + xAccel + ", y: " + yAccel;
        }*/
    }

    function drawCompassArrow(dc as Dc) as Void {
	    dc.setColor(secondaryColor, 0x000000);
        //fillPolygonTransformed(compassArrowPoints);
        //dc.fillPolygon(compassArrowPoints);
        drawOutlineTransformed(dc, compassArrowPoints);
    }

}
