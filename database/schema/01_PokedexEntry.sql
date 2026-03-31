CREATE TABLE PokedexEntry (
    id               TINYINT           NOT NULL,
    flavour_text     VARCHAR(128)      NOT NULL,

    CONSTRAINT PK_PokedexEntry PRIMARY KEY (id)
);

-- =============================================================

INSERT INTO PokedexEntry VALUES
(  1, 'A strange seed was planted on its back at birth. The plant sprouts and grows with this POKéMON.'),
(  2, 'When the bulb on its back grows large, it appears to lose the ability to stand on its hind legs.'),
(  3, 'Its plant blooms when it is absorbing solar energy. It stays on the move to seek sunlight.'),

(  4, 'It has a preference for hot things. When it rains, steam is said to spout from the tip of its tail.'),
(  5, 'When it swings its burning tail, it elevates the air temperature to unbearably high levels.'),
(  6, 'It spits fire that is hot enough to melt boulders. It may cause forest fires by blowing flames.'),

(  7, 'After birth, its back swells and hardens into a shell. It powerfully sprays foam from its mouth.'),
(  8, 'It often hides in water to stalk unwary prey. For fast swimming, it moves its ears to maintain balance.'),
(  9, 'The pressurized water jets on this brutal POKéMON''s shell are used for high-speed tackles.'),

( 10, 'Its short feet are tipped with suction pads that enable it to tirelessly climb slopes and walls.'),
( 11, 'This POKéMON is vulnerable to attack while its shell is soft, exposing its weak and tender body.'),
( 12, 'In battle, it flaps its wings at great speed to release highly toxic dust into the air.'),

( 13, 'Often found in forests, eating leaves. It has a sharp stinger on its head that injects poison.'),
( 14, 'Almost incapable of moving, this POKéMON can only harden its shell to protect itself when it is in danger.'),
( 15, 'It flies at high speed and attacks using the large venomous stingers on its forelegs and tail.'),

( 16, 'A common sight in forests and woods. It flaps its wings at ground level to kick up blinding sand.'),
( 17, 'Very protective of its sprawling territorial area, this POKéMON will fiercely peck at any intruder.'),
( 18, 'When hunting, it skims the surface of water at high speed to pick off unwary prey such as MAGIKARP.'),

( 19, 'Bites anything when it attacks. Small and very quick, it is a common sight in many places.'),
( 20, 'It uses its whiskers to maintain its balance. It apparently slows down if they are cut off.'),

( 21, 'Eats bugs in grassy areas. It has to flap its short wings at high speed to stay airborne.'),
( 22, 'With its huge and magnificent wings, it can keep aloft without ever having to land for rest.'),

( 23, 'Moving silently and stealthily, it eats the eggs of birds, such as PIDGEY and SPEAROW, whole.'),
( 24, 'It is rumored that the ferocious warning markings on its belly differ from area to area.'),

( 25, 'When several of these POKéMON gather, their electricity can build and cause lightning storms.'),
( 26, 'Its long tail serves as a ground to protect itself from its own high-voltage power.'),

( 27, 'Burrows deep underground in arid locations far from water. It only emerges to hunt for prey.'),
( 28, 'Curls up into a spiny ball when threatened. It can roll while curled up to attack or escape.'),

( 29, 'Although small, its venomous barbs render this POKéMON dangerous. The female has smaller horns.'),
( 30, 'The female''s horns develop slowly. Prefers physical attacks such as clawing and biting.'),
( 31, 'Its hard scales provide strong protection. It uses its hefty bulk to execute powerful moves.'),

( 32, 'It stiffens its ears to sense danger. The larger its horns, the more powerful its secreted venom.'),
( 33, 'An aggressive POKéMON that is quick to attack. The horn on its head secretes a powerful venom.'),
( 34, 'It uses its powerful tail in battle to smash, constrict, then break the prey''s bones.'),

( 35, 'With its magical and cute appeal, it has many admirers. It is rare and found only in certain areas.'),
( 36, 'A timid fairy POKéMON that is rarely seen, it will run and hide the moment it senses people.'),

( 37, 'When it is born, it has just one snow-white tail. The tail splits from its tip as it grows older.'),
( 38, 'Very smart and very vengeful. Grabbing one of its many tails could result in a 1,000-year curse.'),

( 39, 'When its huge eyes waver, it sings a mysteriously soothing melody that lulls its enemies to sleep.'),
( 40, 'The body is soft and rubbery. When angered, it will suck in air and inflate itself to an enormous size.'),

( 41, 'It forms colonies in perpetually dark places and uses ultrasonic waves to identify and approach targets.'),
( 42, 'Once it bites, it will not stop draining energy from the victim even if it gets too heavy to fly.'),

( 43, 'During the day, it keeps its face buried in the ground. At night, it wanders around sowing its seeds.'),
( 44, 'The fluid that oozes from its mouth isn''t drool. It is a nectar that is used to attract prey.'),
( 45, 'The larger its petals, the more toxic pollen it contains. Its big head is heavy and hard to hold up.'),

( 46, 'Burrows to suck tree roots. The mushrooms on its back grow by drawing nutrients from the bug host.'),
( 47, 'A host-parasite pair in which the parasite mushroom has taken over the host bug. Prefers damp places.'),

( 48, 'Lives in the shadows of tall trees where it eats bugs. It is attracted by light at night.'),
( 49, 'The dustlike scales covering its wings are color-coded to indicate the kinds of poison it has.'),

( 50, 'Lives about one yard underground where it feeds on plant roots. It sometimes appears aboveground.'),
( 51, 'A team of DIGLETT triplets. It triggers huge earthquakes by burrowing 60 miles underground.'),

( 52, 'Adores round objects. It wanders the streets on a nightly basis to look for dropped loose change.'),
( 53, 'Although its fur has many admirers, it is tough to raise as a pet because of its fickle meanness.'),

( 54, 'While lulling its enemies with its vacant look, this wily POKéMON will use psychokinetic powers.'),
( 55, 'Often seen swimming elegantly by lakeshores. It is often mistaken for the Japanese monster Kappa.'),

( 56, 'Extremely quick to anger. It could be docile one moment, then thrashing away the next instant.'),
( 57, 'Always furious and tenacious to boot. It will not abandon chasing its quarry until it catches up.'),

( 58, 'It is very protective of its territory. It will bark and bite to repel intruders from its space.'),
( 59, 'A POKéMON that has long been admired for its beauty. It runs agilely as if on wings.'),

( 60, 'Its newly grown legs prevent it from walking well. It appears to prefer swimming over walking.'),
( 61, 'It can live in or out of water. When out of water, it constantly sweats to keep its body slimy.'),
( 62, 'A swimmer adept at both the front crawl and breaststroke. Easily overtakes the best human swimmers.'),

( 63, 'Using its ability to read minds, it will sense impending danger and TELEPORT to safety.'),
( 64, 'It emits special alpha waves from its body that induce headaches just by being close.'),
( 65, 'Its brain can outperform a supercomputer. Its IQ (intelligence quotient) is said to be around 5,000.'),

( 66, 'Loves to build its muscles. It trains in all styles of martial arts to become even stronger.'),
( 67, 'Its muscular body is so powerful, it must wear a power-save belt to be able to regulate its motions.'),
( 68, 'Its superpowerful punches are said to knock the victim flying clear over the horizon.'),

( 69, 'A carnivorous POKéMON that traps and eats bugs. It appears to use its root feet to replenish moisture.'),
( 70, 'It spits out POISONPOWDER to immobilize the enemy and then finishes it with a spray of ACID.'),
( 71, 'Said to live in huge colonies deep in jungles, although no one has ever returned from there.'),

( 72, 'Drifts in shallow seas. Anglers who hook them by accident are often punished by their stingers.'),
( 73, 'The tentacles are normally kept short. On hunts, they are extended to ensnare and immobilize prey.'),

( 74, 'Found in fields and mountains. Mistaking them for boulders, people often step or trip on them.'),
( 75, 'Rolls down slopes to move. It rolls over any obstacle without slowing or changing its direction.'),
( 76, 'Its boulder-like body is extremely hard. It can easily withstand dynamite blasts without taking damage.'),

( 77, 'Its hooves are ten times harder than diamond. It can trample anything completely flat in little time.'),
( 78, 'Very competitive, this POKéMON will chase anything that moves fast in the hopes of racing it.'),

( 79, 'Incredibly slow and dopey. It takes five seconds for it to feel pain when under attack.'),
( 80, 'The SHELLDER that latches onto SLOWPOKE''s tail is said to feed on the host''s leftover scraps.'),

( 81, 'Uses antigravity to stay suspended. Appears without warning and uses THUNDER WAVE and similar moves.'),
( 82, 'Formed by several MAGNEMITE linked together. They frequently appear when sunspots flare up.'),

( 83, 'The plant stalk it holds is its weapon. The stalk is used like a sword to cut all sorts of things.'),

( 84, 'A bird that makes up for its poor flying with its fast foot speed. Leaves giant footprints.'),
( 85, 'Uses its three brains to execute complex plans. While two heads sleep, one head is said to stay awake.'),

( 86, 'The protruding horn on its head is very hard. It is used for bashing through thick icebergs.'),
( 87, 'It stores thermal energy in the body. It swims at a steady eight knots even in intensely cold waters.'),

( 88, 'Appears in filthy areas. It thrives by sucking up polluted sludge that is pumped out of factories.'),
( 89, 'Thickly covered with a filthy, vile sludge. It is so toxic, even its footprints contain poison.'),

( 90, 'Its hard shell repels any kind of attack. It is vulnerable only when its shell is open.'),
( 91, 'When attacked, it launches its horns in quick volleys. Its innards have never been seen.'),

( 92, 'Almost invisible, this gaseous POKéMON cloaks the target and puts it to sleep without notice.'),
( 93, 'Because of its ability to slip through block walls, it is said to be from another dimension.'),
( 94, 'On the night of a full moon, if shadows move on their own and laugh, it must be GENGAR''s doing.'),

( 95, 'As it grows, the stone portions of its body harden to become similar to black-colored diamonds.'),

( 96, 'Puts enemies to sleep, then eats their dreams. Occasionally gets sick from eating only bad dreams.'),
( 97, 'When it locks eyes with an enemy, it will use a mix of PSI moves such as HYPNOSIS and CONFUSION.'),

( 98, 'Its pincers are not only powerful weapons, they are used for balance when walking sideways.'),
( 99, 'The large pincer has 10,000-horsepower crushing force. However, its huge size makes it unwieldy to use.'),

(100, 'Usually found in power plants. Easily mistaken for a POKé BALL, it has zapped many people.'),
(101, 'It stores electric energy under very high pressure. It often explodes with little or no provocation.'),

(102, 'It is often mistaken for eggs. When disturbed, they quickly gather and attack in swarms.'),
(103, 'It is said that on rare occasions, one of its heads will drop off and continue on as an EXEGGCUTE.'),

(104, 'Because it never removes its skull helmet, no one has ever seen this POKéMON''s real face.'),
(105, 'The bone it holds is its key weapon. It throws the bone skillfully like a boomerang to KO targets.'),

(106, 'When in a hurry, its legs lengthen progressively. It runs smoothly with extra-long, loping strides.'),
(107, 'While apparently doing nothing, it fires punches in lightning-fast volleys that are impossible to see.'),

(108, 'Its tongue can be extended like a chameleon''s. It leaves a tingling sensation when it licks enemies.'),

(109, 'Because it stores several kinds of toxic gases in its body, it is prone to exploding without warning.'),
(110, 'Where two kinds of poison gases meet, two KOFFING can fuse into a WEEZING over many years.'),

(111, 'Its massive bones are 1,000 times harder than human bones. Its TACKLE can knock a semitrailer flying.'),
(112, 'Protected by an armor-like hide, it is capable of living in molten lava of 3,600 degrees Fahrenheit.'),

(113, 'A rare and elusive POKéMON that is said to bring happiness to those who manage to catch one.'),

(114, 'The whole body is swathed with wide vines that are similar to seaweed. The vines sway as it walks.'),

(115, 'The infant rarely ventures out of its mother''s protective pouch until it is three years old.'),

(116, 'Known to shoot down flying bugs with precision blasts of ink from the surface of the water.'),
(117, 'It is capable of swimming backwards by rapidly flapping its winglike pectoral fins and stout tail.'),

(118, 'Its tail fin billows like an elegant ballroom dress, giving it the nickname of “The Water Queen.”'),
(119, 'In the autumn spawning season, they can be seen swimming powerfully up rivers and creeks.'),

(120, 'An enigmatic POKéMON that can effortlessly regenerate any appendage it loses in battle.'),
(121, 'Its central core glows with the seven colors of the rainbow. Some people value the core as a gem.'),

(122, 'If interrupted while it is miming, it will suddenly DOUBLESLAP the offender with its broad hands.'),

(123, 'With ninja-like agility and speed, it can create the illusion that there is more than one of itself.'),

(124, 'It seductively wiggles its hips as it walks. It can cause people to dance in unison with it.'),

(125, 'Normally found near power plants, they can wander away and cause major blackouts in cities.'),

(126, 'Its body always burns with an orange glow that enables it to hide perfectly amidst flames.'),

(127, 'If it fails to crush the foe in its pincers, it will swing around and toss the opponent.'),

(128, 'When it targets an enemy, it charges furiously while whipping its body with its long tails.'),

(129, 'In the distant past, it was somewhat stronger than the horribly weak descendants that exist today.'),
(130, 'Rarely seen in the wild. Huge and vicious, it is capable of destroying entire cities in a rage.'),

(131, 'A POKéMON that has been overhunted almost to extinction. It can ferry people on its back.'),

(132, 'Capable of copying an opponent''s genetic code to instantly transform itself into a duplicate of the enemy.'),

(133, 'Its genetic code is irregular. It may mutate if it is exposed to radiation from element STONES.'),
(134, 'Lives close to water. Its long tail is ridged with a fin which is often mistaken for a mermaid''s.'),
(135, 'It accumulates negative ions in the atmosphere to blast out 10,000-volt lightning bolts.'),
(136, 'When storing thermal energy in its body, its temperature can soar to over 1,600 degrees Fahrenheit.'),

(137, 'A POKéMON that consists entirely of programming code. It is capable of moving freely in cyberspace.'),

(138, 'Although long extinct, in rare cases, it can be genetically regenerated from fossils.'),
(139, 'Despite having strong fangs and tentacles, it went extinct when its heavy shell made it unable to catch prey.'),

(140, 'A POKéMON that was regenerated from a fossil found in what was once the ocean floor long ago.'),
(141, 'Its sleek shape is perfect for swimming. It slashes prey with its claws and drains their fluids.'),

(142, 'A ferocious, prehistoric POKéMON that goes for the enemy''s throat with its serrated, sawlike fangs.'),

(143, 'Very lazy. Just eats and sleeps. As its rotund bulk builds, it becomes steadily more slothful.'),

(144, 'A legendary bird POKéMON that is said to appear to doomed people who are lost in icy mountains.'),
(145, 'A legendary bird POKéMON that is said to appear from clouds while dropping enormous lightning bolts.'),
(146, 'It is said to be the legendary bird POKéMON of fire. Every flap of its wings creates a dazzling flare of flames.'),

(147, 'Long considered a mythical POKéMON until recently, when a small colony was found living underwater.'),
(148, 'A mystical POKéMON that exudes a gentle aura. It is said to have the ability to change the weather.'),
(149, 'Only a very few people ever see this POKéMON. Its intelligence is said to match that of humans.'),

(150, 'It was created by a scientist after years of horrific gene-splicing and DNA-engineering experiments.'),
(151, 'So rare that it is still said to be a mirage by many experts. Only a few people have seen it worldwide.');
