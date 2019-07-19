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

 The sun was setting over the river, casting a crimson glow over everything. A swift current swept the dark water south to the sea while the wind quietly rustled the reeds, carrying the scent of autumn and smoke from the fire. Twilight was settling in.     

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
    The Cossack hit him with all his strength. The Tartar howled, twitched, and immediately became silent. With a sharp movement, Dmytro pulled the saber from the hands of the dead man, grabbed his things, and stepped back into the darkness. From the fire, it was possible to hear an undistinguishable clamor of voices. He stopped and raised his bow and arrow, aiming at the strange shapes that glimmered in the light of the dying fire.     
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
   
->DONE


=== forest

TO BE CONTINUED...
-> DONE

=== encouner


TO BE CONTINUED...
-> DONE