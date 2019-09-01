->escape

LIST Inventory = (knife), bow, sword, hat, coat, cup, firesteel, nice_sheath, flask

LIST Property = horse, boat

=== function listWithCommas(list, if_empty) 
    {LIST_COUNT(list): 
    - 2: 
        	{LIST_MIN(list)} and {listWithCommas(list - LIST_MIN(list), if_empty)}
    - 1: 
        	{list}
    - 0: 
			{if_empty}	        
    - else: 
      		{LIST_MIN(list)}, {listWithCommas(list - LIST_MIN(list), if_empty)} 
    }

=== escape 
# image bulrush # image river


   Dmytro lay hidden in the thicket far from the water, listening carefully to the nearby sounds. Pesky gnats needled his face and neck. A little further off on the shore, where the reeds gave place to steppe grass and sparsely growing trees, three men had settled near a fire. The runaway couldn’t see them, but he could sometimes hear fragments of their conversation and the clatter of provisions passed on by the wind. They were Tatars. Dmytro was trying to hear whether they were there for him.       


    The Cossack lay like this for a long time, covering his head with his hands until it was completely dark. The wind increased, blocking out all other sounds except for the haunting song of the rustling reeds. The wispy clouds were driven westward, creating a covering for the weak light of the crescent moon. Dmytro couldn’t wait any longer. He had to do something. Gripping tightly a good combat knife, the only thing he managed to take from the boat when running away, he slowly crawled to the path that led to the river. He waited a while before getting up and, trying to step as lightly as possible, made his way to the river. There was no one on the dark path. He squatted and started to drink the cold river water, cupping it in his hand. From time to time, the moon and the thick clouds reflected on the river’s service. Suddenly, a girl’s face was seen. The man sprang back and stared at the spot where he had seen the bright eyes of a young girl. But there was nothing there – only the moonlight that sometimes shone through the clouds. He crossed himself and went back, whispering a prayer. Then he turned and made his way to where the wall of reeds ended.      
   
    The runaway had to crawl once again since the river bank had risen. Suddenly, he spotted a solitary fire glowing in the dark sea of the steppe.  
    
    -> sleeping_tatars

=== sleeping_tatars
 
    = action 
    
    # image steppe
    
        In the rare times the moonlight was visible, it was possible to glimpse the silhouettes of people and horses. Two were sleeping on the ground facing each other. A third was sitting closer to the fire, leaning against a short spear and, seemingly, also sleeping. It was harder to make out the horses as they slept on the other side of the fire, but there appeared to be at least five of them.  

         Dmytro crawled to the nearest Tatar and quietly rose to his knees, ready to stick the knife in the Tatar’s eye if he moved. Nearby was a bow, a quiver with arrows, and a knapsack. 
    
        + [Take the bow, quiver and knapsack]->steal
    
        + [Look for a Tatar saber]->saber

    = steal
           # image bulrush # image river # image steppe
           ~ Inventory = Inventory + bow
        The Cossack didn’t dare to touch anything else and with his takings made the way back to the reeds and distanced himself from the riders, following the river upstream. 
             
        Farther away, a good range from the camp, there was small hill which revealed that in the back of the steppe there glimmered not one, but two fires. The second one was some distance from the river and it was hard to spot. There were more Tatars here than Dmytro thought. He moved on, keeping in mind there was little time. Soon, both fires disappeared in the fog. The first cold autumn night had come to the Wild Fields.  
            
        The reeds were replaced by grass, the grass by rocks, and the rocks by ravines. A lot of time had passed since the runaway had started his journey along the river bank. Having passed another hollow that led to the Dnipro, the Cossack set off into the steppe, away from the river. 
    
            {~ ->forest |->forest | -> forest |->encouner}
    =saber
    
            # image steppe
    
        Carefully placing these things to closer to him, Dmytro was on the lookout for the saber. It was nearby, taken off the hook, but the sleeper was holding it in his arms like a child his favorite toy.
    
            + [Try to pull it out] -> alarm
    
            + [Leave] -> steal
->DONE
            
=== alarm

    = kill
        # image steppe
         Dmytro held his breath. With a steady hand he grasped the saber and started to pull it out from the sheath, holding the knife in his other hand. The sleeping man turned on his side and abruptly turned back and opened his eyes.   
         
         The Cossack hit him with all his strength. The Tartar howled, twitched, and at last became silent. With a sharp movement, Dmytro pulled the saber from the hands of the dead man, grabbed his things, and stepped back into the darkness. From the fire, it was possible to hear an undistinguishable clamor of voices. He stopped and raised his bow and arrow, aiming at the strange shapes that glimmered in the light of the dying fire.     
         ~ Inventory += sword
        {~ ->awake|->sleep}
     
     = awake
            # image fight # image steppe
            
        A figure holding a spear stood up near the fire and started approaching through the clouds of smoke. Dmytro released an arrow. In response he heard the rustling of grass and then complete silence. The Cossack carefully retreated behind the river bank and quickly distanced himself from the camp. After some time, he climbed down the river bank to hide among the reeds, listening for followers. It seemed no one was following him. He then got back up onto the plain and set off into the steppe away from the river.
    -> forest
     
     
     = sleep
          # image river # image steppe

    Yet it was quiet in the camp. The figure near the fire continued to sit in the same place. Dmytro waited a little and, at last, walked away, trying to step as quietly as possible. Soon, he was in the open steppe, walking away from the river.
    -> forest
    // Розбудив татарина, намагаючись витягти шаблю вбити сплячого, вартовий рандомно прокидається або ні (розвилка), тікає до того ж лісу, якщо ніч з вогнем - на ранок оточують, беруть в полон, якщо без вогню - татарин на ранок не приїжджає
->DONE


=== forest
    # image forest
 
    Dmytro was walking among low-lying hills when he suddenly caught the scent of something burning. On one of the hillocks, he got a good view of the surroundings. There was no fire or smoke anywhere. However, in the distance he caught a glimpse of a copse of trees. The runaway headed towards the woods. As he did so, the smell of smoke became stronger. Up close, the wood showed signs of a forest fire – blackened tree trunks stuck out like poles, merging together and disappearing in the darkness. Behind the trees there was a slight hollow where a small brook flowed hidden from sight by several boulders the size of a horse-cart. The ground was covered by a thick layer of cold ashes. 

    The man settled near the boulder closest to the brook, holding the bow and arrow at the ready, and started to look through the Tartar’s knapsack.


    The first thing he found was a firesteel tied to a gray bag that contained pieces of flint and tinder from burnt rags. There was also some dried bread, several pieces of dried horse meat wrapped in sackcloth, a copper jug, and a scabbard for a knife or a dagger. The scabbard, made from rough leather, would have been a simple one if not for the moldings on it and the semiprecious stone at its center. There was no dagger in the knapsack. Since the knife that Dmytro had was too small for the scabbard, he put it back in the knapsack.
    ~ Inventory += (firesteel, nice_sheath, cup)

    Night air became bone-chilling.
    
    + [Set fire]->fireplace
    + [Look for other way to warm up]->coldnight

->DONE

=== fireplace
    # image forest

Dmytro didn’t have an overcoat so he went to gather burnt branches and placed them beside a boulder that had a flat vertical surface, turned inwards to the hollow where the brook ran. The Tartar’s tinder and firesteel had come in handy. The Cossack lit a fire, hoping that the hollow behind the bolder would help him hide the fire. The charred logs burned quickly and almost without any smoke, leaving behind glowing embers. In a small span of time, the Cossack had enough embers that he could start adding some bigger pieces of word to the fire. He found some twigs to create a makeshift bedding near the fire. Bringing some more logs to the fire, Dmytro spread the embers around the perimeter of the boulder. Worn and tired, he placed a jug with spring water right next to the fire to soften the dried bread and horse meat. The simple food and the warmth from the embers, which radiated from the tall boulders, finally warmed him up. The Cossack slept until dawn, waking up from time to time to add wood to the fire or to drink some water. At last, the sky was starting to clear up. A new day began. 
    
    {alarm.sleep : ->coldnight.move}

    The wind from the east brought some denser clouds that blocked out the sun, so the morning was cloudy. Dmytro woke up, as it seemed to him, due to some faraway sound. There was only a pile of ash left from last night’s fire, but the surrounding boulders still preserved some of the warmth from the fire, keeping the morning cold at bay. The Cossack got up quickly, grabbed the knapsack, the bow and quiver of arrows, and set off for the opposite side of the hollow. He then turned left and, making a wide circle, returned to the edge of the burnt forest, a little way off from the place where he had entered the forest.
    
    {alarm.awake : ->surrounded}
    -> ambush
    
=== surrounded
    # image forest
   
Dmytro was ten steps away from the forest when he heard the neighing of horses up ahead. Swift as an arrow, he hid in the nearby bushes, holding his breath and listening for any warning signs. Through the greenery he spotted that several riders had approached the forest. They kept a considerable distance between themselves and communicated by calling out to each other in muted low tones. One of them approached the place where Dmytro had been a few moments ago. One of the riders leaned in his saddle to take a closer look of something in the grass. He called out and the other riders retreated a little from the forest, maintaining the same distance between themselves.

The runaway slowly retreated into the woods, bending over and stepping as lightly as a lynx. Everything was silent for a moment when suddenly Dmytro heard rustling and the sound of twigs breaking. He froze in the clearing in the very center of the woods. Everything had been burnt to the roots here. Ravaged by the fire, only black tree trunks stuck out from the ground like poles. And yet, up ahead there was a thicket. Dmytro started running, but after a few steps he fell through into an ash-filled pit up to his waist. He got out of it and looked back at the traces left by his footsteps in the ashes. His pursuers were approaching. Dmytro felt as if he could hear their voices close by. In a couple of leaps, he was in the thicket. After the thicket, he found the familiar brook in the hollow. He jumped into it and ran in the direction of the current. As soon as the waterside started to jut out in the form a low cliff, Dmytro climbed onto it and ran until he came to a small chasm that was filled up with ashes, leaves and broken branches. To the left, where the brook changed its course, there were tall willows that seemed just within arm’s length.
    
     + [Climb on the tree]-> hide.tree
     + [Hide on the rock]-> hide.rock
     
-> DONE
    
=== ambush
    # image forest
 
Meanwhile deep in the woods, a Tartar looked at Dmytro’s footprints in the ashes. He then got up and took a good look at his surroundings. As much as Dmytro could see from his hiding spot, it was the very same Tartar whose things Dmytro had taken the night before. What’s more, the Tartar was by himself.


    + [Shoot a bow]->shoot
    + [Stay quiet]->stealth
    

=== shoot

    = ride
        # image fight # image forest
       
The Cossack nocked the arrow, drew the bow, aimed carefully and released the arrow. The Tartar made a noise and collapsed to the burnt ground. Dmytro waited for a while – nobody appeared. Then he carefully walked forward. The Tartar didn’t seem to be breathing anymore.
       
In a little bit, Dmytro emerged from the burnt woods donning a hat, a slightly bloodied overcoat, and a curved Tartar saber on his belt. Not far in the steppe there was a small stallion with a saddle. The Cossack approached him, whispering words that he had learned as young boy when caring for horses, and looked into the animal’s eyes. Not meeting any resistance, he quickly mounted the horse and galloped off into the distance. In a few minutes, rain started to fall from the leaden sky, slowly but steadily soaking the russet dried grass of the steppe. 

Dmytro rode through the steppe without stopping. Sometimes he changed directions as he approached the river, but as soon as he could see the shore, he turned to the steppe again. The rain fell without stopping, soaking Dmytro’s clothing and things. However, the sleep he had gotten the night before gave the Cossack strength, so he didn’t pay attention to such trifles. The steppe horse also proved to be a hardy creature, showing no signs of fatigue. With the new owner in the saddle, he galloped steadily into the unknown through the tall grass, wind and rain.  
        
        ~ Inventory += (hat, coat, sword)
        ~ Property += horse
            
        -> stream
        
    = stream
        
        # image bulrush # image river # image steppe

         {Property has horse:  Property has horse: The terrain became even more hilly, from place to place rocks emerged from the earth. Once again turning to the west, Dmytro rode to | approached} one of the cliffs. The river stretched out below, wide and calm, decked with reeds, boulders, islands and shrouded in fog. In the middle there was a large island, completely flat and covered with willows and shrubs. The dark silhouette of a small boat moved briskly against the current from the northern end of the island, gradually disappearing in the coastal thickets.
         
    Dmytro managed to {Property has horse: ride | walk} a little more until he approached a small stream which, however, ran down into a deep chasm, flowing down to the Dnipro River. Nearby, there was a barely noticeable trail that led downhill. {Property has horse: Dmytro got down from his horse and started the steep trek down the trail, guiding the horse by the reins.} The trail led to a wide clearing surrounded by willows and hidden by cliffs in the place where the stream joined the big river.
        //Козака бентежило якесь неприємне передчуття...
       //The Cossack had a bad feeling about something…

    +[Take a look at the clearing]->meeting
    +[Turn back to steppe]->runaway

=== meeting

    # image cossacks # image camp
   
   
Dmytro {Property has horse: released his horse and} set off into the thickets, keeping a vigilant eye on the surroundings. He had walked only a couple of paces when he heard the click of a gun being cocked behind his back. The runaway froze.
“What faith are you?” Said the voice behind him.
“The faith of the Rus,” Dmytro confidently replied and slowly turned around. Behind him stood two men, which had appeared from nowhere. Without the gun and sabers, and spear, he would have taken them for fishermen. 
“Cross yourself if you are a good man,” said another man. The runaway crossed himself three times.
“Let’s go,” said the one with the gun. He didn’t lower the weapon but inclined his head towards the willows. All three walked down the hill to the trees. The man with the spear threw a small bag onto Dmytro’s head that reeked of fish and pushed him in the back. 
“Go on, go on,” someone grabbed the runaway by the arm and led the way. They walked only a short while before Dmytro had to bend over and walk down some stairs. A door creaked. Someone pulled the bag off his head. They were in a long, shadowy cabin with an earthen floor covered by reeds. On the benches at a table of rough logs sat a large group of armed men. The light barely passed through the bottles inserted close to the ceiling of the earthen walls of the cabin. Dust and smoke circulated in the rays of light coming through the bottles. An icon of the Holy Virgin hung in the corner illuminated by a candle.

    Dmytro was questioned about his origins and whereabouts. He told them how he was captured along with other Cossacks by the Tartars at Cecora, how he was taken to Crimea, and about his escape at the crossing during the confusion that ensued when someone suddenly attacked the Tartars.
    
    All the men listened attentively. Then Dmytro was taken outside the cabin with the same precautions as when he had been taken in. He sat below a willow while the man with the gun guarded him. The runaway asked for some water. The guard carefully gave him a clay flask and allowed him to take a few sips. Soon about a dozen men emerged from behind the trees. Some of them Dmytro recognized from the earth cabin. A stocky man holding a long stick with a noose at one end stepped to the front of the crowd. “You are no captive Cossack, but a spy!”- He loudly proclaimed. The crowd shouted approvingly. The noose was thrown around Dmytro’s neck and he was pulled to the Dnipro. It was futile to resist and he almost had no strength left in him.

    When he was near the water, someone offered him to pray for the last time. The runaway started to say something when a strange noise came from the clearing. A man ran along the path, waving his saber and shouting something. Suddenly, he swayed, made a few hesitant steps and collapsed. A crimson stain was quickly spreading on the back of his shirt. Someone ran up to him from the crowd that had gathered near the shore. Several arrows whistled by and a gun had been fired somewhere close. The air was filled with smoke. People grabbed their weapons and ran down the path to the clearing. Dmytro was pushed out of the water and left lying on the shore.

    +[Hide in the reeds] -> avoidfight
    +[Follow the others] -> joinfight
   
=== backtocamp

    # image bulrush # image river # image fight # image steppe

    Dmytro turned back. {Property has horse: Soon he had to hurry and lead the horse by his side.}

    The sun had already started to set when Dmytro spotted a cloud of dust in the distance. Then the cloud was divided into several clouds, which, slowly floating, separated in different directions. One of the clouds was moving forwards, but after a while it changed direction. Dmytro managed to make out a horse without a rider, galloping at full speed through the evening steppe and soon disappearing over the hills.

    The familiar coastal cliffs appeared on the horizon once again. Hardly visible puffs of gray smoke rose from the valley where the river ran. Dmytro {Property has horse: left the injured animal in the valley and} carefully set for the coast, holding his bow at the ready. Having reached the valley, he turned to the right and climbed the hill that rose on the opposite side of the stream. Dropping to the ground, the Cossack peered over the edge of the hill. 

    Near the coast there was a great pile of smoldering black ash. The only remains of what appeared to be a shack. The smoke from it covered the valley like morning fog. A part of the reeds growing in the river was also burned. The clearing was littered with a motley of castoff objects and everything was densely covered with arrows: the ground, trees and smoldering logs. In the middle of this chaos, here and there, lay the bloodied mangled of Tartars. Dmytro counted six bodies. No one showed any signs of life. The valley was completely silent with the only sound the crackling of coal in the burnt shack.
    
    {Property has not horse: ->scavenge}

    The Cossack surveyed the silent clearing for a while. Not having seen anything new, Dmytro returned to the valley where he had left his horse. The poor creature was nowhere to be found. The man looked around and tried to call the horse quietly. It was as if the damn horse had vanished into thin air. Luckily, Dmytro had taken all his useful things with him, leaving nothing strapped to the saddle.
    
    +[Quit searching and go back to the camp]->scavenge
    +[Continue searching]->wolves
    
=== scavenge

    # image bulrush # image boat # image river # image steppe
    {Property has horse: Dmytro gave up on his useless search and returned to the camp.}
    ~ Property -= horse
    
    By the time he had stepped into the burnt and bloody ravine, twilight was already setting in. Dmytro carefully searched the place for signs that might explain what had happened or come in handy. He only managed to find a couple of intact bags of dried fish, fried millet and flour. A clay flask was lying on the ground near one of the Tartars that was lying in the middle of the clearing with a broken skull. The flask turned out to be tied to Tartar on a leather strap, thrown over the dead man’s shoulder. Dmytro couldn’t remove it immediately because the Tartar was lying face down with his arms wide open. The man took a knife and cut the leather strap. The flask was empty, so he went to the stream. There was a footbridge over the stream, so it was easy to get some water. From here, there was a trail that led further into the reed beds and tapered off to the side somewhere. Having filled his flask, Dmytro left it on the footbridge and went to see where the trail led to.

    
    The narrow trail twisted through the reeds and drew Dmytro closer to the cliffs. Eventually, it led to a small clearing on the shore. The reeds were carefully cut here, so that the passage to the Dnipro River was open. Closer to the clearing lay a tiny dugout canoe on the ground. A dark figure leaned over in the boat. Dmytro froze, then took a few careful steps forward. Half on the ground, half in the boat lay a Tartar without a hat and a cut throat. His blood had drained into the boat like wine into a goblet. The Cossack crossed himself, thought for a while, then pulled the Tartar out of the boat onto the ground. The dead man didn’t have any saber, knife, or even a bag. Dmytro overturned the boat, observing the crimson streams of blood, which trickled from the boat like snakes, then quickly headed back to the camp.
    ~ Inventory += flask
    ~ Property += boat

    +[Cast off to the island]->island
    +[Stay in the camp for a night]->stay

=== island

    = depart
    # image bulrush # image boat # image river
    
Almost in complete darkness, Dmytro set off from the shore in the small dugout canoe, loaded with the scavenged goods. He skillfully paddled with the paddle that he had found at the fire and steered to a small asymmetrical island in the middle of the Dnipro. This island was the closest one among a whole cluster of islands that formed a treacherous labyrinth of narrow straits and floodplains further up the stream.
    -> arrive
    
    = arrive
    # image bulrush # image boat # image river

Dmytro focused all his energy on paddling until the last rays of the sun glimmered on the glassy surface of the river. At that time, the stern of the boat had landed on the nameless patch of earth in the middle of the mighty river.

The island was heavily overgrown with shrubs. It took some elbow grease for Dmytro to pull the boat ashore. On the other hand, the thicket hid everything that was on the island from any onlooker on shore or in the water. {avoidfight: The fugitive surveyed the goods. Among the things, he found everything needed for life: food, cooking utensils, a wide knife, a firesteel, and even a pipe and a pouch tobacco.} To get to the middle of the island, which could have been about a hundred steps, he had to bend over and crawl through the thickets. In the middle of the island grew three ancient trees, so burly and thick that no bushes could grow in their vicinity. The ground was heavily covered with twigs and yellowed leaves. Dmytro dragged his {avoidfight: boat supplies | personal supplies} and quickly made a reed shack. Then he cooked some grain in a copper jug over a small fire. 
    
    By then, it was completely dark. The night turned out to be clear, warm and starry. Dmytro left his camp and went to the edge of the island opposite to the one where he had landed. Cutting the reeds, he found that passage to the shore was quite clear here. The thickets weren’t so thick and near the shore there were a couple of stone blocks that created a small shelter. Dmytro left his clothing on the rocks and carefully entered the cold water of the Dnipro. Having entered the river up to his waist, he stopped, admiring the reflection of the stars in the water. Suddenly, he seemed to catch a glimpse of that young lady underwater again. Dmytro shook his head – it was most likely his weariness getting the better of him. Despite the cold, the bath brought a sense of relief and washed away the dust of his recent adventures. Returning to the shack, Dmytro barely waited for the fire to die down and fell soundly asleep.
    
    In the morning, he quickly gathered, ate a little, and with the first light of dawn was already on the water. Up the current there was a network of straits and tributaries filled with countless small islands, and Dmytro hoped to continue his journey by hiding in the depths of this labyrinth. Currently, his goal was to cross the open space as quickly as possible before the sun had fully risen. Entering one of the straits, the runaway stopped paddling. The boat slid across the water without a sound. The current was much weaker here, so while the boat had stopped and started going backwards, Dmytro turned slightly and listened attentively. Then he made a couple of more strokes with the paddle, leveling the dugout canoe and guiding it forward. Repeating this movements many times, the Cossack slowly made his way through the thickets, trying not to lose his sense of direction. Even the current was no longer helping. In some areas it was hardly noticeable and in other areas the water seemed to move in a circle, pulling the boat into the center of the gyration. Suddenly, larger islands started to appear with patches of hard dry earth and even a couple of bushes. Dmytro went around these islands to the left, then to the right, until he approached a fairly large piece of land with several willows. The island was curved like a crescent moon, and Dmytro was approaching one of its tips while the other tip was visible from a distance. He led the boat to a small bay between the tips of the island. Dmytro surveyed the semicircle of the island’s sandy shore. At first, he didn’t see anything special, but a moment before he turned away something white flashed through the thickets. He vigorously paddled to turn back and surveyed the shallows once again. It seemed that in the depths of the island there was something white that resembled a piece of cloth tied to a tree or pole. 
    
    +[Land on the island] -> treasureisland
    +[Move along] -> skiptreasure
    
   ->DONE

    
=== stay
    # image bulrush # image boat # image river # image steppe 

The Cossack looked more amidst the fire in search of useful things, but finding nothing, he gathered some firewood and loaded it into the boat. He didn’t want to spend the night in a place of carnage, so he pulled the body from the boat to the clearing and decided to sleep near the boat. Putting a branch on the side of the boat, Dmytro created a small shelter in case of bad weather. He built a campfire, dined on what he could find in the camp, and lay under the boat.
   
It was at this time that another night set in at the Wild Fields. Dmytro couldn’t fall asleep. It seemed to him that he could hear the neighing of a horse up on the cliffs. He got up, took his weapons and set of for the steep hills bordering the Dnipro. There was nobody near the ravine, so he decided to walk further into the steppe. He reached the closest hill and tried to make out his surroundings as much as the shimmering moonlight would allow. 

    
    { not encouner: {~ ->fail|->encouner}}
    
    ->fail
    
=== fail

        # image boat # image river # image steppe

    Soon Dmytro reached a hill. There was a cold autumn wind; almost nothing was visible in the night haze. Making sure that there were no movements or fire nearby, he returned to his camp and finally fell asleep.

    In the morning, Dmytro paddled away in the dugout canoe. 
        
    ->DONE
    

=== coldnight

    = shelter
        # image forest
    
        
    Dmytro left the knapsack and went to the stream, where he could see small islands of vegetation that had managed to survive the fire. In a few steps, the quiet creaking of ashes beneath his feet turned into the rustling of fallen leaves. A little further, the stream flowed around a small spot of tall semi-dry grass. The Cossack got a knife and started to quickly and meticulously cut the grass, much as a reaper would gather a harvest of grain. Soon enough, he had a considerable heap in his arms. Dmytro carried it to his hiding place by the boulder and came back. In this way he cut the grass until he had cut down the whole patch. Then he took off his shirt, tied it into a knot and began to stuff it with leaves, trying his best to find the driest. It took a long time for him to carry the leaves, but at last Dmytro was satisfied with the result. A huge grass-covered pile had formed near the boulder. He shook his shirt, put it on, and climbed into the pile. He had warmed himself by carrying out this task, and now, laying in a pile of dry grass and leaves, he felt completely at rest. He ate a few pieces of dried bread from the Tartar’s knapsack and quickly fell asleep.

    The sun was already shining through the layer of leaves. Dmytro realized that he had missed the sunrise. He carefully peered out of the makeshift bedding and looked around. There was a perceptible silence in the burnt forest, broken only by the running stream. The Cossack stretched his legs and approached the stream, scooping some cool water in his hands and washing his face. After that he took off his shirt and placed it on a nearby stone to wash the ashes and remnants of leaves from his body. After the wash in the stream, he felt his strength and appetite returning to him. He drank some spring water and ate some dried meat and bread to satiate his hunger.        ->move

    = move
    
        # image bulrush # image river # image steppe
       
{alarm.sleep: But Dmytro slept all morning, regaining his strength. When he | When Dmytro} finally came out of the forest, it was almost noon. A lone tree stood on a hill close by. Its remoteness from the forest had saved the tree from the fire, although strands of scorched grass wound up all the way to the foot of the slope. Dmytro reached the hill. Having climbed to the top, he left some of his things on the ground and climbed the tree. The steppe was silent and empty. Taking a good look around, Dmytro climbed down and inclined his head thoughtfully. Suddenly, he got up, grabbed his bow and the rest of his things and hurriedly made his way to the next hill.
        -> hill

    = hill    
       
Despite it being the beginning of autumn, the sun was still scorching, but Dmytro moved quickly. A wide lowland stretched beneath the slope. On the opposite side there was a valley overgrown with reeds, which twisted like a snake in the direction of the Dnipro. The lowland itself was leveled and flat like a plate, but in the middle, there was gray boulder with sharp edges. Between the hill and the valley, a cluster of trees and bushes grew in the form of a dark green stain. Another dark and almost circular stain was visible near the foot of the boulder. From his vantage point, Dmytro could make out several dark points on the ground. From one of them, a hardly visible gray thread rose into the air, swaying ever so slightly although there was no wind. 

Dmytro had come here on instinct and was forced to catch his breath from surprise. The feeling of surprise quickly passed as he scrutinized the terrain below. The lowland was empty. 
    
He slowly descended from the hill, keeping the view below in sight. Soon he was standing near the recently extinguished fire, studying the tracks of the camp that had stood here yesterday. There were a few people, maybe around ten. They had come on foot from the north and, having spent the night here, set off for the valley.

There was a narrow path winding along the slope of the valley and disappearing in the reeds. There was a stream at the bottom. The path came up from the valley from time to time and Dmytro glimpsed the endless terrains of the Wild Fields. Evening was setting in.
        
Dmytro emerged from the valley and soon found himself near the Dnipro. 
    
    -> shoot.stream

    ->DONE

=== runaway
    = think
        # image steppe
       
       Dmytro hesitated a bit, but eventually turned back and walked away from the uncertain valley.  
    { Property has horse: -> brokenleg | -> walkaway}
    
    = brokenleg
        # image steppe
        
He had not gone very far when he came across a dried-up shallow riverbed, bordered by rocks. His horse jumped over it without stopping, yet after a while Dmytro noticed that he was limping on his right leg. Dmytro stopped and examined his horse. At first glance, everything seemed to be alright, but the horse needed to get some rest. He sat on a rock, letting the horse graze nearby, and looked around.
    -> seesdust
    
    = walkaway
      # image steppe
      
Dmytro walked for several hours before stopping on a hill to observe the surrounding terrain.
    -> seesdust
        
    = seesdust
  # image steppe 
  
The steppe was empty on all sides. But when Dmytro turned around he saw dust rising from the valley that he had just left. Very soon, clouds of smoke joined the dust rising into the air. The runaway heard several sharp sounds in the distance. There was some sort of fight down below.

+[Return to the camp] -> backtocamp
+[Move along] -> loosehorse


    ->DONE
    
=== joinfight

    # image cossacks # image fight # image camp

    The noise of battle didn’t subside. On the right side of the river, the reeds caught fire.

    Dmytro gathered the last of his strength, got up and went in the direction of the clearing. He stopped near the dead man that was lying near the edge of the trail and picked up his saber. When he came out into the open, everything was covered in smoke, with arrows sticking out in different places. The main fight seemed to be somewhere up front. Suddenly, from behind the gray veil of smoke, two Tartars ran directly toward Dmytro. At the same time, something exploded near Dmytro’s left hand. He heard the whistle of artillery, and both of the Tartars fell down, struck by the pellets of a small canon. Dmytro ran forward and saw an opening on the side of a nearby hill from which smoke was coming from. Without stopping to look around, he entered the thick of the battle. At this very moment, the Cossacks were gaining ground on the Tartars, with the latter retreating towards the stream. A little longer and the Tartars were fleeing, sending volleys of arrows from hillsides to the valley. But soon the Cossacks overtook them, and the shooting stopped.

    Somewhere above, gunshots still rang out, signaling the pursuit of the fugitives, but in the valley everything was quiet. The silence was broken by the moans of the injured that lay in the russet grass in puddles of blood. Surprisingly, there were no Cossacks among them. For a while, Dmytro stood to the side of the clearing, holding his bloodied sabre, until other Cossacks started to approach him, covered in dust, sweat and blood. One of them sat on the ground, catching his breath, another stood nearby, leaning on his rifle and looking up at the sky, another kindled a fire and lit his pipe. All were silent.
    
    The Cossack that had interrogated Dmytro at the earthen cabin approached the clearing. He asked if anyone had been injured or killed. A few names were mentioned. He shook his head and ordered everyone to gather near the river. Then he turned to Dmytro: “So you didn’t run away? That’s good…We will decide what to do with you.” And he went to talk to the others. The group disbanded. The Cossacks walked along the valley, looking for their comrades, helping the wounded, and getting their things in order. Some of the dead were brought to the clearing and placed beneath the willows. They didn’t touch the dead Tartars, but only took their weapons. 
    
    Soon, everyone had gathered on the shore at the same place where they had come to drown Dmytro. Their otaman, the leader of the Cossacks, proclaimed that they would have to burn their outpost since the Tartars had learned about it. He ordered the Cossacks to prepare to leave and board their boats. Then he reminded the warriors about Dmytro. They were keeping an eye on him, but not with such hostility as before. Dmytro stepped forward and faced the Cossacks. “Did anyone see how this man fought in battle?” Asked the otaman. Several of the Cossacks nodded in agreement. “I also saw… I wouldn’t want to lose such a good swordsman. So, should we ask him what fate he wants for himself?” The warriors shouted approvingly. “Tell me what you want to do next,” the otaman turned to Dmytro.  

    +[Ask to join in] -> staywcossacks
    +[Ask to let leave] -> letmego

    ->DONE
    
=== avoidfight

   #image bulrush # image boat # image river # image cossacks # image fight
    -> island.arrive
He mustered his last strength to get up, cast the noose off his neck and started to run along the hardly visible coastal trail, away from the camp. The trail meandered among the reeds, yet in time it brought him to a hidden clearing where a small dugout canoe stood, packed with belongings. Not taking the time to think, the runaway jumped into the water, pushed the boat out of the shallows, and, grabbing one paddle, put all his energy into steering the boat far away. 
-> DONE
    
=== hide
    
     = tree
        # image forest
Dmytro approached the edge of the cliff and jumped onto the willow. Deftly clutching the branches, he had managed to land right where the tree trunk split in two. He had settled so comfortably in the tree that he could aim his bow from both sides. Having hidden himself as well as he could, Dmytro listened to the sounds around him. For a very long time the only sounds he could hear were those of the wind, falling leaves and the murmur of the stream. Suddenly, a branch cracked on the ground. A little later, there was some sort of rustling. The Cossack couldn’t see well through the hanging branches with the yellowing leaves, but he understood that two Tartars had approached the opposite shore of the stream.
        -> hiding
    
     = rock
     # image forest

    Somewhere behind the cliff sounded the rustling of leaves and a branch broke. The runaway immediately fell onto the rock and flattened himself against it. Somebody approached the stream. He now detected somebody’s steps in the rustling and cracking of the vegetation. Dmytro carefully surveyed the clearing below. Several Tartars emerged from behind the burnt trees and went up to the stream.
    -> hiding
     
     = hiding
     # image forest

    One of them approached the stream and squatted to fill up his flask with water. Dmytro got a good look at him from his perch in the tree. Holding his breath, the runaway observed the Tartars and tried to guess what they would do next. The Tartars drank some water and, apparently, weren’t in a hurry to move on. One of them walked along the stream in search of tracks and the other stayed in the same spot and surveyed the area. It soon became clear that there were other Tartars close by. Dmytro managed to make out that the one who was walking around made some signs with his hands. After a while, the Tartars moved on, but they soon returned from another side. 
        
       Dmytro sat {hide.tree: in the tree | on the cliff} until evening. The Tartars continued to sweep through the forest, appearing next to stream and then moving on again. By the time dusk had set in there was a lot of them. They kindled a fire in the clearing opposite the {hide.tree: tree, on which | cliff, on which} the Cossack had hid away on and busied themselves by setting up for the night. 

    Through the bubbling of the stream, the runaway heard their conversations and smelled the scent of food coming from the camp. Earlier, when there was nobody around for a long time, he had eaten some of the food from his knapsack, but now he was once again reminded of his hunger and thirst. What’s more, with the twilight setting in, he felt an unpleasant damp coolness return to the forest. Dmytro tried to sleep a little.

    The camp became quiet after midnight. The runaway waited for a long time to make sure that nobody, except for the two Tartars on the lookout, was wandering near the stream. At last, even the two sentries walked away from the stream and sat closer to the warmth of their campfire.
        
        +[Try to escape]->nightchase
        +[Keep hiding]->coldnest
     
->DONE

=== stealth
TO BE CONTINUED...
        
       -> DONE
     
=== staywcossacks
    
    =longway
    
         # image cossacks # image steppe # image forest # image camp
    
        TO BE CONTINUED...
        
        -> hermit
        
        = hermit
        # image cossacks # image forest
        
       TO BE CONTINUED...
        {~ -> question | -> leave}
        
        
    = question
        # image cossacks # image forest

    TO BE CONTINUED...
        
       -> DONE
    = decline
    # image cossacks # image forest
    
   TO BE CONTINUED...
        
       -> DONE
        
        
    = leave
        # image cossacks # image forest
    
   TO BE CONTINUED...
        
       -> DONE


-> DONE


=== nightchase
       TO BE CONTINUED...
        
       -> DONE
       
       
=== encouner
TO BE CONTINUED...
        
       -> DONE

=== wolves
# image tobecontinued
    ДАЛІ БУДЕ...
    ->DONE
    
    
=== loosehorse
# image tobecontinued
    ДАЛІ БУДЕ...
    ->DONE
    
=== treasureisland
TO BE CONTINUED...
        
       -> DONE
       
=== skiptreasure
TO BE CONTINUED...
        
       -> DONE

=== coldnest
# image tobecontinued
    ДАЛІ БУДЕ...
     ->DONE
     
=== letmego
# image tobecontinued
    ДАЛІ БУДЕ...
-> DONE

=== staywithhermit
# image tobecontinued
    ДАЛІ БУДЕ...
-> DONE

//# image bulrush # image boat # image river # image cossacks # image fight # image steppe # image forest # image camp