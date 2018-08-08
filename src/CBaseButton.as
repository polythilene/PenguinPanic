package  
{
	/**
	 * ...
	 * @author Wiwit
	 */
	public class CBaseButton
	{
		public var prev:CBaseButton;
		public var next:CBaseButton;
		
		private var m_type:int;
		private var m_func:Function;
		private var m_alive:Boolean;
		
		public function CBaseButton() 
		{
			initialize();
		}
		
		protected var initialize()
		{
			prev = next = null;
		}
		
		public function reset( powerup_type:int, func:Function ) : void
		{
			m_type = powerup_type;
			m_func = func;
			
			m_alive = true;
		}
		
		public function execute(): void 
		{
			m_func();
			m_alive = false;
		}
	}
}