package com.shade.geom
{
	public class CPoint 
	{
		private var m_x:int;
		private var m_y:int;
		
		public function CPoint(_x:int=0, _y:int=0) {
			m_x = _x;
			m_y = _y;
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
		
		public function assign(source:CPoint): void {
			m_x = source.x;
			m_y = source.y;
		}
	}
}