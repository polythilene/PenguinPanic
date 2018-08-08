package  
{
	/**
	 * ...
	 * @author Wiwit
	 */
	public class CFloatingText extends BaseFloatingText
	{
		public var prev:CFloatingText;
		public var next:CFloatingText;
				
		private var m_lifeTime:int;
		private var m_maxLifeTime:int;
		
		
		public function CFloatingText() {}
		
		public function reset(text: String, x: int, y: int, color:String, lifeTime:int, size:int=14): void
		{
			this.x = x;
			this.y = y
			//this.text.textColor = color;
			this.text.htmlText = "<font color=\"" + color + "\" size=\"" + String(size) + "\">" + text + "</font>";
			
			this.m_lifeTime = 0;
			this.m_maxLifeTime = lifeTime;
		}
		
		public function isAlive(): Boolean
		{
			return (m_lifeTime < m_maxLifeTime);
		}
		
		public function update(elapsedTime: int): void
		{
			m_lifeTime += elapsedTime
			this.y -= 0.07 * elapsedTime;
		}
	}
}