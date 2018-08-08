package  
{
	import flash.display.MovieClip;
	import com.shade.geom.CPoint;
	import com.shade.math.OpMath;
	
	
	/**
	 * ...
	 * @author Kurniawan Fitriadi
	 */
	public class CBasePredator
	{
		public var prev:CBasePredator;
		public var next:CBasePredator;
		
		protected const STEADY:int 		= 0;		// observe prey
		protected const ATTACK:int 		= 1;		// attack prey
		protected const COOLDOWN:int 	= 2;		// failed attack
		protected const CHEW:int 		= 3;		// success attack
		
		protected var m_active:Boolean;
		
		protected var m_clip:MovieClip;
		protected var m_dummy:MovieClip;
				
		protected var m_position:CPoint;
		
		protected var m_targetPenguin:CBoid;
		protected var m_eat:Boolean;
		protected var m_state:int;
		protected var m_angle:int;
		
		protected var m_attackRemaining:int;
		protected var m_swimSpeed:Number;
		protected var m_normalSpeed:Number;
		protected var m_attackSpeed:Number;
		protected var m_retireTime:int;
		protected var m_attackTime:int;
		protected var m_agressive:Boolean;
		protected var m_evadeCheck:Boolean;
		
		public function CBasePredator() 
		{
			initialize();
		}
		
		protected function initialize(): void
		{
			m_active = false;
			m_position = new CPoint();
		}
		
		public function setDead():void
		{
			m_active = false;
		}
		
		public function reset(x:int, y:int): void
		{
			m_clip.x = x;
			m_clip.y = y;
			m_clip.scaleY = 1;
			m_active = true;
			
			GameVars.rootClip.addChild( m_clip );
			
			m_angle = 0;
			m_clip.rotation = m_angle;
			m_clip.creature.gotoAndStop(1);
			
			m_eat = false;
			m_state = STEADY;
			m_targetPenguin = null;
			m_retireTime = 10000;
			m_evadeCheck = false;
		}
		
		public function remove(): void
		{
			GameVars.rootClip.removeChild(m_clip);
		}
		
		public function isAlive(): Boolean
		{
			return m_active;
		}
		
		public function getPosition(): CPoint
		{
			return m_position;
		}
		
		public function update(elapsedTime:int): void
		{
			m_retireTime -= elapsedTime;
			
			if ( m_clip.x < GameVars.cameraPos.x - 320 - 1500 )
			{
				m_active = false;
			}
			else if ( m_state != CHEW && m_state != COOLDOWN )
			{
				if( m_targetPenguin == null )
					m_targetPenguin = SwarmManager.getInstance().getNearestBoid( m_position );
					
				if ( m_targetPenguin != null )
				{
					if( Math.abs(m_angle) > 90 && Math.abs(m_angle) < 180 )
						m_clip.scaleY = -1;
					else
						m_clip.scaleY = 1;
					
					if (m_state == ATTACK)
					{
						m_attackRemaining -= elapsedTime;
						if (m_attackRemaining <= 0)
						{
							m_state = COOLDOWN;
							m_swimSpeed = m_normalSpeed;
							m_clip.creature.gotoAndStop(1);
						}
					}
					
					/* Face Target */
					var dist:int = OpMath.distance( m_targetPenguin.getPosition(), m_position );
					if( dist > 100 && 
						( (dist < 600 && m_state == STEADY) || (m_state == ATTACK && m_agressive) ) )
					{
						m_angle = OpMath.angleBetweenPos( m_targetPenguin.getPosition(), m_position );
						m_clip.rotation = m_angle;
					}	
					
					if ( dist < 300 && m_state != ATTACK )
					{
						m_state = ATTACK;
						m_swimSpeed = m_attackSpeed;
						m_attackRemaining = m_attackTime;	
						m_clip.creature.gotoAndStop(2);
					}
						
					if( m_retireTime > 0 )
					{
						m_clip.x += OpMath.cos(m_angle + 180) * (m_swimSpeed * elapsedTime);
						m_clip.y += OpMath.sin(m_angle + 180) * (m_swimSpeed * elapsedTime);
					}
										
					// check if predator is colliding with penguins
					if ( !GameVars.powerUpInvincible && !SwarmManager.getInstance().isPanic() && !GameVars.gameOver )
					{
						var boid:CBoid = SwarmManager.getInstance().getFirstBoid();
						
						/* check collision with the penguins */
						while( boid != null && !m_eat ) 
						{
							if( boid.isAlive() )
							{
								var boidPos:CPoint = boid.getPosition();
								
								if ( m_dummy.hitTestObject( boid.getClip() ) )
								{
									var cheathDeath:Boolean = false;
									
									/* try to cheat death (upgrade only) */
									if ( GameVars.upgradeLuckObtained )
									{
										if( Math.floor(OpMath.randomNumber(100)) < GameVars.CHEATH_DEATH_FACTOR )
											cheathDeath = true;
									}
									
									if (!cheathDeath)
									{
										GameVars.eatenCounter++;
										
										if( GameVars.eatenCounter == 20 &&
											!GameVars.achievementPenguliciousObtained &&
											GameVars.gameMode == 0 )
										{
											GameVars.achievementPenguliciousObtained = true;
											GameLoop.getInstance().showAchievement( "Pengulicious.", "20x Got Eaten By Predators.", 100 );
										}
										
										/* update state*/
										boid.setDead();
										m_eat = true;
										m_state = CHEW;
										m_swimSpeed = m_normalSpeed;
										m_targetPenguin = null;
										SoundManager.getInstance().playSFX("Predator_Eat", 0.35);
										m_clip.creature.gotoAndStop(1);
									}
								}
							}	
							boid = boid.next;
						}
					}
				}
				else
				{
					// no target just swim calmly
					m_clip.x += OpMath.cos(m_angle + 180) * (m_swimSpeed * elapsedTime);
					m_clip.y += OpMath.sin(m_angle + 180) * (m_swimSpeed * elapsedTime);
				}
			}
			else if ( m_state == COOLDOWN && !m_eat && !m_evadeCheck )
			{
				m_evadeCheck = true;
				
				if ( SwarmManager.getInstance().isPanic() )
				{
					GameVars.evadeWithPanicCounter++;
					trace("Evade With Panic = ", GameVars.evadeWithoutPanicCounter);
					
					if ( !GameVars.achievementHahaYouCantGetMeObtained &&
						 GameVars.gameMode == 0 )
					{				
						GameVars.achievementHahaYouCantGetMeObtained = true;
						GameLoop.getInstance().showAchievement( "You Can't Get Me.", "Avoid Predator Using Panic Ability.", 100 );
					}
					
					if( GameVars.evadeWithPanicCounter == 10 &&
						!GameVars.achievementEatMyTrailObtained &&
						GameVars.gameMode == 0 )
					{
						GameVars.achievementEatMyTrailObtained = true;
						GameLoop.getInstance().showAchievement( "Eat My Trail.", "10x Avoid Predator Using Panic Ability.", 250 );
					}
				}
				else 
				if ( !SwarmManager.getInstance().isPanic() )
				{
					GameVars.evadeWithoutPanicCounter++;
					trace("Evade Without Panic = ", GameVars.evadeWithoutPanicCounter);
					
					if( !GameVars.achievementWhoaThatWasCloseObtained &&
						GameVars.gameMode == 0 )
					{
						GameVars.achievementWhoaThatWasCloseObtained = true;
						GameLoop.getInstance().showAchievement( "Whoa!, That Was Close.", "Avoid Predator Without Panic Ability.", 300 );
					}
					
					if( GameVars.evadeWithoutPanicCounter == 10 &&
						!GameVars.achievementIAmGooodObtained &&
						GameVars.gameMode == 0 )
					{
						GameVars.achievementIAmGooodObtained = true;
						GameLoop.getInstance().showAchievement( "I...Am...Goooood!", "10x Avoid Predator Without Panic Ability.", 1000 );
					}
				}
			}
			else
			{
				if( m_retireTime > 0 )
				{
					m_clip.x += OpMath.cos(m_angle + 180) * (m_swimSpeed * elapsedTime);
					m_clip.y += OpMath.sin(m_angle + 180) * (m_swimSpeed * elapsedTime);
				}
			}
			
			m_position.x = m_clip.x;
			m_position.y = m_clip.y;
		}
	}
}