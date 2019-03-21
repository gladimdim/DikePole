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
# sound river # image bulrush
    Сонце сідало за рікою, заливаючи все навколо багряним сяйвом. Стрімка течія несла темну воду на південь, до моря. Вітерець стиха колихав очерет, розносячи запах ранньої осені та дим від вогнища. Поступово сутеніло.

    Дмитро нерухомо лежав у прибережних заростях досить далеко від води, прислухаючись до навколишніх звуків. Надокучлива комашня гризла обличчя та шию, та з тим робити було нічого. Десь там, трохи далі на березі, де очерет поступається степовій траві та поодиноким деревцям, розташувалися біля вогню троє чоловіків. Утікачу їх не було видно, однак інколи вітер приносив уривки розмови та брязкіт реманенту. Це були татари. Дмитро прислухався, намагаючись зрозуміти, чи вони тут по його душу.

    Козак лежав так ще довго, закривши голову руками, доки зовсім не стемніло. Вітер посилився, зовсім заглушивши усі навколишні звуки потужним шелестом очеретяного моря. Він гнав на захід уривчасті хмари, що затуляли і без того слабеньке сяйво молодого місяця. Дмитрові вже несила було чекати довше, треба було на щось наважуватися. Стиснувши добрий поясний ніж - єдину річ, що йому вдалося прихопити з човна під час втечі - він поволі переповз до стежки, яка вела крізь очерет до річки. Трохи почекав, підвівся та, намагаючись ступати тихіше, незважаючи на шум заростів, підійшов до краю води. На темній стежці нікого не було. Він присів і почав пити холодну річкову воду, черпаючи її долонею. У стрімкому потоці час від часу спалахувало відображення місяця та хмар, підсвічених ним. А потім раптом промайнуло дівоче обличчя. Чоловік відсахнувся від води та витріщився туди, звідки якусь мить тому на нього дивилися ясні очі молодої панночки. Але там вже нічого не було - тільки місячне сяйво подекуди виринало із хмар. Він перехрестився та позадкував від води, у півголоса промовляючи молитву. Потім розвернувся та рішуче вирушив туди, де закінчувалася стіна очерету.
    # image camp #sound snorting
    Втікачу знову довелося повзти, бо берег піднімався все вище, аж ось незабаром з’явилося вогнище, яке ще жевріло самотньо у степу.
    
    -> sleeping_tatars

=== sleeping_tatars
 
    = action 
        У нечастих спалахах місячного сяйва можна було розгледіти силуети людей та коней. Двоє, схоже, спали на землі, один навпроти одного. Третій сидів ближче до вогню, спираючись на короткого списа, і, здавалося, теж заснув. Коней було видно гірше, вони дрімали десь з іншого боку багаття і їх, на перший погляд, було не менше п’яти. 

        Дмитро підповз до найближчого сплячого татарина та тихо підвівся на коліна, підготувавшись встромити ножа йому в око, якщо той ворухнеться. Поруч лежав лук з сагайдаком та якась торбинка.
    
        + [Забрати торбинку та лук з сагайдаком]->steal
    
        + [Пошукати татарську шаблю]->saber

    = steal
            # image firesinsteppe # sound steppe 
           ~ Inventory = Inventory + bow
            Козак більше нічого не ризикнув чіпати і зі своєю здобиччю обережно повернувся до очерету та почав поступово віддалятися від вершників, прямуючи вздовж річки вверх за течією.
             
            Далі, як на добрий перестріл від стоянки, трапився невеликий пагорб, з якого було видно, що позаду в степу мерехтіло не одне, а два вогнища. Друге було ще далі від річки і його було погано видно. Татар тут було більше, ніж Дмитрові здавалося спочатку. Він рушив далі, не гаючи часу. Незабаром, обидва вогнища зникли у степовій імлі. Перша холодна осіння ніч завітала до Дикого Поля.

            Очерет змінювався травою, трава - камінням, каміння - байраками. Пройшло вже багато часу відтоді, як розпочався шлях втікача вздовж узбережжя. Пройшовши в темряві чергову улоговину, що збігала вниз до Дніпра, козак рушив у степ подалі від річища.
    
            {~ ->forest |->forest | -> forest |->encouner}
    =saber
            Обережно відклавши ці речі ближче до себе, Дмитро нишпорив оком у пошуках шаблі. Вона теж лежала поруч, відчеплена з гаку, але сплячий обіймав її, як дитина - улюблену ляльку. 
    
            + [Спробувати витягнути] -> alarm
    
            + [Залишити] -> steal
->DONE
            
=== alarm

    = kill
            
         Дмитро затамував подих. Твердою рукою він узявся за шаблю та почав потихеньку витягати її з піхов, тримаючи в другій руці ніж. Сплячий засовався та перевернувся на бік, а за тим раптово перевернувся назад і відкрив очі. 
         Козак вклав всю свою силу в удар. Татарин зойкнув, смикнувся, але миттєво затих. Дмитро різким рухом висмикнув шаблю із рук убитого, схопив разом решту речей та відступив кілька кроків назад у темряву. З боку вогнища почувся якийсь нерозбірливий гомін. Він зупинився та підняв лук, придивляючись до химерних образів, що мерехтіли у відблисках згасаючої ватри.
         ~ Inventory += sword
        {~ ->awake|->sleep}
     
     = awake
            Фігура зі списом біля вогнища підвелася та почала наближатися крізь хмару диму. Дмитро випустив стрілу. У відповідь почувся шелест трави та потім запала тривожна тиша. Козак спробував якумога обережніше відступити за береговий схил та почав шивидко віддалятися від табору. За деякий час він спустився вниз та заліг у очереті, прислухаючись. Схоже, що його ніхто не переслідував. Тоді він вийшов на рівнину та попрямував у степ подалі від річища.
    -> forest
     
     
     = sleep
            Однак, в таборі було тихо. Фігура біля вогнища продовжувала сидіти на місці. Дмитро почекав іще трохи та, нарешті, пішов геть, намагаючись ступати якумога тихше. Незабаром він уже просувався відкритим степом, віддаляючись від ріки.
    -> forest
    // Розбудив татарина, намагаючись витягти шаблю вбити сплячого, вартовий рандомно прокидається або ні (розвилка), тікає до того ж лісу, якщо ніч з вогнем - на ранок оточують, беруть в полон, якщо без вогню - татарин на ранок не приїжджає
->DONE


=== forest
# image burntforest #sound night
   Дмитро йшов між невисокими пагорбами, коли раптом відчув запах згарища. На черговому горбі він добре роздивився навколо - жодних вогнів, чи навіть диму помітити не вдалося. Проте, вдалині, на скільки дозволяла ніч, можна було побачити якийсь перелісок. Утікач попрямував до нього. У повітрі все сильніше смерділо горілим. Зблизька лісок дійсно виявився згарищем - голі почорнілі стовбури стирчали, наче щогли, гублячись у темряві та зливаючись між собою у суцільну стіну. За собою вони ховали невелику западину, в якій стояла калюжа води та витікав ледь помітний струмок. Навколо западини розкинулося декілька кам’яних брил завбільшки з воза. Долівку вкривав товстий шар холодного попелу. 

    Чоловік розташувався за найближчою до струмка каменюкою, тримаючи лук зі стрілами напоготові біля себе, та став навпомацки вивчати вміст татарської торбинки.  

    Спочатку під руку потрапило кресало та прив’язаний до нього сірий мішечок зі шматками кременя та трутом з обпалених ганчірок, далі - сухарі та кілька куснів в’яленої конини, загорнутих в рядно, мідний кухоль, а останнім предметом були піхви до ножа чи кинджалу, на вигляд звичайні, з грубої шкіри, проте, оздоблені тисненням та невеликим камінцем посередині. Самого кинджалу у торбі не було. Ніж, що його мав Дмитро, для них був замалий, тож він поклав піхви назад до торбинки.
    ~ Inventory += (firesteel, nice_sheath, cup)

    Нічний холод підібрався до кісток.

    + [Розпалити багаття]->fireplace
    + [Пошукати інший спосіб зігрітися]->coldnight

->DONE

=== fireplace
# image campfire # sound fire
    Дмитро не мав жупана, тож пішов збирати обгорілі гілки та складати їх під каменем, який мав плоску вертикальну сторону, обернену досередини улоговини. Татарський трут та кресало стали в нагоді. Козак запалив вогнище, сподіваючись, що згарище, ніч та ця яма допоможуть приховати багаття. Обвуглені дрова згоряли швидко і майже без диму, лишаючи по собі яскраве розпечене вугілля. Тож незабаром чоловік мав поряд себе таку собі жаровню, до якої він підкладав більші головні, що були розкидані навколо. З найменш обпаленого хмизу вийшла непогана підстилка біля вогнища. Наносивши ще головешок, Дмитро розширив жаровню і тепер вугілля горіло вздовж усього каменя, майже на його зріст. Стомлений утікач поставив прямо у вугілля кухоль з водою зі струмка, щоб легше було розмочувати сухарі та м’ясо. Нехитра їжа та тепло жаровні, що хвилями відбивалося від кам’яної брили, нарешті зігріли його. Так до світанку козак дрімав, час від часу прокидаючись, щоб підкласти дров то до одного краю вогнища, то до іншого, та ковтнути води. Аж ось нарешті небо стало світліти. Починався новий день.
    
    {alarm.sleep : ->coldnight.move}

    На сході сонця набігли щільніші хмари, затуливши світило, тож ранок видався похмурим. Дмитро прокинувся, як йому здалося, від якогось віддаленого звуку. Від жаровні лишився майже самий попіл, хоча розігріте каміння все ще віддавало тепло і вранішній холод майже не відчувався. Козак швидко підвівся, підхопив торбинку та лук із сагайдаком і рушив на протилежну сторону улоговини. Потім звернув ліворуч і, зробивши широке коло, повернувся до межі обгорілого лісу, трохи далі від того місця, де вночі він зайшов на згарище.
    
    {alarm.awake : ->surrounded}
    -> ambush
    
=== surrounded

    Дмитро вже відійшов від лісу на десяток кроків, коли раптом попереду почулося віддалене іржання. Він стрілою чкурнув назад до найближчих кущів та присів у западинці, затамувавши подих і прислухаючись. Крізь гілля йому було видно, як до лісу повільно під’їхало кілька вершників. Вони трималися значної відстані один від одного та перегукувалися короткими глухими покриками. Один з них наблизився до того місця, де стояв козак всього декілька миттєвостей тому. Степовик схилився у сідлі та роздивлявся щось у траві. Він гукнув і решта відступили трохи від узлісся та зупинилися, так само витримуючи проміжки між собою. 

    Утікач поволі відступав вглиб згарища, пригинаючись і ступаючи тихо, як рись. В лісі все стихло на хвильку, а потім з усіх боків став долинати шурхіт та подекуди тріск гілок.  Дмитро застиг на галявині десь у самісінькій середині попелища. Тут все було спалене вщент - не вціліло ані кущика. Тільки чорні стовбури стирчали з землі навколо, як палі. Однак, попереду проглядали якісь зарості. Дмитро схопився бігти, але за декілька кроків провалився ледь не по пояс у глибоку яму, засипану попелом. Він випростався з ями та обернувся. Через попелище тягнувся ланцюжок слідів. Переслідувачі наближалися. Дмитрові здалося, що він вже може розрізнити голоси десь неподалік. У кілька стрибків він дістався до заростів. За ними в улоговині протікав вже знайомий струмок. Він зістрибнув у нього та побіг за течією. Як тільки берег перетворився на виступаючу з землі невисоку скелю, Дмитро видряпався на неї та стрімголов кинувся уперед по пласкому гребеню, аж доки не зупинився на краю маленького урвища, яким закінчувалося кам’яне пасмо. Урвище було, вочевидь, вщерть засипане попелом, листям та уламками гілок, тільки зліва біля закруту струмка, який протікав по інший бік гряди, стояли розлогі верби, до стовбурів яких, здавалося, можна дотягнутися рукою.
    
     + [Залізти на дерево]-> hide.tree
     + [Заховатися в урвищі]-> hide.ash
     + [Засісти на скелі]-> hide.rock
     
-> DONE
    
=== ambush
    Біля його слідів у попелі схилився татарин. Потім підвівся, уважно роздивляючись навколо. На скільки Дмитро міг бачити зі свого укриття, цей кочівник був тут сам-один і він дуже нагадував того самого татарина, в якого він вчора вкрав речі.
 // Debug
    Зараз серед речей: {listWithCommas(Inventory, "порожньо")}
    Є майно: {listWithCommas(Property, "нема")}

    + [Вистрілити з лука]->shoot
    + [Заховатися і сидіти тихо]->stealth
    

=== shoot

    = ride
        Козак натягнув лука, прицілився добре та випустив стрілу. Кочівник видав якийсь незрозумілий звук та повалився на обгорілу землю. Дмитро виждав деякий час – ніхто не з’явився. Тоді він обережно пішов уперед. Татарин, схоже, вже не дихав.

        Незабаром, Дмитро вийшов із закіптюженого переліска у шапці, трохи закривавленій ззаду опанчі та з ординською шаблею на поясі. Неподалік у степу ходив низенький жеребець під сідлом. Козак наблизився до нього, промовляючи заговір, що навчився ще малим хлопчаком, доглядаючи коней, та зазирнув тварині у вічі. Потім рішуче скочив у сідло та поскакав геть. Із глибокого налитого свинцем неба на пожовклий степ почав накрапати дрібний дощ.

        Дмитро їхав степом не зупиняючись. Інколи він міняв напрямок, наближаючись до ріки, та одразу, як тільки міг розгледіти берег, знову звертав у степ. Злива періщила цілий день, одяг та всі речі намокли. Проте, тепла ночівля додала козаку сил, тож він не звертав уваги на такі дрібниці. Степовий кінь теж виявився істотою витривалою і не подавав жодних ознак втоми - з новим господарем у сідлі він уперто біг вперед у невідоме крізь трави, дощ і вітер.
        
        ~ Inventory += (hat, coat, sword)
        ~ Property += horse
            
        -> stream
        
    = stream

         {Property has horse:  Місцевість стала ще більш бугристою, де-не-де з-під землі виступали скелі. Черговий раз звернувши на захід, Дмитро під’їхав | Він підійшов} до самісінької кручі. Ріка розкинулася внизу, широка і спокійна, оздоблена морями очерету, скелями та острівцями, оповитими туманом. Посередині простягнувся чималий острів, зовсім плаский, зарослий вербами та чагарником. Від північного кінця острова відділився темний силует маленького човника та почав жваво рухатися проти течії, доки не зник з поля зору, розчинившись у прибережних заростях.
         
        Дмитрові вдалося {Property has horse: проїхати | пройти} ще зовсім небагато, доки він не вперся у невеликий потічок, що, однак, утворював чимале урвище, стікаючи до Дніпра. Крутим схилом униз вела ледь помітна стежка. {Property has horse: Дмитро зліз з коня та став спускатися, тримаючи його за повід. Стежина | Вона} вела до широкої галявини, оточеної вербами, що була захована межі кручі в тому місці, де потічок вливався у велику річку.
        
        Козака бентежило якесь неприємне передчуття...

    +[Оглянути галявину]->meeting
    +[Повернути назад у степ]->runaway

=== meeting
   
    Дмитро { Property has horse: відпустив коня та} рушив, вглядаючись у зарості. Він пройшов лише декілька кроків та раптом зупинився, коли почув як клацнув замок самопалу у нього за спиною. Утікач закляк на місці.
        "Ти якої віри будеш?" пролунав чийсь голос.
        "Руської," впевнено відказав Дмитро і повільно розвернувся обличчям до запитуючого.
        Позаду нього стояло двоє чоловіків, які невідь звідки й взялися. Якби не самопал, та шаблі, та спис - їх би можна було мати за рибалок.
        "А ну, хрестися, коли добра людина," мовив інший. Утікач тричі перехрестився.
        "Ходімо," сказав той, що тримав самопала, не опускаючи зброю, та кивнув кудись межі верби. Всі троє підійшли до схилу під дерева. Незнайомець зі списом раптом накинув Дмитрові на голову маленький мішок, який страшенно смердів рибою, та штовхнув у спину.
        "Ходімо, ходімо," хтось підхопив утікача під руку та повів уперед. Вони йшли кудись зовсім недовго, Дмитра примусили нахилитися та спуститись, начебто, сходами. Рипнули двері. Хтось стягнув з нього мішка. Вони опинилися у довгій напівтемній погребниці з земляною долівкою, вкритою очеретом. На лавах за столом з грубих колод сиділо ціле озброєне товариство. Світло ледь потрапляло всередину крізь вставлені в земляні стіни пляшки під самісінькою низенькою стелею. У смугах світла в повітрі кружляв пил та дим. У куті висів образ Богородиці у срібних шатах із лампадкою.
    
    Дмитра розпитували хто він і звідки. Він розповів як потрапив у полон до татар під Цецорою разом з іншими козаками з Бару, як його вели до Криму та як він утік на переправі, коли зчинилися метушня через те, що хтось раптово напав на татар у цьому місці.
        ...
        
    Приймають за шпигуна, йдуть топити, напад татар, звільняється і б'ється з татарами разом з усіма, приймають за свого.
    
    ->joinfight
   
=== backtocamp

    ПЕРЕПИСУЄТЬСЯ

    Дмитро повернув назад. Через декілька годин довелося спішитися та вести коня за собою.

    Сонце вже почало хилитися до небокраю, коли вдалині у степу з’явилася хмарина куряви. Потім вона розділилася на декілька хмаринок, які, повільно пливучи, розходилися у різні боки. Одна з хмарин рухалася назустріч, але за деякий час змінила напрямок. Дмитрові вдалося розгледіти коня без вершника, який ошаліло нісся вечірнім степом та невдозі зник за пагорбами.

    На горизонті забовваніли знайомі прибережні урвища. З долини потічка біля стоянки рибалок вітер виганяв ледь помітні пасма сірого диму. Дмитро лишив поранену тварину у низовині та обережно рушив до узбережжя, тримаючи лук напоготові. Перед самою долиною повернув праворуч та видерся на кручу, що здіймалася над табором з протилежного боку струмка. Припавши до землі, козак визирнув з-за краю урвища.

    На місці річкового куреня тліло величезне чорне попелище. Дим від нього устилав усю долину, як ранковий туман. Була спалена і частина прибережного очерету. По галявині були розкидані різні уламки, з землі, дерев та тліючих колод рясно стирчали стріли. Серед усього цього безладу то тут то там лежали закривавлені порубані тіла татар. Дмитро нарахував шістьох убитих кочівників. Ніхто не подавав жодних ознак життя. Над табором запала абсолютна тиша, що навіть з кручі було чути потріскування вугілля у спаленій катразі.

    Козак нерухомо спостерігав за галявиною у цілковитій тиші ще досить довго. Не побачивши більше нічого і нікого, Дмитро повернувся до низовини, де лишив коня. Нещасної тварини ніде не було видно. Чоловік походив довкола, спробував покликати стиха. Клятий кінь як крізь землю провалився. Нащастя, Дмитро, уходячи, забрав усі свої корисні речі із собою, нічого не лишаючи притороченим до сідла.
    ~ Property -= horse

    +[Покинути пошуки та йти до табору]->scavenge
    +[Рушити далі в степ у пошуках коня]->wolves
    
=== scavenge
    Дмитро покинув марні пошуки та пішов назад до табору.

    Коли він обережно ступив до обгорілого та закривавленого стану, вже сутеніло. Дмитро заходився ретельно оглядати місце, шукаючи все, що може розказати, що сталося, або стати в нагоді. З’ясувалося, що всі більш-менш цінні речі та зброя зникли разом із рибальськими човнами. Вдалося знайти лише кілька вцілілих торбин з сушеною рибою, смаженим пшоном та мукою. Біля одного з татар, що лежав посеред галявини, якому ззаду пробили чимось голову, на землі валялася глиняна фляга. Вона виявилася перекинутою через плече на шкіряному ремінці, тож її не вдалося відразу зняти, бо татарин лежав обличчям донизу, широко розкинувши руки. Чоловік дістав ніж і зрізав флягу. Вона була порожня, тож він пішов до потічка стежкою, яку, вочевидь, проторили рибалки. Біля струмка дійсно була зроблена кладка, з якої зручно було набирати воду. Звідсілля ж стежка вела далі в очеретяні хащі кудись убік. Наповнивши флягу, Дмитро лишив її на кладці та пішов подивитися, що ж там. 

    Вузька стежина вилася очеретом і затягувала все далі від табору попід кручі. Врешті, вона привела до невеликого майданчика на березі. Очерет тут був ретельно вирізаний, тож далі відкривався прохід до Дніпра. Ближче до води на майданчику лежав крихітний човник-довбанка. Над човном схилилася якась темна фігура. Дмитро завмер, тримаючись за руків’я шаблі, потім зробив кілька обережних кроків вперед. Наполовину на землі, наполовину у човні лежав татарин без шапки з перерізаною горлянкою. Його кров злилася у човен, як вино до чарки. Козак перехрестився, трохи задумався, а тоді витяг кочівника за плечі та впустив на землю - ані шаблі, ані ножа, ані якоїсь торбини.  Дмитро перевернув човна, спостерігаючи за багряними ручаями, що немов змії розповзалися на всі боки, а потім швидко попрямував назад до табору.
    ~ Inventory += flask
    ~ Property += boat

    +[Відплисти на острів]->island
    +[Ночувати в таборі]->stay

=== island
    Вже майже у цілковитій темряві Дмитро відвалив від рибальського стану у малій довбанці, завантаженій знайденими припасами. Він вправно працював одним веслом, що знайшлося на згарищі, та кермував на дрібний неоковирний острівець посеред Дніпра, який запримітив іще з кручі, поки сонце було високо. Цей острівець був найближчим з цілої купи таких самих островів вище за течією, що утворювали собою підступний лабіринт вузьких проток та плавнів.

    Дмитро веслував не відволікаючись, аж доки останні промені сонця не промайнули у річковому дзеркалі. У той же час ніс човника глухо вдарив у кам’янистий берег безіменного клаптика суходолу посеред могутньої ріки.

    Острів сильно заріс чагарником. Дмитрові довелося попотіти, щоб затягнути човна на берег. З іншого боку, гущавина надійно ховала все, що є на цьому острівці, від спостерігача на березі чи на воді. Щоб дістатитися до середини, до якої було, може, кроків сто, довелося пригинатися та ледь не навкарачки проповзати крізь зарості. Посеред острова росло три старезні товсті дерева, під які не наважилися лізти кущі. Долівка була густо вкрита хмизом та пожовклим листям. Дмитро перетягнув сюди свої ужитки і нашвидкоруч зробив очеретяну буду. Потім заварив саламаху у мідному кухлі, розпаливши вогнище навпроти.
    
    До того часу вже остаточно стемніло. Ніч цього разу видалася ясна, тепла і зоряна. Дмитро залишив свій табір та пішов до краю острівця, протилежного тому, до якого він пристав. Нарізаючи очерет, він розвідав тут досить вільний прохід до берега. Зарості були не такі густі, а попід берегом лежало кілька кам’яних брил, утворюючи невелику заболонь. Дмитро залишив свій одяг на камені та обережно увійшов у холодну дніпровську воду. Зайшовши у річку по пояс він зупинився, милуючись віддзеркаленням небесних світил у тихій колисці хвиль. Раптом здалося, що він знову угледів під водою ту панночку. Дмитро струснув головою - певно, втома давалася взнаки. Незважаючи на прохолоду, купання принесло відчуття значного полегшення та змило пил пригод останніх днів. Повернувшись до буди, Дмитро ледве дочекався, коли догорить багаття, та міцно заснув.
    
    // Debug
    Зараз серед речей: {listWithCommas(Inventory, "порожньо")}
    Є майно: {listWithCommas(Property, "нема")}
    
   ->DONE

    
=== stay
    Знищений рибальський стан навіював гнітючий настрій. Козак ще трохи роздивився серед згарища у пошуках корисних речей, однак, не знайшовши нічого, наносив дров до човна. Провести ніч серед побоїща не хотілося, тож він витягнув тіло з човна до інших на галявину та заночував біля довбанки. Підставивши під неї ломаку, Дмитро отримав невелике укриття від можливої негоди. Він розклав багаття поруч, повечеряв тим, що йому вдалося знайти у таборі та ліг під човен.

    Саме в цей час на Дике Поле спустилася чергова ніч. Сон Дмитрові не йшов. Якось йому здалося, що він чує нагорі за урвищем кінське іржання. Згадавши про свого загубленого коня, він підвівся та, прихопивши зброю, пішов на крутий схил над Дніпром. Над урвищем нікого не було, тож він вирішив пройтися трохи далі в степ до найближчого пагорба, щоб спробувати з нього роздивитися навколо, на скільки дозволяло мерехтливе місячне сяйво.
    
    { not encouner: {~ ->fail|->encouner}}
    
    ->fail
    
=== fail
    Незабаром Дмитро досяг пагорба. Віяв холодний осінній вітер, навкруги майже нічого не було видно у нічній імлі. Переконавшись, що ніякого руху чи вогню не видно, він повернувся до своєї ночівлі біля табору та, нарешті, заснув.
    ->DONE
    
=== wolves
    ->DONE
    
    
=== loosehorse
    ->DONE

=== coldnight

    = shelter
        Дмитро полишив торбинку та пішов до струмка, де виднілися острівці вцілілої рослинності. За декілька кроків тихе рипіння попелу під ногами перетворилося на шурхіт опалого листя. Трохи далі вигин струмка заповнювала невелика пляма високої напівсухої трави. Козак дістав ніж та почав зрізати її швидко та розмірено, неначе женець, що збирає збіжжя. Досить скоро він уже мав чималий сніп. Дмитро відніс його до своєї схованки біля каменя та повернувся назад. Так він викошував траву, доки не зрізав увесь клаптик. Потім зняв сорочку, зав’язав її у вузлик та почав набивати його листям, намагаючись обирати найсухіше. Носити листя довелося довго, доки Дмитро не залишився задоволений результатом - біля каменя утворилося величезне застелене травою кубло. Він витрусив сорочку, одягнув її та поліз всередину купи. Йому потеплішало ще раніше - від роботи, а тепер, лежачи на сіні у кучугурі сухого листя, стало й зовсім затишно. Він з’їв кілька сухарів з татарської торбинки та стомлений швидко заснув.

        Крізь шар листя вже помітно просвічувало сонце. Дмитро зрозумів, що пропустив світанок. Він обережно визирнув із кубла та роздивився навколо. В обгорілому лісі стояла дзвінка вранішня тиша, яку наважувався порушувати лише струмочок. Козак випростався на ноги, підійшов до струмка, зачерпнув у долоні студеної води та умився. А за тим поклав сорочку поруч на камінь, схилився над потічком та почав змивати з себе попіл та залишки трави і листя. Таке ранкове умивання дуже додало бадьорості та збудило апетит. В’ялене м’ясо, кілька сухарів та джерельна вода допомогли трохи втамувати голод.
        ->move

    = move
        {alarm.sleep: Але Дмитро проспав увесь ранок, відновлюючи сили. Коли він| Коли Дмитро} нарешті вийшов з лісу, час вже наближався десь до полудня. На пагорбі поблизу стояло якесь окреме невисоке дерево. Віддаленість від лісу, схоже, врятувала його від пожежі, хоча пасма випаленої трави вилися аж до підніжжя схилу. Мандрівник дістався пагорба. Піднявшись на нього, він лишив на землі речі, що заважали, та видерся на дерево. У навколишньому степу було тихо та порожньо. Добре оглянувши все навкруги, Дмитро спустився вниз, та сів під деревом, замислено хитаючи головою. Раптом підвівся, схопив лук та решту речей і поспіхом вирушив до наступного пагорба.

        Незважаючи на початок осені, сонце все ще добряче припікало, але Дмитро поспішав. За схилом розкинулася широка низовина, на протилежному боці якої виднілася балка, поросла очеретом, яка змією вилася десь у бік Дніпра. Сама ж низовина була рівна та пласка, як тарілка, але посередині самотньо стирчала сіра кам’яна брила з різкими гострими гранями. Між скелею та балкою темною плямою росла купка дерев та кущів. Інша темна майже кругла пляма виднілася біля підніжжя брили. На ній звідси можна було розрізнити декілька чорних крапок на землі. Від однієї з них піднімалася вгору тонка ледь помітна сіра ниточка, що колихалася та місцями розривалася, хоч і було повне безвітря.

        Дмитра привело сюди якесь відчуття, однак, він все одно аж затамував подих від несподіванки. Подив швидко минув, мандрівник продовжив уважно роздивлятися місцевість внизу. У низовині було порожньо.
    
        Він поволі спустився широким напівколом, тримаючи місцевість у полі зору і незабаром уже стояв біля нещодавно згаслого вогнища, вивчаючи сліди чиєїсь ночівлі. Людей було небагато, може, десяток. Вони прийшли пішки з півночі та, переночувавши, вирушили до балки. 

        У балці добре проглядалася вузенька стежина, що вилася по схилу та зникала в очереті. На дні протікав струмок. Стежка час від часу виринала з балки і мандрівнику відкривалися нескінченні терени Дикого Поля. Вечоріло.
    
        Манівцями Дмитро вибрався з балки та незабаром опинився біля самого Дніпра.
    
    -> shoot.stream

    
    // Debug
    Зараз серед речей: {listWithCommas(Inventory, "порожньо")}
    Є майно: {listWithCommas(Property, "нема")}
    
    

    ->DONE

=== stealth
    ->DONE
    
=== runaway
    = think
        Дмитро трохи завагався, однак, врешті повернув назад і попрямував геть, подалі від підозрілої балки.
    { Property has horse: -> brokenleg | -> seesdust}
    
    = brokenleg
        Він зовсім недалеко від'їхав, коли на шляху трапилося неглибоке кам'янисте русло пересохлого струмка. Кінь перескочив його, не зупиняючись, та за деякий час почав помітно припадати на праву передню ногу. Дмитро зупинився та спішився. На перший погляд, нічого серйозного не трапилося, але треба було трохи перепочити. Він присів на камінь, відпустивши коня поряд, та роздивлявся навколо. 
    -> seesdust
    
    = seesdust
    
    Бачить дим та куряву з боку балки.

+[Повернутись до балки] -> backtocamp
+[Рухатись далі] -> loosehorse

    ->DONE
    
=== joinfight
    ->DONE
    
=== hide
    
     = tree
     
        Дмитро підступив до краю скелі та застрибнув на вербу. Спритно хапаючись за гілки він опинився високо на розвилці стовбура. Йому вдалося так зручно вмоститися на дереві, що він навіть зміг би стріляти з лука на два боки. Облаштувавшись як слід, Дмитро зачаївся та став прислухатися. Дуже довго повітря наповнювали тільки звичні для лісу звуки вітру, падаючого листя і гілок та дзюрчання струмка. Аж ось попереду на землі тріснула гілка. Трохи згодом зачувся якийсь шурхіт. Козаку було погано видно крізь звисаюче віття із залишками пожовклого листя, але він зрозумів, що на протилежний берег потічка вийшли двоє татар. Один з них наблизився до води та присів, наповнюючи свою флягу. Дмитро зміг його побачити із своєї засідки. Затамувавши подих, утікач спостерігав за ним та намагався вгадати, що ж вони робитимуть далі. Татари напилися води, та, вочевидь, не поспішали рухатися далі. Один ходив вздовж струмка у пошуках слідів, а інший залишався на місці коло берега та роздивлявся навколо. Незабаром з'ясувалося, що десь поблизу є й інші - Дмитро зміг розгледіти, як той, що ходив навколо, подавав убік якісь знаки руками.

        За деякий час непрохані гості все ж пішли далі, та ирохи згодом знову повернулися, цього разу вийшовши з іншого боку.
        
        Дмитро просидів на дереві до самісінького вечора. Татари продовжували прочісувати ліс - то з’являлися біля потічка, то знову йшли геть. На смерканні їх зібралося багато. Вони розпалили вогнище на галявині навпроти дерева, на якому заховався козак, та заходилися ладнати собі ночівлю.
        
        Крізь буркотіння струмка утікач чув їхні розмови та відчував запахи їжі, що долинали з табору. Раніше, коли довго нікого не було видно, він трохи підживився харчами з торбинки, але зараз голод знову нагадував про себе, дратувала спрага. До того ж, разом із сутінками до лісу поверталася неприємна вогка прохолода. Дмитро намагався дрімати.

        На стоянці все заспокоїлося аж після опівночі. Утікач ще довго вичікував, щоб переконатися, що окрім двох вартових більше ніхто не сновигає біля струмка, коли нарешті і вони відійшли та посідали собі десь ближче до тепла їхнього вогнища.
        
        +[Спробувати утікти зараз]->nightchase
        +[Сидіти далі]->coldnest

        
     ->DONE
    
     = ash
     ->DONE
    
     = rock
     ->DONE
->DONE

=== coldnest
     ->DONE

=== nightchase
      Пішов дощ і майже миттєво перетворився на справжню зливу. Важкі холодні краплі з силою били по землі, по листю, по скелі та на пару з вітром у верхівці дерева здіймали гучний монотонний шум. Дмитро тремтів від холоду та напруженя, коли почав обережно, неначе кішка, спускатися униз. Йому вдалося перебратися назад на кам’яну гряду. Він повертався назад до узлісся по своїх учорашніх слідах під прикриттям дощу і темряви, обходив відкриті згарища крізь уцілілі зарості та тримався подалі від струмка. Вже майже біля самого краю лісу попереду зблиснуло вогнище. Дмитро звернув, оминаючи небезпеку, аж ось нарешті зупинився у чагарнику на краю відкритого степу. Вода ручаями стікала з нього. Одежа обважніла від вологи, а тіло - від утоми та холоду. Водночас, утікача мучила спрага. Він присів під кущ, підставив обличчя під одну з гілок та жадібно ковтав краплини, які стікали з неї. Поім підвівся і рішуче пішов просто у непривітне чорне море степової трави. Дощ не вщухав. Дмитро зовсім втратив відчуття часу, повільно просуваючись уперед Диким Полем. Та невелика його частина, яку він бачив перед собою, здавалося, була вічною і незмінною. Аж ось нарешті стали траплятися маленькі баюри, наповнені водою, а згодом з-поза дощової стіни і темряви виринув схил якогось байраку. Спускаючись униз, Дмитро послизнувся та з’їхав на саме дно, Якийсь час він лежав у багнюці нерухомо. У голові паморочилося. Утікач спробував підвестися - здавалося, кості були цілі, але він розумів, що швидко втрачає сили. Козак шкутельгав далі байраком, хитаючись, як сп’янілий. Струмок під ногами на очах перетворювався у  брудний швидкий і широкий потік, який клекотав, як гірська річка. Дмитрові здалося, що він може розрізнити тоненьку стежину, що піднімалася нагору. Коли він видряпався слизьким схилом до якоїсь споховини, злива трохи стихла. Тепер вітер гнав назустріч водяний пил та пасма туману. Навколо посвітлішало і Дмитро розгледів попереду якусь темну пляму на схилі. Дістатися туди коштувало чималих зусиль - утікач вже ледве тримався на ногах. Пляма виявилася маленькою печерою у кам’яному урвищі з дуже широким, майже як зріст людини, але дуже низьким входом. Вже не дуже розуміючи, що він робить, утікач упав на землю та заповз у щілину навпомацки. Всередині було на диво сухо, однак сама порожнина була мала і тісна, як домовина, а долівка була застелена товстим шаром сухої трави. Дмитро перевернувся на спину і чи то заснув, чи то втратив свідомість.
     ->DONE

=== encouner
    Із нічної темряви назустріч Дмитрові щось рухалося. Він зупинився та підняв лук, вдивляючись у примарні силуети. П'ять-шість вовків сунули степом просто на козака. Їх майже не було видно - лише темні плями на фоні пожовклої трави наближалися до людини і тільки очі, що виблискували від кволого місячного сяйва, видавали живих істот.

    Вовки підбігли на два десятки кроків, зупинилися, розтягнушись у лінію, та роздивлялися прибульця.
    
    + [Стріляти в найближчого вовка]->fight
    + [Голосно заговорити]->talk
->DONE

=== talk
    Гучним але спокійним голосом Дмитро промовив до сіроманців, щоб ішли своєю дорогою, та додав кілька характерницьких приказок - мовляв, нема нам що ділити у цьому степу. Вовки, здавалося, уважно слухали, але продовжували стояти. Потім, коли запала тиша, найбільша тварина рушила у бік Дмитра. До нього приєдналося ще двоє вовків. Козак повільно, не обертаючись, ступив кілька кроків назад, опустивши лука. Сірі степові мешканці поважно пройшли повз нього і розчинилися у темряві. Троє, що залишилися, трохи потупцяли на місці та й теж побігли слідом.

    Дмитро перехрестився та перевів дух. Серце у нього билося як скажене. Але досить швидко він опанував себе та помандрував далі в той бік, звідки прибігла зграя.
    
    { not stay: ->forest}
    
    ->fail
    
->DONE

=== fight
    Дмитро, не роздумуючи довго, вистрілив у найбільшого вовка, але стріла лише ковзнула по тілу тварини та зашелестіла далі степовою травою. Вовк у два стрибки опинився зовсім близько від людини та вишкірив свої загрозливі ікла. Дмитро схопився за ніж саме вчасно, щоб виставити його перед собою, коли сіроманець спробував навалитися на нього усією своєю вагою. Почулося приглушене гарчання і людина та тварина разом повалилися на землю, вже зрошену бризками чиєїсь крові. Інший вовк вкусив Дмитра за ногу. Козак відчайдушно намагався скинути з себе тушу великого вовка і при цьому дістати ножем другого, коли відчув різкий біль у правому плечі. Зграя напала на нього і тепер це була бійка не на життя, а на смерть.

    Дмитро не пам'ятав, як йому вдалося відбитися. На ранок він лежав у кривавому болоті серед чотирьох вбитих сіроманців. Він розумів, що наврядчи зможе рухатися - поранення були суттєві та й сил вже не лишилося. Десь здалеку почувся кінський тупіт. Незабаром до місця нічного побоїща під'їхав татарський вершник. Останнє, що Дмитро побачив, був занесений над ним спис степовика. Це був КІНЕЦЬ.
->DONE