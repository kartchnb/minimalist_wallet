// Adapted from code found at https://climberg.de/post/openscad_bezier_curves_of_any_degrees
// I, honestly, don't understand most of the underlying functions, but they work...
//
// To use this library:
// - define a list of control points
// - Pass that list to the Bezier_DrawCurve function, optionally specifying the line width
//	 and resolution ($fn)



// Draws a line connecting two points
//
// passed:	p1, p2 - the two points to connect with a line
//			width - the width of the lines
module BezierLib_DrawLine(p1, p2, width = 1) 
{
    hull() 
	{
        translate(p1) circle(r = width);
        translate(p2) circle(r = width);
    }
}



// Draws a polyline connecting the supplied points
//
// passed:	points - the points to connect with lines
// 			index - the index of the point to start with 
//				(this is used to recursively call this module for each point)
//			width - the width of the lines
module BezierLib_DrawPolyLine(points, width = 1, index = 1) 
{
    if(index < len(points)) 
    {
        BezierLib_DrawLine(points[index - 1], points[index], width);
        BezierLib_DrawPolyLine(points, width, index + 1);
    }
}



// Draw a bezier curve from a list of control points
//
// passed:	points - the control points of the bezier curve
//			width - the width of the curve surface
module BezierLib_DrawCurve(points, width = 1)
{
    // Calculates points in a bezier line that follow the supplied control points
    //
    // passed:	points - the control points of the bezier curve
    //			resolution - the number of points to return (defaults to $fn)
    // return:	The points defining the bezier curve
    function GenerateCurve(points, $fn = $fn) =
    [
        for (t = [0: 1.0/$fn: 1 + (1/$fn/2)]) PointOnBezier(points, t)
    ];



    function Choose(n, k) =
    k == 0 ? 1 : (n * Choose(n - 1, k - 1))/k;



    function PointsOnBezierRec(points, t, i, c) =
        len(points) == i || len(points) == undef ? c : 
		    PointsOnBezierRec(points, t, i+1, c+Choose(len(points) - 1, i) * pow(t, i) * pow(1 - t, len(points) - i - 1) * points[i]);



    function PointOnBezier(points,t) =
        PointsOnBezierRec(points, t, 0, [0, 0]);




	points = GenerateCurve(points, $fn);
	BezierLib_DrawPolyLine(points, width);
}






// Draws a line connecting two points
//
// passed:	p1, p2 - the two points to connect with a line
//			width - the width of the lines
module BezierLib_DrawLine3D(p1, p2, width = 1) 
{
    hull() 
	{
        translate(p1) sphere(r = width);
        translate(p2) sphere(r = width);
    }
}



// Draws a polyline connecting the supplied points
//
// passed:	points - the points to connect with lines
// 			index - the index of the point to start with 
//				(this is used to recursively call this module for each point)
//			width - the width of the lines
module BezierLib_DrawPolyLine3D(points, width = 1, index = 1) 
{
    if(index < len(points)) 
    {
        BezierLib_DrawLine3D(points[index - 1], points[index], width);
        BezierLib_DrawPolyLine3D(points, width, index + 1);
    }
}



// Draw a bezier curve from a list of control points
//
// passed:	points - the control points of the bezier curve
//			width - the width of the curve surface
module BezierLib_DrawCurve3D(points, width = 1)
{
    // Calculates points in a bezier line that follow the supplied control points
    //
    // passed:	points - the control points of the bezier curve
    //			resolution - the number of points to return (defaults to $fn)
    // return:	The points defining the bezier curve
    function GenerateCurve(points, $fn = $fn) =
    [
        for (t = [0: 1.0/$fn: 1 + (1/$fn/2)]) PointOnBezier(points, t)
    ];



    function Choose(n, k) =
    k == 0 ? 1 : (n * Choose(n - 1, k - 1))/k;



    function PointsOnBezierRec(points, t, i, c) =
        len(points) == i || len(points) == undef ? c : 
		    PointsOnBezierRec(points, t, i+1, c+Choose(len(points) - 1, i) * pow(t, i) * pow(1 - t, len(points) - i - 1) * points[i]);



    function PointOnBezier(points,t) =
        PointsOnBezierRec(points, t, 0, [0, 0]);




	points = GenerateCurve(points, $fn);
	BezierLib_DrawPolyLine3D(points, width);
}
