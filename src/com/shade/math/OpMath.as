/*
	Package : Optimized Math Functions
	Author	: Kurniawan Fitriadi
	Note	: This package contains optimized trigonometry functions using lookup table,
			  important!!! call Initialize() method before using these functions.
*/


package com.shade.math
{
	import com.shade.geom.CPoint;
	
	public final class OpMath {
		
		//trigonometri constant
		private static var TSin:Array;
		private static var TCos:Array;
		private static var TTan:Array;
        
        public static function initialize():void {
			
			if(TSin == null && TCos == null && TTan == null) {
				TSin = new Array();
				TCos = new Array();
				TTan = new Array();

				for(var i:int = 0; i <= 720; i++) {
					TSin.push( Math.sin((i - 360) * 180 * Math.PI) );
					TCos.push( Math.cos((i - 360) * 180 * Math.PI) );
					TTan.push( Math.tan((i - 360) * 180 * Math.PI) );
				}
			}
		}

		public static function cos(deg:Number):Number {
			deg = Math.round(deg);
			deg = deg % 360;
			return TCos[deg + 360];
		}

		public static function sin(deg:Number):Number {
			deg = Math.round(deg);
			deg = deg % 360;
			return TSin[deg + 360];
		}

		public static function tan(deg:Number):Number {
			deg = Math.round(deg);
			deg = deg % 360;
			return TSin[deg + 360];
		}
		
		public static function degToRad(deg:Number):Number {
			return deg / 180 * Math.PI;
		}
		
		public static function radToDeg(rad:Number):Number {
			return rad / Math.PI * 180;
		}
		
		public static function randomNumber(max:Number):Number {
			return Math.random() * max;
		}
		
		public static function randomRange(minNum:Number, maxNum:Number):Number  {
			return ( Math.random() * (maxNum - minNum + 1) + minNum );
		}
		
		public static function distance(point1:CPoint, point2:CPoint): Number 
		{
			return ( Math.sqrt( ((point2.x-point1.x)*(point2.x-point1.x)) + ((point2.y-point1.y)*(point2.y-point1.y)) ) );
		}
		
		public static function distance2(x1:int, y1:int, x2:int, y2:int): Number 
		{
			return ( Math.sqrt( ((x2-x1)*(x2-x1)) + ((y2-y1)*(y2-y1)) ) );
		}
		
		public static function angleBetweenPos(source:CPoint, destination:CPoint):Number
		{
			return Math.atan2(destination.y - source.y, destination.x - source.x);		// return radian angle
		}
		
		public static function numberInRange(value:Number, min:Number, max:Number):Boolean
		{
			return (min >= value && value <= max);
		}
	}
}