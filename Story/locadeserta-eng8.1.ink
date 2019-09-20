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
     
=== staywcossacks
    
    =longway
    
         # image cossacks # image steppe # image forest # image camp
The runaway asked to stay with the Cossacks for a while. The warriors didn’t object to this and the gathering dispersed. The camp stirred – people carried things, rolled barrels, collected weapons, pulled the boats from their hiding places on the shore. Everyone was preparing to set sail. 

Dmytro was approached by a short broad-shouldered man. He was called Ustym and he said that he was looking for volunteers to help transport two heavily injured warriors to a safe place. He hinted that Dmytro could help since he didn’t have any matters to attend to at the camp. The runaway agreed and they walked to the edge of the clearing where the injured lay beneath the willows. Not far away, one of the dead was being buried, his tomb already covered with heavy earth and stones. Close by on the trunk of a willow somebody had carved a wide cross, which was the only sign of mourning for this Cossack’s sad fate.

 
 Two more volunteers approached, Ohrim and Ivan. Ustym decided that the four of them would manage on their own. He said that the journey wasn’t a long one.

They found a horse to transport the wounded, but there was no cart in the camp since the warriors mainly used boats to move along the river and rarely went out into the steppe to the Tartar coast. So Ustym brought axes and the team started to build a sledge that could be pulled by a horse. One of the volunteers – Ivan, as it turned out, was once a tinsmith, and he quickly created a harness from some ropes, belts and parts of old harnesses. Dmytro had his doubts whether the horse would pull the harness, but the beast turned out to be surprisingly docile when harnessed, obediently pulling the load.

The Cossacks hadn’t prepared for departure yet, but the wounded had to be taken away as quickly as possible. Sunset was quickly approaching and those who would transport the wounded couldn’t afford to set up camp on the road. The Cossacks agreed to leave a boat for the four volunteers, which the latter could use to catch up with the warriors on some shore that only Ustym knew about. Having finished their meeting and carefully placed the wounded Cossacks in the sledge, the volunteers set off. It was difficult to make their way out of the valley. In some places, they had to carry the sledge with the wounded in their arms. At last, they made it to the lowlands and quickly set off along the Dnipro, which though not visible, made its presence known by the rippling of the waves and the rushing wind.

Ivan led the horse and the others walked beside him. They all had sabers and bows while the wounded in the sledge had a loaded rifle lying next to them. From time to time, Dmytro gave the wounded some water to drink. The group tried to move without as quickly as possible without taking breaks. The sun was already setting over the Dnipro when the Cossacks reached the steep path leading into a valley. The lowland, however, was quite far away, covered in an ancient oak forest. The tops of the trees weren’t even visible from the level steppe. All around, fairly large boulders protruded from the ground. When the travelers entered the forest, the boulders increased in size, laying among the trees in a blanket of bright green moss. Moving around, surprisingly, wasn’t difficult since there was almost no shrubbery in the forest. The even ground was covered with a deep layer of leaves and there was a good distance between the trees and boulders. However, with time, the valley started to narrow and become steeper when, finally, the travelers found the themselves at the bottom of a deep ravine covered in dense thickets. At their feet warbled a small stream. 

Ustym made a sign that they should stop. The group listened to the rustling leaves and the howling wind in the ravine. “Stay near the sledge, boys,” Ustym told Ivan and Dmytro, “We will see what’s out there.” Ohrim took the rifle and they both disappeared in the thickets. 

Dmytro, Ivan and the two wounded warriors waited an hour for the Cossacks to return. When Ustym and Ohrim finally returned they were in a very good mood and seemed to be in no hurry. “Will we spend the night here?” Dmytro asked. “No, we are almost there,” replied Ustym, “Only the horse won’t go any further.” Indeed, as they moved forward, the shrubbery became so thick and tangled that it was hard for even one person to make it through. They stopped at a clearing surrounded by thickets on all sides. A semicircle of trees grew in the clearing, covering the passageway. Beneath the trees was a fire pit from rough stones and the remnants of some makeshift shelter. Ivan tethered the horse to a tree and the men carefully transported the wounded unto the grass. Using some pieces from the sledge, they quickly put together two litters for the wounded and continued their journey to the mysterious refuge on foot.
     
They scraped their way through the thickets, climbing between boulders that were almost close enough to crush the Cossacks with their weight. The tiny stream had long become their only source of direction. Finally, the passage widened a little but and the travelers entered a clearing that was a little bigger than the previous one, also surrounded by a wall of thickets. The stream ran adjacent to the clearing and seemed to come from a small cliff that hung over the ravine.
       “We’ve arrived,” Ustym said at last. The men stopped and put the litters containing the wounded on the ground.
        
        -> hermit
        
        = hermit
        # image cossacks # image forest
        
The leader of the group came into the center of the clearing and made a sign with his hand, facing some blackthorn bushes. Having seen the sign, a tall elderly man emerged from the thickets. He had a beard and was dressed in shabby clothes. He had a large wooden cross on his neck. He looked like a hermit, but his garments were those of a Cossack and he had a pipe in his mouth. The bearded man had a bear spear in his hand that he leaned on as he would on a bishop’s staff. He walked past Ustym and, without saying a word, approached the wounded and bent over their litters. One of the men was conscious. “I see your death,” the old man muttered to him. “Your death is at your feet. It means you still have work to do in this world.” He stood up straight and went back into the shrubbery. The Cossacks picked up the litters and followed him.

A small hillock hid among the thickets. It turned out to be the entrance to an earthen cabin whose door was set deep in the earth, facing the cliff where the stream bubbled from. The bearded man opened the door and disappeared in the darkness. He came back with a burning candle in his hand and beckoned the Cossacks to carefully carry the wounded inside. The Cossacks carefully carried the litters down the narrow steps.
     
There was a whole cabin inside, containing several rooms and a clay stove, with tiny windows that were hardly noticeable from the outside. “Our men will come back soon. For now, fill up the barrel with water. It’s near the entrance along with a couple of pitchers,” the old man said.

While the Cossacks carried water, the bearded man tended to the wounded in a separate room. In a while, he went out and called the group to gather near the table. The travelers brought with them some goods from the camp. They gave them to the hermit.
       
After a quick meal, the old man asked: “Will you spend the night in my home? It is already dark outside.” “We kindly thank you, but we left our horse in the clearing. We will spend the night there,” one of the Cossacks replied. The hermit nodded his head in understanding.
        
        {~ -> question | -> leave}
        
        
    = question
        # image cossacks # image forest


“Maybe one of you will stay to help me? My strength is not as it was before. It would be good to have a second pair of hands to look after the boys,” continued the hermit. The Cossacks exchanged glances. “There are few people in the camp, we must return. Maybe Dmytro could stay? He has just joined us,” Ustym replied. Dmytro thought what to do. 
        
        +[Stay with the hermit] -> staywithhermit
        +[Decline and return with the others] -> decline
        
    = decline
    # image cossacks # image forest
    
“I’m sorry, but I also have to go back,” Dmytro replied at last. “No means no,” sighed the hermit, “I will manage. Just bring me some more gunpowder. In two weeks.” The Cossacks exchanged surprised glances, but Ustym nodded calmly in reply. 
    ->leave
        
        
    = leave
        # image cossacks # image forest
    
The Cossacks approached the clearing at midnight, prepared makeshift beddings and gathered near a bonfire. “Who was that man?” Asked Dmytro, curious about the hermit. “Blackthorn…” Replied Ohrim, lost in thought. “Which blackthorn?” Asked Dmytro, not understanding. “The old man’s name is Blackthorn,” explained Ustym and added, “He’s one our best healers and soothsayers, though an old one now.”
 
The men woke before dawn to get back to their camp as quickly as possible. Without their wounded comrades, they moved much quicker and were back at the clearing as the sun was rising. They quickly found the boat and provisions hidden in the reeds. From another hiding spot, Ivan brought out his saddle and harness. “The four of us and our provisions won’t fit in the boat. I will take the horse and ride to the crossing further up the stream. I will join you at the camp on the other shore,” he explained to them energetically. It was obvious that this plan had not been discussed before, but they also didn’t want to leave behind the horse and some provisions. Ustym somewhat reluctantly agreed.

They set off at noon, keeping close to the shore and paddling against the current towards the labyrinth of small islands, hidden among the reeds.
    
 Ustym steered the boat along the narrow straits. For a while, Dmytro thought that they were lost, but finally the boat landed on one of the islands. Ustym told them to wait in the boat while he went on the island, carefully parting the reeds to pass through. He returned fairly quickly with a small chest in his hands, which was added to the other cargo in the boat. Without wasting time, they continued to move on. It seemed that the labyrinth of reeds was endless, but Ustym confidently steered the boat and, finally, close to dusk, their boat slid through the open water and in a couple of hours landed at the opposite shore. Here, among cliffs and thickets, was a comfortable passage to the shore. There was a deafening silence in the air and the shore seemed completely uninhabited, but as soon as the travelers stepped on land, they were surrounded by their fellow Cossacks. 
    
    -> winterstay
    
    = winterstay
# image boat # image river # image cossacks
In three days, the group reached the bleak cliffs that rose high above the Dnipro River, so steep that they seemed like great walls reaching towards the sky. The boat that was in front approached these stone giants and suddenly disappeared from sight. And after this boat, the next one vanished as well, and the one after that. When Dmytro’s boat reached the same cliff, he realized that it wasn’t solid. A massive boulder jutted out into the main body of the river, creating a narrow passage, behind which a peaceful stretch of land was safely hidden. In a while, the whole group had disembarked on the mysterious shore.

Higher up on the shore was a forest full of ravines and gullies, behind which a small river ran its course into the majestic currents of the Dnipro. 
    
When the greater part of the Cossacks had gathered near the edge of the forest, surveying the surroundings, the leader of the group confidently proclaimed: “We will spend winter here!” {joinfight: After these words, a man with a horse emerged from the depths of the forest. Some of the men grabbed their weapons, but to everyone’s surprise it was Ivan, coming to join them.}
    
     {joinfight: Happily greeting their comrade, the Cossacks | men} started to unpack the boats.
    
    # image theend
    The End of Chapter One
    

    -> DONE


-> DONE


=== nightchase
       # image steppe # image forest

     
The rain quickly became a real downpour. Heavy cold drops forcefully hit the ground, shrubbery and the nearby cliffs. The wind howled, rattling tree branches and scattering leaves on the ground. {hide.tree: Dmytro shivered from the cold and exhaustion when he carefully, like a cat, climbed down to the ground. He managed to get back to the rocky outcropping. | Dmytro slowly got up, trying his best not to shiver.} He turned back to the forest under the cover of rain and darkness, following the path he took yesterday, walking around open clearings and keeping away from the stream. Close to the very edge of the forest he caught a glimpse of a fire up ahead. Dmytro turned in another direction, away from danger, until he made his way to a cluster of thickets on the edge of the open steppe. He was drenched to the skin and rivulets of water ran down his body. His clothing was heavy from moisture and his body – from exhaustion and hunger. At the same time, he was terribly thirsty. He squatted beside a shrub and greedily drank the droplets of water running down one of the branches. He then got up and grimly walked straight into the dark sea of cold steppe grasses. The rain continued falling. Dmytro completely lost track of time, slowly making his way forward through the Wild Fields. A small part of the steppe, which he saw in front of him, seemed to always look the same. At last, he began to see some small potholes, filled with water, and in time, behind the veil of rain and darkness, he glimpsed the downward slope of a valley. Walking downward, Dmytro slipped and tumbled to the very bottom of the valley. For a while he lay in the mud without moving. His head was spinning. The runaway tried to get up. It seemed that his bones weren’t broken, but he was quickly losing strength. The Cossack limped further down the valley, staggering like a drunk man. The stream near his feet had soon become a muddy and fast-running broad current that bubbled like a mountain river. Dmytro seemed to make out a tiny trail that led up the valley. When he had climbed up the slope to a landing, the downpour had subsided somewhat. However, the wind seemed to become stronger, blowing towards Dmytro moisture from the storm and heavy swaths of fog. It was starting to get lighter and Dmytro made out a dark shape on the hillock ahead of him. He used his last strength to trudge to the spot, his legs almost giving out. The shape turned out to be a small cave on a rocky outcropping. The entrance to the cave was wide but rather low. Not analyzing what he was doing, Dmytro fell onto the earth and crawled into the cave. Inside, it was surprisingly dry, but the space inside was small and narrow like a coffin, the ground covered in a thick layer of dry grass. Dmytro turned on his back and either fell asleep or lost consciousness.
      
      {hide.tree: -> wakehermit | -> captured}
      
=== wakehermit
      # image forest  # image tobecontinued
      

{captured: He realized that he was alive when he regained consciousness and felt a sharp pain in his legs. The hellish pain was slowly subsiding. | The Cossack woke from the smell of food. His head was aching, as if after a night of revelry. His felt as if every bone in his body was broken.} He tried to open his eyes, but he saw only a mixture of colors. Dmytro felt his head spin from the warped image, but he kept on looking until his sight slowly focused. Gradually he saw where he was. It was a small room with a low smoke-stained ceiling. Dmytro tilted his head to the side to get a better look at his surroundings. Suffering from another spell of dizziness, he made out a table close to the bed, covered with a variety of bottles and cups. {captured: Suddenly, his legs were again needled with pain. | A candle was burning down on the table and steam rose from a clay bowl, spreading the pleasant aroma of fish soup. Dmytro tried to get up, but he couldn’t even move his hand.} He wanted to scream from despair, but he could only manage a low moan. The door creaked and a tall elderly man entered the room. He had a long beard, worn clothing, and a large wooden cross on his neck. 
    
    To be continued…
     ->DONE
     

=== encouner
    # image steppe
   Dmytro noticed that something was moving towards him through the inky darkness. He stopped and raised his bows, peering at the ghostly silhouettes. There were five to six wolves running through the steppe straight towards the Cossack. They were almost invisible, only dark stains on the background of dry russet grass. Only their eyes, as they approached Dmytro, betrayed their real nature, glittering in the weak light of the moon. 

    The wolves were about forty paces away from Dmytro when they stopped, formed a line, and surveyed the newcomer. 
    
    + [Shoot the nearest wolf]->fight
    +[Talk loudly]->talk
->DONE

=== talk
   # image steppe # image forest
   
   Dmytro spoke to the shaggy beasts in a loud yet calm voice, urging them to move on. He added some shamanic proverbs and proclaimed that he had no bad blood with the wolves in this steppe. The wolves seemed to listen attentively but continued to stand their ground. When everything was completely silent, the biggest wolf approached Dmytro. Two others joined him. The Cossack slowly made a few steps backwards without turning, lowering his bow. The wolves slowly loped past him and disappeared in the darkness. The three who had stayed behind, ligered a little, but then also took off into the distance.

  Dmytro crossed himself and caught his breath. His heart was beating like crazy. Very soon, however, he had calmed down and continued his journey in the direction from which the wolf pack had come from.
    
    { not stay: ->forest}
    
    ->fail
    
->DONE

=== fight
    # image fight # image steppe
    
Without thinking too long, Dmytro shot the shot the closest wolf, but the arrow only slipped through the wolf’s fur and landed in the tall steppe grass. In two leaps, the wolf was very close to Dmytro, baring his long fangs. Dmytro grabbed his knife, but another wolf was already biting his leg. Then both wolves slightly retreaded. The pack circled around the runaway, making advances to bite him again. The second time, Dmytro managed to shoot down one of the wolves and, immediately, the whole pack attacked him.

A Tartar cavalry unit was making its way through the morning steppe. There were several horsemen in front of the rest of the cavalry, riding forward and gathering the cold morning dew. They moved slowly, surveying the terrain for any tracks. Suddenly, they stopped. One of the warriors dismounted from his horse and walked to side to take a closer look at the grass. For a while he looked at his finding and then picked something up and returned to the others. Back in the saddle, the tartar called out to one of his companions and, having reached him, showed him a knife, covered in a thick crust of blood. His companion was surprised to see the familiar knife and turned the weapon in his hands until the cavalry unit once more set off.
# image theend

The End

->DONE

=== skiptreasure

    = main
   # image bulrush # image boat # image river # image cossacks # image camp

    Mulling over for a while, Dmytro decided to not waste time on the mysterious island and continued his journey.
    
   The runaway entered another tributary of the river, incredibly long, like a river or a channel. It gradually became narrower, making a sharp bend at the end, and becoming hardly big enough for the boat to move through. On the left side, there was a fairly large plot of land with a good smattering of trees and reeds. The reed thickets stretched for at least ten paces between the trees and the water. Dmytro couldn’t find a clearing by which he could approach the island. Suddenly, from behind him came a long shadow and he heard water splash. The Cossack immediately understood that another boat was approaching through the thickets behind him. Dmytro paddled with all his strength, not even looking back, but far ahead of him another boat emerged from the reeds and blocked the tributary. It was then that Dmytro noticed a clearing in the reeds that led to the island. He directed his boat that way and soon landed in the shallows. Several armed men immediately appeared on the shore. One of them told Dmytro to get out of the boat and come on land.
    
    {avoidfight: -> samecossacks | -> meetingcossacks }
    
    = samecossacks
    # image bulrush # image boat # image river # image cossacks # image camp
   
   He wasn’t even surprised that he recognized some of them. Fate had once again led him to the Cossack fishermen. After battle, they had left their camp on the Tartar coast and retreated to this island. Their boats were hidden along the perimeter of the island. It appeared that the whole unit had settled on this island. 
  The runaway was again brought before the leader of the group. Dmytro had a feeling that he wouldn’t be able to escape the second time but help arrived from an unexpected place. A large boat approached the island. The Cossacks in this boat looked refreshed and full of energy. They also had better weapons. They embarked ashore, carrying a large oaken chest among them. Dmytro was escorted away from this new group, but, suddenly, one of the newcomers stopped. “Dmytro?” He asked, surprised, “Dmytro from Bila Tserkva? I though you had died at Yasy! What a meeting!” Dmytro cast a glance at his guards. “How do you do? I also remember you, Stepan! As you see, I ran away from the Tartars, but my Christian brothers almost drowned me.” He clearly remembered this young man who had once persuaded him to leave behind the registered Cossacks and set off for the Wild Fields. They were from the same region, from the Bila Tserkva subdivision. They had met during service and had good relations, but Stepan quickly disappeared after taking something from the treasury. “Good God!” Proclaimed Stepan and went to the center of the island with the others without saying anything more. Dmytro, however, wasn’t led any further but left to sit on the ground under the watchful eye of one of the Cossacks. Soon, Stepan returned and, smiling, said: “I put in a word for you. No one will try to drown you anymore – you can be sure. But come with us to the winter camp. There will be a big war with the Turks. We need manpower.”
        -> staywcossacks.winterstay
    
    -> DONE
    
    = meetingcossacks
    # image bulrush # image boat # image river # image cossacks # image camp
  
   He was brought into a small tent under some willows in the middle of the island. In the tent there was a man {avoidfight: already familiar} sitting on a barrel. He was short and simply dressed, with a scar covering half his face. A pipe rested between his lips. There were two Cossacks sitting near the entrance on a bedding of hay, talking energetically among themselves and smoking their pipes. Aromatic smoke rose to the top of the tent, winding in fanciful loops and pouring out in swaths from the open entrance of the tent.
   
    {avoidfight:->meetagain} {not treasureisland: To Dmytro’s surprise, he recognized in one of the Cossacks that sat at the entrance a warrior who had once disappeared from his unit. He remembered that the warrior had once urged him to leave behind the registered Cossacks and set off as an independent Cossack in the Wild Fields. The young man also seemed to have recognized Dmytro and immediately got up: “Dmytro from the Wild Fields? What a reunion! Which wind brought you here?”} The runaway explained his story. “Yes, it was our camp on the Tartar coast,” affirmed the Cossack sitting on the barrel. “We fought them off, but we had to leave. More of them will come shortly now that they know where our camp is.” The man pondered: “Listen, if you are a registered Cossack, as Stepan claims, then stay with us. We lost several of our brothers-in-arms this summer. We lack manpower. Either way, you have nowhere to go. It’s a long road to Kyiv,” the leader smiled through his moustache, letting out another cloud of smoke. “We are moving further downstream for the winter. We have space in the camp,” he concluded his offer.
    -> staywcossacks.winterstay
    
    = meetagain
    # image cossacks # image camp
   
   The conversation turned out to be more pleasant this time. Since Stepan had vouched for the runaway, Dmytro was permitted to stay with the Cossacks and spend the winter with them. On the other hand, he didn’t have any better options. 
    
    -> staywcossacks.winterstay
    
-> DONE


-> DONE

=== stealth
# image steppe
   
  The runaway fell to the ground, trying to hide from view, but also trying to see what was happening up ahead. The Tartar continued to survey the tracks, but he didn’t risk going into the forest by himself. He ran from the burnt forest to a hill where a horse was neighing. Then the Tartar rode off into the distance. Dmytro understood that the pursuer could return with others at any moment, so he immediately set off westward towards the horizon. He walked towards a distant hill where a lone tree grew, stretching its branches towards the sky.
    -> coldnight.hill

    
=== treasureisland
    = intro
    # image bulrush # image boat # image river # image cossacks
   
Dmytro reached the shore, jumped out of the boat into the shallow water and pulled the boat ashore, trying to hide it as well as possible. Having finished this, he went towards the trees where the he had glimpsed something light-colored. He quickly found someone’s makeshift bedding under some willows. It seemed that the place had been left in haste a long time ago. The abandoned tent had been displaced by the wind and there were no ashes in the firepit. However, he couldn’t find any belongings, only a decaying sack and a wooden shovel that had fallen apart due to the moisture. Dmytro walked around a little more, taking a good look at the area. He was ready to return to the boat when he heard a noise from the other side of the island. He listened carefully. It seemed somebody had landed on the other side of the island. He heard low voices but couldn’t decipher what they were saying. The runaway hardly had the time to hide in the nearest thickets when several Cossacks emerged from the opposite side, their bows at the ready. They quickly made their way to the remnants of the abandoned tent. Two others followed right after them. To Dmytro’s surprise, he recognized one of the Cossacks. The young man had once persuaded him to run off to the Wild Fields before disappearing himself.
    
   
    The newcomers carefully surveyed the island. One of the Cossacks moved towards the shore where Dmytro had left his boat. Soon, they had gathered near the tent once again, looking around. Then one of them called out: “Come out in the clearing or we will find you!” Dmytro hesitated a bit, but then he replied, still hidden in the thickets: “Stepan! Stepan from Bila Tserkva? Ask the men not to shoot and I will come out.” The Cossacks started to talk quietly among themselves, somewhat surprised. Then the one whom Dmytro had recognized, proclaimed: “Come out, show yourself.” Dmytro slowly got up and came out of the thickets. Stepan also recognized him and couldn’t hide his surprise: “Which wind brought you here? What a meeting! So you also decided to join the Zaporozhians?” 
  
    {avoidfight: It turned out that Stepan belonged to the very same group of Cossacks that had captured Dmytro previously, but he was away when this happened. “Listen, we can’t let you go, but I will do the best I can,” Stepan promised and smiled, adding, “We won’t try to drown you anymore.”}

   
   {not avoidfight: After the runaway had told about his adventures, his old acquaintance said: “I will vouch for you before the otaman. Maybe he will allow you to join us.” Dmytro agreed.} Stepan stayed with the rest of the Cossacks and they sent Dmytro in the company of two Cossacks to their camp on another island. Soon they joined him and Dmytro {avoidfight: again} was sent to the otaman. 
    
    -> skiptreasure.meetingcossacks
            
-> DONE

=== captured

    = exec
    # image steppe
    
    He woke up from being dragged on the ground by his feet. He heard unintelligible calls and laughter. Dmytro couldn’t understand what was happening. Finally, he was left on the ground and for a moment everything seemed to have subsided. He lay in the grass with his legs tied together by a rope and surrounded by several dozen Tartars. Dmytro couldn’t move a finger; he was completely exhausted. He was shivering from a high fever and all his joints were aching. He couldn’t see clearly due to red spots clouding his vision. Suddenly, he felt an acute pain in his right leg as though somebody had touched it with a piece of red-hot iron. Dmytro twitched but couldn’t make a sound. One of the Tartars lowered his bow, satisfied. Now another Tartar took a shot, bringing agonizing pain to Dmytro’s second leg. They continued to shoot until Dmytro had lost consciousness. 
    {~ -> wakehermit | -> wakehermit | -> death}
    
    = death
     # image theend
    THE END
    -> DONE

=== wolves
# image tobecontinued
   TO BE CONTINUED...
    ->DONE
    
    
=== loosehorse
# image tobecontinued
    TO BE CONTINUED...
    ->DONE

=== coldnest
# image tobecontinued
    TO BE CONTINUED...
     ->DONE
     
=== letmego
# image tobecontinued
    TO BE CONTINUED...
-> DONE

=== staywithhermit
# image tobecontinued
    TO BE CONTINUED...
-> DONE

//# image bulrush # image boat # image river # image cossacks # image fight # image steppe # image forest # image camp