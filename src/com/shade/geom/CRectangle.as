package com.shade.geom
{
	public class CRectangle 
	{
		private var m_x:int;
		private var m_y:int;
		private var m_width:int;
		private var m_height:int;
		
		
		public function CRectangle(_x:int=0, _y:int=0, _width:int=0, _height:int=0) {
			m_x = _x;
			m_y = _y;
			m_width = _width;
			m_height = _height;
		}
		
		public function get x():int	{
			return m_x;
		}
		
		public function get y():int	{
			return m_y;
		}
		
		public function set x(value:int):void {
			m_x = value;
		}
		
		public function set y(value:int):void {
			m_y = value;
		}
		
		public function set width(value:int):void {
			m_width = value;
		}
		
		public function set height(value:int):void {
			m_height = value;
		}
		
		public function get width():int	{
			return m_width;
		}
		
		public function get height():int	{
			return m_height;
		}
		
		public function intersects(item:CRectangle):Boolean {

			if (m_y + m_height < item.y) return false;
    		if (m_y > item.y + item.height) return false;

    		if (m_x + m_width < item.x) return false;
    		if (m_x > item.x + item.width) return false;

		    return true;
		}
	}
}