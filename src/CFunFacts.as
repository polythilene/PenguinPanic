package  
{
	import com.shade.math.OpMath;
	
	/**
	 * ...
	 * @author Wiwit
	 */
	public class CFunFacts
	{
		private var m_facts:Array;
		
		public function CFunFacts() 
		{
			initialize();
		}
		
		private function initialize():void
		{
			m_facts = new Array();
			
			m_facts[0] = "Adelie penguins are powerful swimmers. They can jump straight out of the water onto the land and love to sled down icey hills on their bellies.";
			m_facts[1] = "The Great White shark can last 3 months without food.";
			m_facts[2] = "Sharks have more than six and a half tons of biting force per square inch.";
			m_facts[3] = "Although people have painted sharks as man eating monsters, each year more people are killed by dogs, pigs, and deer than sharks.";
			m_facts[4] = "Antarctic krill is the keystone species of the ecosystem of the Southern Ocean, an important food organism for penguins, whales, and seals.";
			m_facts[5] = "Antarctica is colder than the Arctic since many parts of the Antartica are more than 3 kilometres (2 mi) above sea level - temperature decreases with elevation.";
			m_facts[6] = "Antarctica is colder than the Arctic -- the Arctic Ocean covers the north polar zone, and the ocean's relative warmth is transferred through the icepack and prevents temperatures in the Arctic from reaching the extremes typical of the land surface of Antarctica.";
			m_facts[7] = "Antartica is a landmass made up of ice and rock, about 1.3 times as large as Europe, making it the fifth-largest continent on Earth.";
			m_facts[8] = "Antartica has about 90 percent of the world's ice, and thereby about 70 percent of the world's fresh water. If all of this ice were melted, sea levels would rise about 60 m (200 ft).";
			m_facts[9] = "Penguins have a gland in their nose that takes salt out of the ocean water.";
			m_facts[10] = "Leopard seal has an unusually loose jaw that can open more than 160 degrees, allowing it to bite larger prey.";
			m_facts[11] = "Sharks are a group of fish that feature a completely cartilage skeleton. They have no bones like humans but their hard bodies are made of cartilage like we have in our noses.";
			m_facts[12] = "The main predators on Adélie penguins are leopard seals, which attack adults in the water.";
			m_facts[13] = "The name krill comes from the Norwegian word krill meaning \"young fry of fish,\" which is also often attributed to other species of fish.";
			m_facts[14] = "Krill tastes salty and somewhat stronger than shrimp. For mass-consumption and commercially prepared products they must be peeled, because their exoskeleton contains fluorides, which are toxic in high concentrations.";
			m_facts[15] = "Modern anchors usually are made of forged steel and may weigh thousands of pounds.";
			m_facts[16] = "Adelie penguins spend most of their life in the sea and on icebergs, coming ashore only to breed in rocky, open areas free of ice.";
			m_facts[17] = "Jellyfish have little nutritional value. Their stings can be painful, and a few tropical forms can be deadly to humans.";
			m_facts[18] = "Seven nations claim territory in Antarctica. They are Argentina, Australia, the United Kingdom, Chile, France, New Zealand, and Norway.";
			m_facts[19] = "Box jellyfish are best known for their extremely powerful venom, although some marine species (such as turtles) are immune to it and known to feed on jellyfish.";
			m_facts[20] = "A fun thing to do in someplace as cold as Antarctica is to throw hot water into the air. As the 100-degree (Celcius) water meets the cold, in this case -32C air, it instantly vaporizes.";
			m_facts[21] = "In the winter, Antarctica is known to double in size due to the sea ice that forms around the coasts.";
			m_facts[22] = "Leopard seal is the apex predator around the Antarctic waters, comparable only to the killer whale.";
			m_facts[23] = "The Great White shark is the only survivor species of its genus, Carcharodon. The genus name comes from Greek words \"karcharos\" which means sharp or jagged, and \"odous\" which means tooth.";
		}
		
		public function getFact():String
		{
			return m_facts[ Math.round(OpMath.randomNumber(m_facts.length-1)) ];
		}
	}

}