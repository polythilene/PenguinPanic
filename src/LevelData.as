package  
{
	import flash.xml.XMLNode;
	
	/**
	 * ...
	 * @author Wiwit
	 */
	public class LevelData
	{
		static private var m_instance:LevelData;
		
		private var m_data:XML;
		
		public function LevelData(lock:SingletonLock)
		{
			initialize();
		}
		
		public function getData():XML
		{
			return m_data;
		}
		
		private function initialize():void
		{
			//m_data = new XML();
			m_data = <leveldata>
						<level id="ACT ONE">
							<misc>
								<countdown minute="3" second="0" />
								<checkpoint length="3000" />
								<penguin count="10" />
								<bystanders spawn_rate="0" interval="0" />
							</misc>
		
							<food>
								<krill tier_one="10" tier_two="20" tier_three="30" />
								<smallfish spawn_rate="20" interval="5000" />
							</food>
		
							<powerup>
								<invincible spawn_rate="10" interval="30000" />
								<multiplier spawn_rate="20" interval="20000" />			
								<stream tier_one="35" tier_two="35" tier_three="30" interval="10000" />
							</powerup>
			
							<obstacle>
								<anchor spawn_rate="0" interval="0" />
								<shard spawn_rate="0" interval="0" />
								<jellyfish spawn_rate="10" interval="10000" />
								<toxic tier_one="20" tier_two="5" />
							</obstacle>
							
							<predator interval_min="20000" interval_max="30000">
								<shark spawn_rate="10" />
								<seal spawn_rate="0" />
							</predator>
						</level>
	
						<level id="ACT TWO">
							<misc>
								<countdown minute="3" second="0" />
								<checkpoint length="3500" />
								<penguin count="10" />
								<bystanders spawn_rate="10" interval="20000" />
							</misc>
							
							<food>
								<krill tier_one="12" tier_two="19" tier_three="27" />
								<smallfish spawn_rate="20" interval="5000" />
							</food>
							
							<powerup>
								<invincible spawn_rate="10" interval="30000" />
								<multiplier spawn_rate="20" interval="20000" />			
								<stream tier_one="35" tier_two="35" tier_three="30" interval="10000" />
							</powerup>
								
							<obstacle>
								<anchor spawn_rate="5" interval="10000" />
								<shard spawn_rate="0" interval="0" />
								<jellyfish spawn_rate="10" interval="10000" />
								<toxic tier_one="20" tier_two="5" />
							</obstacle>
							
							<predator interval_min="20000" interval_max="30000">
								<shark spawn_rate="10" />
								<seal spawn_rate="0" />
							</predator>
						</level>
	
						<level id="ACT THREE">
							<misc>
								<countdown minute="3" second="30" />
								<checkpoint length="4000" />
								<penguin count="10" />
								<bystanders spawn_rate="10" interval="20000" />
							</misc>
							
							<food>
								<krill tier_one="14" tier_two="18" tier_three="24" />
								<smallfish spawn_rate="20" interval="5000" />
							</food>
							
							<powerup>
								<invincible spawn_rate="10" interval="30000" />
								<multiplier spawn_rate="20" interval="20000" />			
								<stream tier_one="45" tier_two="40" tier_three="15" interval="10000" />
							</powerup>
								
							<obstacle>
								<anchor spawn_rate="5" interval="10000" />
								<shard spawn_rate="0" interval="0" />
								<jellyfish spawn_rate="12" interval="10000" />
								<toxic tier_one="20" tier_two="10" />
							</obstacle>
							
							<predator interval_min="20000" interval_max="30000">
								<shark spawn_rate="20" />
								<seal spawn_rate="10" />
							</predator>
						</level>
	
					<level id="ACT FOUR">
						<misc>
							<countdown minute="3" second="30" />
							<checkpoint length="4500" />
							<penguin count="10" />
							<bystanders spawn_rate="10" interval="18500" />
						</misc>
						
						<food>
							<krill tier_one="16" tier_two="17" tier_three="21" />
							<smallfish spawn_rate="20" interval="5000" />
						</food>
						
						<powerup>
							<invincible spawn_rate="10" interval="30000" />
							<multiplier spawn_rate="15" interval="20000" />			
							<stream tier_one="45" tier_two="40" tier_three="15" interval="10000" />
						</powerup>
							
						<obstacle>
							<anchor spawn_rate="8" interval="10000" />
							<shard spawn_rate="10" interval="10000" />
							<jellyfish spawn_rate="12" interval="10000" />
							<toxic tier_one="20" tier_two="10" />
						</obstacle>
						
						<predator interval_min="15000" interval_max="25000">
							<shark spawn_rate="20" />
							<seal spawn_rate="10" />
						</predator>
					</level>
					
					<level id="ACT FIVE">
						<misc>
							<countdown minute="3" second="10" />
							<checkpoint length="4700" />
							<penguin count="10" />
							<bystanders spawn_rate="10" interval="18000" />
						</misc>
						
						<food>
							<krill tier_one="18" tier_two="16" tier_three="18" />
							<smallfish spawn_rate="30" interval="5000" />
						</food>
						
						<powerup>
							<invincible spawn_rate="10" interval="30000" />
							<multiplier spawn_rate="15" interval="20000" />			
							<stream tier_one="35" tier_two="55" tier_three="10" interval="10000" />
						</powerup>
							
						<obstacle>
							<anchor spawn_rate="8" interval="10000" />
							<shard spawn_rate="10" interval="10000" />
							<jellyfish spawn_rate="25" interval="10000" />
							<toxic tier_one="20" tier_two="12" />
						</obstacle>
						
						<predator interval_min="15000" interval_max="25000">
							<shark spawn_rate="35" />
							<seal spawn_rate="15" />
						</predator>
					</level>
					
					<level id="ACT SIX">
						<misc>
							<countdown minute="3" second="30" />
							<checkpoint length="5000" />
							<penguin count="10" />
							<bystanders spawn_rate="10" interval="17500" />
						</misc>
						
						<food>
							<krill tier_one="20" tier_two="15" tier_three="15" />
							<smallfish spawn_rate="30" interval="5000" />
						</food>
						
						<powerup>
							<invincible spawn_rate="10" interval="30000" />
							<multiplier spawn_rate="15" interval="20000" />			
							<stream tier_one="40" tier_two="50" tier_three="10" interval="10000" />
						</powerup>
							
						<obstacle>
							<anchor spawn_rate="10" interval="10000" />
							<shard spawn_rate="12" interval="10000" />
							<jellyfish spawn_rate="25" interval="10000" />
							<toxic tier_one="25" tier_two="12" />
						</obstacle>
						
						<predator interval_min="15000" interval_max="25000">
							<shark spawn_rate="35" />
							<seal spawn_rate="15" />
						</predator>
					</level>
					
					<level id="ACT SEVEN">
						<misc>
							<countdown minute="3" second="30" />
							<checkpoint length="5100" />
							<penguin count="10" />
							<bystanders spawn_rate="10" interval="17000" />
						</misc>
						
						<food>
							<krill tier_one="22" tier_two="14" tier_three="12" />
							<smallfish spawn_rate="15" interval="5000" />
						</food>
						
						<powerup>
							<invincible spawn_rate="5" interval="30000" />
							<multiplier spawn_rate="12" interval="20000" />			
							<stream tier_one="45" tier_two="55" tier_three="5" interval="10000" />
						</powerup>
							
						<obstacle>
							<anchor spawn_rate="10" interval="10000" />
							<shard spawn_rate="12" interval="10000" />
							<jellyfish spawn_rate="30" interval="10000" />
							<toxic tier_one="25" tier_two="12" />
						</obstacle>
						
						<predator interval_min="15000" interval_max="25000">
							<shark spawn_rate="30" />
							<seal spawn_rate="20" />
						</predator>
					</level>
					
					<level id="ACT EIGHT">
						<misc>
							<countdown minute="6" second="40" />
							<checkpoint length="5500" />
							<penguin count="8" />
							<bystanders spawn_rate="10" interval="16500" />
						</misc>
						
						<food>
							<krill tier_one="24" tier_two="13" tier_three="9" />
							<smallfish spawn_rate="15" interval="5000" />
						</food>
						
						<powerup>
							<invincible spawn_rate="7" interval="30000" />
							<multiplier spawn_rate="10" interval="20000" />			
							<stream tier_one="60" tier_two="35" tier_three="5" interval="10000" />
						</powerup>
							
						<obstacle>
							<anchor spawn_rate="12" interval="10000" />
							<shard spawn_rate="15" interval="10000" />
							<jellyfish spawn_rate="30" interval="10000" />
							<toxic tier_one="25" tier_two="15" />
						</obstacle>
						
						<predator interval_min="10000" interval_max="20000">
							<shark spawn_rate="30" />
							<seal spawn_rate="20" />
						</predator>
					</level>
					
					<level id="ACT NINE">
						<misc>
							<countdown minute="7" second="0" />
							<checkpoint length="6000" />
							<penguin count="8" />
							<bystanders spawn_rate="10" interval="16000" />
						</misc>
						
						<food>
							<krill tier_one="26" tier_two="12" tier_three="6" />
							<smallfish spawn_rate="20" interval="5000" />
						</food>
						
						<powerup>
							<invincible spawn_rate="5" interval="30000" />
							<multiplier spawn_rate="10" interval="20000" />			
							<stream tier_one="70" tier_two="25" tier_three="5" interval="10000" />
						</powerup>
							
						<obstacle>
							<anchor spawn_rate="12" interval="10000" />
							<shard spawn_rate="17" interval="10000" />
							<jellyfish spawn_rate="30" interval="10000" />
							<toxic tier_one="25" tier_two="15" />
						</obstacle>
						
						<predator interval_min="10000" interval_max="20000">
							<shark spawn_rate="30" />
							<seal spawn_rate="20" />
						</predator>
					</level>
					
					<level id="ACT TEN">
						<misc>
							<countdown minute="7" second="40" />
							<checkpoint length="6200" />
							<penguin count="8" />
							<bystanders spawn_rate="20" interval="15500" />
						</misc>
						
						<food>
							<krill tier_one="28" tier_two="11" tier_three="6" />
							<smallfish spawn_rate="20" interval="5000" />
						</food>
						
						<powerup>
							<invincible spawn_rate="7" interval="30000" />
							<multiplier spawn_rate="10" interval="20000" />			
							<stream tier_one="85" tier_two="10" tier_three="5" interval="10000" />
						</powerup>
							
						<obstacle>
							<anchor spawn_rate="15" interval="10000" />
							<shard spawn_rate="25" interval="10000" />
							<jellyfish spawn_rate="30" interval="10000" />
							<toxic tier_one="25" tier_two="15" />
						</obstacle>
						
						<predator interval_min="10000" interval_max="20000">
							<shark spawn_rate="30" />
							<seal spawn_rate="20" />
						</predator>
					</level>
			
				
					<level id="ACT ELEVEN">
						<misc>
							<countdown minute="8" second="0" />
							<checkpoint length="6300" />
							<penguin count="7" />
							<bystanders spawn_rate="20" interval="15500" />
						</misc>
						
						<food>
							<krill tier_one="28" tier_two="11" tier_three="6" />
							<smallfish spawn_rate="20" interval="5000" />
						</food>
						
						<powerup>
							<invincible spawn_rate="7" interval="30000" />
							<multiplier spawn_rate="10" interval="20000" />			
							<stream tier_one="85" tier_two="10" tier_three="5" interval="10000" />
						</powerup>
							
						<obstacle>
							<anchor spawn_rate="15" interval="10000" />
							<shard spawn_rate="55" interval="5000" />
							<jellyfish spawn_rate="30" interval="7000" />
							<toxic tier_one="25" tier_two="15" />
						</obstacle>
						
						<predator interval_min="10000" interval_max="20000">
							<shark spawn_rate="30" />
							<seal spawn_rate="20" />
						</predator>
					</level>
				
				
					<level id="ACT TWELVE">
						<misc>
							<countdown minute="8" second="0" />
							<checkpoint length="6500" />
							<penguin count="7" />
							<bystanders spawn_rate="20" interval="15500" />
						</misc>
						
						<food>
							<krill tier_one="28" tier_two="11" tier_three="6" />
							<smallfish spawn_rate="20" interval="5000" />
						</food>
						
						<powerup>
							<invincible spawn_rate="7" interval="30000" />
							<multiplier spawn_rate="10" interval="20000" />			
							<stream tier_one="85" tier_two="10" tier_three="5" interval="10000" />
						</powerup>
							
						<obstacle>
							<anchor spawn_rate="15" interval="10000" />
							<shard spawn_rate="25" interval="10000" />
							<jellyfish spawn_rate="55" interval="5000" />
							<toxic tier_one="25" tier_two="15" />
						</obstacle>
						
						<predator interval_min="10000" interval_max="20000">
							<shark spawn_rate="30" />
							<seal spawn_rate="20" />
						</predator>
					</level>
				
				
					<level id="ACT THIRTEEN">
						<misc>
							<countdown minute="8" second="30" />
							<checkpoint length="6600" />
							<penguin count="7" />
							<bystanders spawn_rate="20" interval="15500" />
						</misc>
						
						<food>
							<krill tier_one="28" tier_two="11" tier_three="6" />
							<smallfish spawn_rate="20" interval="5000" />
						</food>
						
						<powerup>
							<invincible spawn_rate="7" interval="30000" />
							<multiplier spawn_rate="10" interval="20000" />			
							<stream tier_one="85" tier_two="10" tier_three="5" interval="10000" />
						</powerup>
							
						<obstacle>
							<anchor spawn_rate="15" interval="10000" />
							<shard spawn_rate="25" interval="7000" />
							<jellyfish spawn_rate="30" interval="7000" />
							<toxic tier_one="25" tier_two="15" />
						</obstacle>
						
						<predator interval_min="10000" interval_max="20000">
							<shark spawn_rate="40" />
							<seal spawn_rate="20" />
						</predator>
					</level>
					
				
					<level id="ACT FOURTEEN">
						<misc>
							<countdown minute="8" second="0" />
							<checkpoint length="6800" />
							<penguin count="5" />
							<bystanders spawn_rate="20" interval="15500" />
						</misc>
						
						<food>
							<krill tier_one="28" tier_two="11" tier_three="6" />
							<smallfish spawn_rate="20" interval="5000" />
						</food>
						
						<powerup>
							<invincible spawn_rate="7" interval="30000" />
							<multiplier spawn_rate="10" interval="20000" />			
							<stream tier_one="85" tier_two="10" tier_three="5" interval="10000" />
						</powerup>
							
						<obstacle>
							<anchor spawn_rate="15" interval="10000" />
							<shard spawn_rate="25" interval="10000" />
							<jellyfish spawn_rate="40" interval="10000" />
							<toxic tier_one="45" tier_two="15" />
						</obstacle>
						
						<predator interval_min="10000" interval_max="20000">
							<shark spawn_rate="30" />
							<seal spawn_rate="20" />
						</predator>
					</level>
					
				
					<level id="ACT FIFTEEN">
						<misc>
							<countdown minute="10" second="0" />
							<checkpoint length="7000" />
							<penguin count="5" />
							<bystanders spawn_rate="20" interval="15500" />
						</misc>
						
						<food>
							<krill tier_one="28" tier_two="11" tier_three="6" />
							<smallfish spawn_rate="20" interval="5000" />
						</food>
						
						<powerup>
							<invincible spawn_rate="15" interval="30000" />
							<multiplier spawn_rate="10" interval="20000" />			
							<stream tier_one="85" tier_two="10" tier_three="5" interval="7000" />
						</powerup>
							
						<obstacle>
							<anchor spawn_rate="15" interval="10000" />
							<shard spawn_rate="35" interval="10000" />
							<jellyfish spawn_rate="40" interval="10000" />
							<toxic tier_one="25" tier_two="15" />
						</obstacle>
						
						<predator interval_min="10000" interval_max="20000">
							<shark spawn_rate="40" />
							<seal spawn_rate="30" />
						</predator>
					</level>
				</leveldata>;
		}
		
		static public function getInstance(): LevelData
		{
			if( m_instance == null ){
				m_instance = new LevelData( new SingletonLock() );
			}
			return m_instance;
		}
	}
}

class SingletonLock{}