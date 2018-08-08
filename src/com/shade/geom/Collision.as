package com.shade.geom
{
	import com.shade.geom.CRectangle;

	public final class Collision {
			
			
		static public function isBoxInsideBox(smallBox:CRectangle, bigBox:CRectangle) : Boolean 
		{
			if( bigBox.x > smallBox.x )
				return false;
			if( bigBox.x + bigBox.width < smallBox.x + smallBox.width )
				return false;	
			if( bigBox.y > smallBox.y )
				return false;	
			if( bigBox.y + bigBox.height < smallBox.y + smallBox.height )
				return false;		
			
			return true;	
		}
		
		static public function isBoxInsideBox2(smallbox_x:int, smallbox_y:int, smallbox_width:int, smallbox_height:int,
											   bigbox_x:int, bigbox_y:int, bigbox_width:int, bigbox_height:int) : Boolean 
		{
			if( bigbox_x > smallbox_x )
				return false;
			if( bigbox_x + bigbox_width < smallbox_x + smallbox_width )
				return false;	
			if( bigbox_y > smallbox_y )
				return false;	
			if( bigbox_y + bigbox_height < smallbox_y + smallbox_height )
				return false;		
				
			return true;	
		}
		
		static public function isPointInsideCircle( point_x:int, point_y:int, 
												    circle_x:int, circle_y:int,
													circle_radius:int ) : Boolean
		{
			var distX:int = point_x - circle_x;
        	var distY:int = point_y - circle_y;
        	var squareR:int = distX*distX + distY*distY;

        	return ( squareR <= (circle_radius*circle_radius) ) ? true : false;
    	}
				
		static public function isPointInsideBox( point_x:int, point_y:int,
												 box_x:int, box_y:int,
												 box_width:int, box_height:int) : Boolean
		{
			if( point_x < box_x ) 
				return false;
			if( point_x > box_x+box_width )
				return false;
			if( point_y < box_y ) 
				return false;
			if( point_y > box_y+box_height ) 
				return false;

			return true;
		}

		static public function isBoxIntersectsCircle( box_pos_x:int, box_pos_y:int,
													  box_width:int, box_height:int,
												      circle_x:int, circle_y:int,
													  circle_radius:int ) : Boolean
		{
			var box_halfWidth:Number = box_width >> 1;
			var box_halfHeight:Number = box_height >> 1;

			// circle center inside the box ?
			if( isPointInsideBox( circle_x, circle_y, box_pos_x, box_pos_y, box_width, box_height) )
				return true;
									
			// calculate distance between object's center			
			var distX:int = circle_x - (box_pos_x + box_halfWidth);
	    	var distY:int = circle_y - (box_pos_y + box_halfHeight);
    		var squaredDistance:int = distX*distX + distY*distY;
			
			// get the angle between the objects
			var angleBetweenCircleAndBox:Number = Math.atan2( distY, distX );
			
			// wrap around the negative angles. we want 
			// the angle to belong to [0,2*PI]
			if( angleBetweenCircleAndBox < 0 ) 
				angleBetweenCircleAndBox += 2.0 * Math.PI;
			
			// check if box and circle collide
			var alpha:Number = Math.atan2( box_halfHeight, box_halfWidth );			
			var boxRadius:int;
			
			
			if( angleBetweenCircleAndBox < alpha || angleBetweenCircleAndBox >= ( 2.0*Math.PI - alpha ) )
				boxRadius = box_halfWidth / Math.cos( angleBetweenCircleAndBox );
        	else if ( angleBetweenCircleAndBox < ( Math.PI - alpha ) ) 
            	boxRadius = box_halfHeight / Math.cos( angleBetweenCircleAndBox - Math.PI/2.0 );
			else if ( angleBetweenCircleAndBox < ( Math.PI + alpha ) ) 
            	boxRadius = box_halfWidth / Math.cos( angleBetweenCircleAndBox - Math.PI );
			else
				boxRadius = box_halfHeight / Math.cos( angleBetweenCircleAndBox - 3.0*Math.PI/2.0 );
			
			var oppositeAngle:Number = angleBetweenCircleAndBox - Math.PI;
			if( oppositeAngle < 0 ) 
			    oppositeAngle += 2.0*Math.PI;
    		
			var angle:Number = angleBetweenCircleAndBox * 180.0 / Math.PI;
			var squareBoxRadius:int = boxRadius*boxRadius;
    
    		var remaining:Number = Math.sqrt( squaredDistance ) - circle_radius - boxRadius;
			if( remaining <= 0 ) 
				return true;
    					
			var closestCornerX:int = ( angleBetweenCircleAndBox > 3.0*Math.PI/2.0 || angleBetweenCircleAndBox < Math.PI/2.0 ) ? box_pos_x + box_width : box_pos_x;
			var closestCornerY:int = ( angleBetweenCircleAndBox >= 0 && angleBetweenCircleAndBox <= Math.PI ) ? box_pos_y + box_height : box_pos_y;
											
			if( isPointInsideCircle( closestCornerX, closestCornerY, circle_x, circle_y, circle_radius ) )
				return true;

			return false;	
		}
		
		static private var intersect_point:CPoint;
 
		static public function intersection(p1:CPoint, p2:CPoint, p3:CPoint, p4:CPoint):CPoint 
		{
			if( intersect_point == null )
				intersect_point = new CPoint();
			
		    var nx:Number, ny:Number, dn:Number;
		    var x4_x3:Number = p4.x - p3.x;
		    var pre2:Number = p4.y - p3.y;
		    var pre3:Number = p2.x - p1.x;
		    var pre4:Number = p2.y - p1.y;
		    var pre5:Number = p1.y - p3.y;
		    var pre6:Number = p1.x - p3.x;
		    nx = x4_x3 * pre5 - pre2 * pre6;
		    ny = pre3 * pre5 - pre4 * pre6;
		    dn = pre2 * pre3 - x4_x3 * pre4;
		    nx /= dn;
		    ny /= dn;
		    // has intersection
		    if (nx >= 0 && nx <= 1 && ny >= 0 && ny <= 1)
			{
        		ny = p1.y + nx * pre4;
		        nx = p1.x + nx * pre3;
		        intersect_point.x = nx;
		        intersect_point.y = ny;
		    }
			else
			{
				// no intersection
				return null;
			}
			return intersect_point;
		}
		
		static private var rayStart:CPoint;
		static private var rayEnd:CPoint;
		static private var lineStart:CPoint;
		static private var lineEnd:CPoint;

		static public function isRayIntersectBox2( rayStartX:int, rayStartY:int,
												   rayEndX:int, rayEndY:int,
												   box:CRectangle):CPoint
		{
			var ip:CPoint;
			
			if( rayStart == null )		rayStart = new CPoint();
			if( rayEnd == null )		rayEnd = new CPoint();
			if( lineStart == null )		lineStart = new CPoint();
			if( lineEnd == null )		lineEnd = new CPoint();
			
			rayStart.x = rayStartX;		rayStart.y = rayStartY;
			rayEnd.x = rayEndX;			rayEnd.y = rayEndY;
			
			// edge 1
			lineStart.x = box.x;			lineStart.y = box.y;
			lineEnd.x = box.x + box.width;	lineEnd.y = box.y;
			
			ip = intersection( rayStart, rayEnd, lineStart, lineEnd );
			if( ip != null )						 
			{
				return ip;
			}
				
			// edge 2
			lineStart.x = box.x + box.width;	lineStart.y = box.y;
			lineEnd.x = box.x + box.width;		lineEnd.y = box.y + box.height;
			
			ip = intersection( rayStart, rayEnd, lineStart, lineEnd );
			if( ip != null )	
			{
				return ip;
			}
				
			// edge 3
			lineStart.x = box.x + box.width;	lineStart.y = box.y + box.height;
			lineEnd.x = box.x;					lineEnd.y = box.y + box.height;
			
			ip = intersection( rayStart, rayEnd, lineStart, lineEnd );
			if( ip != null )						 
			{
				return ip;
			}
				
			// edge 4
			lineStart.x = box.x;	lineStart.y = box.y + box.height;
			lineEnd.x =box.x;		lineEnd.y = box.y;
			
			ip = intersection( rayStart, rayEnd, lineStart, lineEnd );
			if( ip != null )
			{
				return ip;
			}	
			
			return null;
		}
	}
}