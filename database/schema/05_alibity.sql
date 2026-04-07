CREATE TABLE ability (
    id               TINYINT           NOT NULL IDENTITY(1,1),
    name             VARCHAR(16)       NOT NULL,
    flavour_text     VARCHAR(256)      NOT NULL,

    CONSTRAINT PK_ability PRIMARY KEY (id),
    CONSTRAINT UQ_ability_name UNIQUE (name)
);
GO


CREATE PROCEDURE get_ability_id
    @p_ability_name   VARCHAR(16),
    @v_ability_id     TINYINT OUTPUT
AS
BEGIN
    SELECT @v_ability_id = id
    FROM ability
    WHERE name = @p_ability_name;

    IF @v_ability_id IS NULL
    BEGIN
        DECLARE @v_msg VARCHAR(32);
        SET @v_msg = @p_ability_name + ' not found!';
        THROW 50000, @v_msg, 1;
    END
END
GO


INSERT INTO ability (name, flavour_text) VALUES
('Adaptability',    ''),
('Arena Trap',      'Prevents the foe from fleeing.'),
('Anger Point',     ''),
('Battle Armor',    'Hard armor protects the Pokémon from critical hits.'),
('Blaze',           'Powers up Fire-type moves in a pinch.'),
('Chlorophyll',     'Boosts the Pokémon''s Speed in sunshine.'),
('Clear Body',      'Prevents other Pokémon from lowering its stats.'),
('Cloud Nine',      'Eliminates the effects of weather.'),
('Compound Eyes',   'Raises the Pokémon''s accuracy.'),
('Cute Charm',      'Contact with the Pokémon may cause infatuation.'),
('Damp',            'Prevents the use of self-destructing moves.'),
('Download',        ''),
('Dry Skin',        ''),
('Early Bird',      'The Pokémon awakens quickly from sleep.'),
('Effect Spore',    'Contact may poison or cause paralysis or sleep.'),
('Forewarn',        ''),
('Filter',          ''),
('Flame Body',      'Contact with the Pokémon may burn the foe.'),
('Flash Fire',      'Powers up Fire-type moves if it''s hit by one.'),
('Guts',            'Boosts Attack if there is a status problem.'),
('Hydration',       ''),
('Hyper Cutter',    'Prevents Attack from being lowered.'),
('Illuminate',      'Raises the likelihood of encountering wild Pokémon.'),
('Immunity',        'Prevents the Pokémon from getting poisoned.'),
('Inner Focus',     'Protects the Pokémon from flinching.'),
('Insomnia',        'Prevents the Pokémon from falling asleep.'),
('Intimidate',      'Lowers the foe''s Attack stat.'),
('Iron Fist',       ''),
('Keen Eye',        'Prevents loss of accuracy.'),
('Leaf Guard',      ''),
('Levitate',        'Gives full immunity to Ground-type moves.'),
('Lightning Rod',   'Draws Electric-type moves to itself.'),
('Limber',          'Prevents the Pokémon from becoming paralyzed.'),
('Liquid Ooze',     'Damages the foe if it drains HP.'),
('Magic Guard',     ''),
('Magnet Pull',     'Prevents Steel-type Pokémon from fleeing.'),
('Mold Breaker',    ''),
('Natural Cure',    'All status problems heal when it switches out.'),
('No Guard',        ''),
('Oblivious',       'Prevents the Pokémon from becoming infatuated.'),
('Overgrow',        'Powers up Grass-type moves in a pinch.'),
('Own Tempo',       'Prevents the Pokémon from becoming confused.'),
('Pickup',          'May pick up items.'),
('Poison Point',    'Contact with the Pokémon may poison the foe.'),
('Pressure',        'The foe uses more PP when attacking.'),
('Reckless',        ''),
('Rivalry',         ''),
('Rock Head',       'Protects the Pokémon from recoil damage.'),
('Run Away',        'Enables sure escape from wild Pokémon.'),
('Sand Veil',       'Boosts evasion in a sandstorm.'),
('Scrappy',         ''),
('Serene Grace',    'Boosts the likelihood of added effects appearing.'),
('Shed Skin',       'The Pokémon may heal its own status problems.'),
('Shell Armor',     'Protects the Pokémon from critical hits.'),
('Shield Dust',     'Blocks the additional effects of attacks taken.'),
('Skill Link',      ''),
('Soundproof',      'Gives immunity to sound-based moves.'),
('Static',          'Contact with the Pokémon may cause paralysis.'),
('Stench',          'May cause the target to flinch.'),
('Sticky Hold',     'Protects the Pokémon''s item from being taken.'),
('Sturdy',          'Negates one-hit KO attacks.'),
('Sniper',          ''),
('Swarm',           'Powers up Bug-type moves in a pinch.'),
('Swift Swim',      'Boosts the Pokémon''s Speed in rain.'),
('Synchronize',     'Passes poison, paralysis, or burn to the foe.'),
('Tangled Feet',    ''),
('Technician',      ''),
('Tinted Lens',     ''),
('Thick Fat',       'Heat and cold protection halves damage.'),
('Torrent',         'Powers up Water-type moves in a pinch.'),
('Trace',           'Copies the foe''s ability.'),
('Vital Spirit',    'Prevents the Pokémon from falling asleep.'),
('Volt Absorb',     'Restores HP if hit by Electric-type moves.'),
('Water Absorb',    'Restores HP if hit by Water-type moves.'),
('Water Veil',      'Prevents the Pokémon from getting burned.');
GO

CREATE TABLE pokemon_ability (
    poke_id          TINYINT           NOT NULL,
    ability_id       TINYINT           NOT NULL,
    slot             TINYINT           NOT NULL,  -- 1 or 2

    CONSTRAINT PK_pa PRIMARY KEY (poke_id, ability_id),
    CONSTRAINT FK_pa_pokemon FOREIGN KEY (poke_id) REFERENCES pokemon(id),
    CONSTRAINT FK_pa_ability FOREIGN KEY (ability_id) REFERENCES ability(id),

    CONSTRAINT UQ_pa_slot UNIQUE (poke_id, slot),
    CONSTRAINT CK_pa_slot CHECK (slot IN (1, 2))
);
GO

CREATE PROCEDURE add_pokemon_ability
    @p_poke_name     VARCHAR(16),
    @p_ability_1     VARCHAR(16),
    @p_ability_2     VARCHAR(16)
AS
BEGIN
    DECLARE @v_poke_id     TINYINT;
    DECLARE @v_ability_id1 TINYINT;
    DECLARE @v_ability_id2 TINYINT;

    EXEC get_pokemon_id @p_poke_name, @v_poke_id OUTPUT;
    EXEC get_ability_id @p_ability_1, @v_ability_id1 OUTPUT;

    INSERT INTO pokemon_ability (poke_id, ability_id, slot)
    VALUES (@v_poke_id, @v_ability_id1, 1);

    IF @p_ability_2 IS NOT NULL AND @p_ability_2 <> ''
    BEGIN
        EXEC get_ability_id @p_ability_2, @v_ability_id2 OUTPUT;

        INSERT INTO pokemon_ability (poke_id, ability_id, slot)
        VALUES (@v_poke_id, @v_ability_id2, 2);
    END
END
GO

EXEC add_pokemon_ability 'Bulbasaur',  'Overgrow',      NULL;
EXEC add_pokemon_ability 'Ivysaur',    'Overgrow',      NULL;
EXEC add_pokemon_ability 'Venusaur',   'Overgrow',      NULL;

EXEC add_pokemon_ability 'Charmander', 'Blaze',         NULL;
EXEC add_pokemon_ability 'Charmeleon', 'Blaze',         NULL;
EXEC add_pokemon_ability 'Charizard',  'Blaze',         NULL;

EXEC add_pokemon_ability 'Squirtle',   'Torrent',       NULL;
EXEC add_pokemon_ability 'Wartortle',  'Torrent',       NULL;
EXEC add_pokemon_ability 'Blastoise',  'Torrent',       NULL;

EXEC add_pokemon_ability 'Caterpie',   'Shield Dust',   NULL;
EXEC add_pokemon_ability 'Metapod',    'Shed Skin',     NULL;
EXEC add_pokemon_ability 'Butterfree', 'Compound Eyes', NULL;

EXEC add_pokemon_ability 'Weedle',     'Shield Dust',   NULL;
EXEC add_pokemon_ability 'Kakuna',     'Shed Skin',     NULL;
EXEC add_pokemon_ability 'Beedrill',   'Swarm',         NULL;

EXEC add_pokemon_ability 'Pidgey',     'Keen Eye',      'Tangled Feet';
EXEC add_pokemon_ability 'Pidgeotto',  'Keen Eye',      'Tangled Feet';
EXEC add_pokemon_ability 'Pidgeot',    'Keen Eye',      'Tangled Feet';

EXEC add_pokemon_ability 'Rattata',    'Run Away',      'Guts';
EXEC add_pokemon_ability 'Raticate',   'Run Away',      'Guts';

EXEC add_pokemon_ability 'Spearow',    'Keen Eye',      NULL;
EXEC add_pokemon_ability 'Fearow',     'Keen Eye',      NULL;

EXEC add_pokemon_ability 'Ekans',      'Intimidate',    'Shed Skin';
EXEC add_pokemon_ability 'Arbok',      'Intimidate',    'Shed Skin';

EXEC add_pokemon_ability 'Pikachu',    'Static',        NULL;
EXEC add_pokemon_ability 'Raichu',     'Static',        NULL;

EXEC add_pokemon_ability 'Sandshrew',  'Sand Veil',     NULL;
EXEC add_pokemon_ability 'Sandslash',  'Sand Veil',     NULL;

EXEC add_pokemon_ability 'Nidoran-F',   'Poison Point',  'Rivalry';
EXEC add_pokemon_ability 'Nidorina',   'Poison Point',  'Rivalry';
EXEC add_pokemon_ability 'Nidoqueen',  'Poison Point',  'Rivalry';

EXEC add_pokemon_ability 'Nidoran-M',   'Poison Point',  'Rivalry';
EXEC add_pokemon_ability 'Nidorino',   'Poison Point',  'Rivalry';
EXEC add_pokemon_ability 'Nidoking',   'Poison Point',  'Rivalry';

EXEC add_pokemon_ability 'Clefairy',   'Cute Charm',    'Magic Guard';
EXEC add_pokemon_ability 'Clefable',   'Cute Charm',    'Magic Guard';

EXEC add_pokemon_ability 'Vulpix',     'Flash Fire',    NULL;
EXEC add_pokemon_ability 'Ninetales',  'Flash Fire',    NULL;

EXEC add_pokemon_ability 'Jigglypuff', 'Cute Charm',    NULL;
EXEC add_pokemon_ability 'Wigglytuff', 'Cute Charm',    NULL;

EXEC add_pokemon_ability 'Zubat',      'Inner Focus',   NULL;
EXEC add_pokemon_ability 'Golbat',     'Inner Focus',   NULL;

EXEC add_pokemon_ability 'Oddish',     'Chlorophyll',   NULL;
EXEC add_pokemon_ability 'Gloom',      'Chlorophyll',   NULL;
EXEC add_pokemon_ability 'Vileplume',  'Chlorophyll',   NULL;

EXEC add_pokemon_ability 'Paras',      'Effect Spore',  'Dry Skin';
EXEC add_pokemon_ability 'Parasect',   'Effect Spore',  'Dry Skin';

EXEC add_pokemon_ability 'Venonat',    'Compound Eyes', 'Tinted Lens';
EXEC add_pokemon_ability 'Venomoth',   'Shield Dust',   'Tinted Lens';

EXEC add_pokemon_ability 'Diglett',    'Sand Veil',     'Arena Trap';
EXEC add_pokemon_ability 'Dugtrio',    'Sand Veil',     'Arena Trap';

EXEC add_pokemon_ability 'Meowth',     'Pickup',        'Technician';
EXEC add_pokemon_ability 'Persian',    'Limber',        'Technician';

EXEC add_pokemon_ability 'Psyduck',    'Damp',          'Cloud Nine';
EXEC add_pokemon_ability 'Golduck',    'Damp',          'Cloud Nine';

EXEC add_pokemon_ability 'Mankey',     'Vital Spirit',  'Anger Point';
EXEC add_pokemon_ability 'Primeape',   'Vital Spirit',  'Anger Point';

EXEC add_pokemon_ability 'Growlithe',  'Intimidate',    'Flash Fire';
EXEC add_pokemon_ability 'Arcanine',   'Intimidate',    'Flash Fire';

EXEC add_pokemon_ability 'Poliwag',    'Water Absorb',  'Damp';
EXEC add_pokemon_ability 'Poliwhirl',  'Water Absorb',  'Damp';
EXEC add_pokemon_ability 'Poliwrath',  'Water Absorb',  'Damp';

EXEC add_pokemon_ability 'Abra',       'Synchronize',   'Inner Focus';
EXEC add_pokemon_ability 'Kadabra',    'Synchronize',   'Inner Focus';
EXEC add_pokemon_ability 'Alakazam',   'Synchronize',   'Inner Focus';

EXEC add_pokemon_ability 'Machop',     'Guts',          'No Guard';
EXEC add_pokemon_ability 'Machoke',    'Guts',          'No Guard';
EXEC add_pokemon_ability 'Machamp',    'Guts',          'No Guard';

EXEC add_pokemon_ability 'Bellsprout', 'Chlorophyll',   NULL;
EXEC add_pokemon_ability 'Weepinbell', 'Chlorophyll',   NULL;
EXEC add_pokemon_ability 'Victreebel', 'Chlorophyll',   NULL;

EXEC add_pokemon_ability 'Tentacool',  'Clear Body',    'Liquid Ooze';
EXEC add_pokemon_ability 'Tentacruel', 'Clear Body',    'Liquid Ooze';

EXEC add_pokemon_ability 'Geodude',    'Rock Head',     'Sturdy';
EXEC add_pokemon_ability 'Graveler',   'Rock Head',     'Sturdy';
EXEC add_pokemon_ability 'Golem',      'Rock Head',     'Sturdy';

EXEC add_pokemon_ability 'Ponyta',     'Run Away',      'Flash Fire';
EXEC add_pokemon_ability 'Rapidash',   'Run Away',      'Flash Fire';

EXEC add_pokemon_ability 'Slowpoke',   'Oblivious',     'Own Tempo';
EXEC add_pokemon_ability 'Slowbro',    'Oblivious',     'Own Tempo';

EXEC add_pokemon_ability 'Magnemite',  'Magnet Pull',   'Sturdy';
EXEC add_pokemon_ability 'Magneton',   'Magnet Pull',   'Sturdy';

EXEC add_pokemon_ability 'Farfetch''d','Keen Eye',      'Inner Focus';

EXEC add_pokemon_ability 'Doduo',      'Run Away',      'Early Bird';
EXEC add_pokemon_ability 'Dodrio',     'Run Away',      'Early Bird';

EXEC add_pokemon_ability 'Seel',       'Thick Fat',     'Hydration';
EXEC add_pokemon_ability 'Dewgong',    'Thick Fat',     'Hydration';

EXEC add_pokemon_ability 'Grimer',     'Stench',        'Sticky Hold';
EXEC add_pokemon_ability 'Muk',        'Stench',        'Sticky Hold';

EXEC add_pokemon_ability 'Shellder',   'Shell Armor',   'Skill Link';
EXEC add_pokemon_ability 'Cloyster',   'Shell Armor',   'Skill Link';

EXEC add_pokemon_ability 'Gastly',     'Levitate',      NULL;
EXEC add_pokemon_ability 'Haunter',    'Levitate',      NULL;
EXEC add_pokemon_ability 'Gengar',     'Levitate',      NULL;

EXEC add_pokemon_ability 'Onix',       'Rock Head',     'Sturdy';

EXEC add_pokemon_ability 'Drowzee',    'Insomnia',      'Forewarn';
EXEC add_pokemon_ability 'Hypno',      'Insomnia',      'Forewarn';

EXEC add_pokemon_ability 'Krabby',     'Hyper Cutter',  'Shell Armor';
EXEC add_pokemon_ability 'Kingler',    'Hyper Cutter',  'Shell Armor';

EXEC add_pokemon_ability 'Voltorb',    'Soundproof',    'Static';
EXEC add_pokemon_ability 'Electrode',  'Soundproof',    'Static';

EXEC add_pokemon_ability 'Exeggcute',  'Chlorophyll',   NULL;
EXEC add_pokemon_ability 'Exeggutor',  'Chlorophyll',   NULL;

EXEC add_pokemon_ability 'Cubone',     'Rock Head',     'Lightning Rod';
EXEC add_pokemon_ability 'Marowak',    'Rock Head',     'Lightning Rod';

EXEC add_pokemon_ability 'Hitmonlee',  'Limber',        'Reckless';
EXEC add_pokemon_ability 'Hitmonchan', 'Keen Eye',      'Iron Fist';

EXEC add_pokemon_ability 'Lickitung',  'Own Tempo',     'Oblivious';

EXEC add_pokemon_ability 'Koffing',    'Levitate',      NULL;
EXEC add_pokemon_ability 'Weezing',    'Levitate',      NULL;

EXEC add_pokemon_ability 'Rhyhorn',    'Lightning Rod',  'Rock Head';
EXEC add_pokemon_ability 'Rhydon',     'Lightning Rod',  'Rock Head';

EXEC add_pokemon_ability 'Chansey',    'Natural Cure',  'Serene Grace';

EXEC add_pokemon_ability 'Tangela',    'Chlorophyll',   'Leaf Guard';

EXEC add_pokemon_ability 'Kangaskhan', 'Early Bird',    'Scrappy';

EXEC add_pokemon_ability 'Horsea',     'Swift Swim',    'Sniper';
EXEC add_pokemon_ability 'Seadra',     'Poison Point',  'Sniper';

EXEC add_pokemon_ability 'Goldeen',    'Swift Swim',    'Water Veil';
EXEC add_pokemon_ability 'Seaking',    'Swift Swim',    'Water Veil';

EXEC add_pokemon_ability 'Staryu',     'Illuminate',    'Natural Cure';
EXEC add_pokemon_ability 'Starmie',    'Illuminate',    'Natural Cure';

EXEC add_pokemon_ability 'Mr. Mime',   'Soundproof',    'Filter';

EXEC add_pokemon_ability 'Scyther',    'Swarm',         'Technician';

EXEC add_pokemon_ability 'Jynx',       'Oblivious',     'Forewarn';

EXEC add_pokemon_ability 'Electabuzz', 'Static',        NULL;

EXEC add_pokemon_ability 'Magmar',     'Flame Body',    NULL;

EXEC add_pokemon_ability 'Pinsir',     'Hyper Cutter',  'Mold Breaker';

EXEC add_pokemon_ability 'Tauros',     'Intimidate',    'Anger Point';

EXEC add_pokemon_ability 'Magikarp',   'Swift Swim',    NULL;
EXEC add_pokemon_ability 'Gyarados',   'Intimidate',    NULL;

EXEC add_pokemon_ability 'Lapras',     'Water Absorb',  'Shell Armor';

EXEC add_pokemon_ability 'Ditto',      'Limber',        NULL;

EXEC add_pokemon_ability 'Eevee',      'Run Away',      'Adaptability';
EXEC add_pokemon_ability 'Vaporeon',   'Water Absorb',  NULL;
EXEC add_pokemon_ability 'Jolteon',    'Volt Absorb',   NULL;
EXEC add_pokemon_ability 'Flareon',    'Flash Fire',    NULL;

EXEC add_pokemon_ability 'Porygon',    'Trace',         'Download';

EXEC add_pokemon_ability 'Omanyte',    'Swift Swim',    'Shell Armor';
EXEC add_pokemon_ability 'Omastar',    'Swift Swim',    'Shell Armor';

EXEC add_pokemon_ability 'Kabuto',     'Swift Swim',    'Battle Armor';
EXEC add_pokemon_ability 'Kabutops',   'Swift Swim',    'Battle Armor';

EXEC add_pokemon_ability 'Aerodactyl', 'Rock Head',     'Pressure';

EXEC add_pokemon_ability 'Snorlax',    'Immunity',      'Thick Fat';

EXEC add_pokemon_ability 'Articuno',   'Pressure',      NULL;
EXEC add_pokemon_ability 'Zapdos',     'Pressure',      NULL;
EXEC add_pokemon_ability 'Moltres',    'Pressure',      NULL;

EXEC add_pokemon_ability 'Dratini',    'Shed Skin',     NULL;
EXEC add_pokemon_ability 'Dragonair',  'Shed Skin',     NULL;
EXEC add_pokemon_ability 'Dragonite',  'Inner Focus',   NULL;

EXEC add_pokemon_ability 'Mewtwo',     'Pressure',      NULL;
EXEC add_pokemon_ability 'Mew',        'Synchronize',   NULL;
