CREATE TABLE Pokemon (
    id               TINYINT           NOT NULL,  -- National Dex number; seeded with Kanto (001–151)
    name             VARCHAR(16)       NOT NULL,
    category         VARCHAR(16)       NOT NULL,  -- e.g. SEED POKéMON
    height           DECIMAL(2,1)      NOT NULL,  -- in meter
    weight           DECIMAL(4,1)      NOT NULL,  -- in kilogram
    flavour_text_id  TINYINT           NOT NULL,

    catch_rate       TINYINT           NOT NULL,  -- 0-255
    base_exp         SMALLINT          NOT NULL,
    growth_rate_id   TINYINT           NOT NULL,
    habitat_id       TINYINT           NOT NULL,
    gender_ratio     SMALLINT          NOT NULL,  -- chance of being female, in eighths; or -1 for genderless

    CONSTRAINT PK_Pokemon PRIMARY KEY (id),
    CONSTRAINT FK_Pokemon_PokedexEntry FOREIGN KEY (flavour_text_id) REFERENCES PokedexEntry(id),
    CONSTRAINT FK_Pokemon_GrowthRate   FOREIGN KEY (growth_rate_id)  REFERENCES GrowthRate(id),
    CONSTRAINT FK_Pokemon_Habitat      FOREIGN KEY (habitat_id)      REFERENCES Habitat(id),

    CONSTRAINT UQ_Pokemon_name UNIQUE (name)
);

CREATE INDEX IDX_Pokemon_name ON Pokemon (name);

GO

CREATE PROCEDURE GetPokemonId
    @p_poke_name VARCHAR(16),
    @v_poke_id   TINYINT OUTPUT
AS
BEGIN
    SELECT @v_poke_id = id
    FROM Pokemon
    WHERE name = @p_poke_name;

    IF @v_poke_id IS NULL
    BEGIN
        DECLARE @v_msg VARCHAR(32);
        SET @v_msg = @p_poke_name + ' not found!';
        THROW 50000, @v_msg, 1;
    END
END

GO

CREATE PROCEDURE AddPokemon 
    @p_id           TINYINT,
    @p_name         VARCHAR(16),
    @p_category     VARCHAR(16),
    @p_height       DECIMAL(2,1),
    @p_weight       DECIMAL(4,1),

    @p_catch_rate   TINYINT,
    @p_base_exp     SMALLINT,
    @p_growth_rate  VARCHAR(16),
    @p_habitat      VARCHAR(16),
    @p_gender_ratio SMALLINT
AS
BEGIN
    DECLARE @v_growth_rate_id TINYINT;
    DECLARE @v_habitat_id     TINYINT;

    EXEC GetGrowthRateId @p_name = @p_growth_rate, @v_id = @v_growth_rate_id OUTPUT;
    EXEC GetHabitatId    @p_name = @p_habitat,     @v_id = @v_habitat_id     OUTPUT;

    INSERT INTO Pokemon VALUES
        (@p_id, @p_name, @p_category, @p_height, @p_weight, @p_id, @p_catch_rate, @p_base_exp, @v_growth_rate_id, @v_habitat_id, @p_gender_ratio);
END

GO

-- =============================================================

--               id   name          category     height   weight  catch_rate  base_exp   growth_rate    habitat      g_ratio
EXEC AddPokemon   1, 'Bulbasaur',  'Seed',          0.7,     6.9,         45,       64, 'Medium Slow',  'Grassland',       1;
EXEC AddPokemon   2, 'Ivysaur',    'Seed',          1.0,    13.0,         45,      142, 'Medium Slow',  'Grassland',       1;
EXEC AddPokemon   3, 'Venusaur',   'Seed',          2.0,   100.0,         45,      236, 'Medium Slow',  'Grassland',       1;

EXEC AddPokemon   4, 'Charmander', 'Lizard',        0.6,     8.5,         45,       62, 'Medium Slow',  'Mountain',        1;
EXEC AddPokemon   5, 'Charmeleon', 'Flame',         1.1,    19.0,         45,      142, 'Medium Slow',  'Mountain',        1;
EXEC AddPokemon   6, 'Charizard',  'Flame',         1.7,    90.5,         45,      240, 'Medium Slow',  'Mountain',        1;

EXEC AddPokemon   7, 'Squirtle',   'Tiny Turtle',   0.5,     9.0,         45,       63, 'Medium Slow',  'Water''s-edge',   1;
EXEC AddPokemon   8, 'Wartortle',  'Turtle',        1.0,    22.5,         45,      142, 'Medium Slow',  'Water''s-edge',   1;
EXEC AddPokemon   9, 'Blastoise',  'Shellfish',     1.6,    85.5,         45,      239, 'Medium Slow',  'Water''s-edge',   1;

EXEC AddPokemon  10, 'Caterpie',   'Worm',          0.3,     2.9,        255,       39, 'Medium Fast',  'Forest',          4;
EXEC AddPokemon  11, 'Metapod',    'Cocoon',        0.7,     9.9,        120,       72, 'Medium Fast',  'Forest',          4;
EXEC AddPokemon  12, 'Butterfree', 'Butterfly',     1.1,    32.0,         45,      178, 'Medium Fast',  'Forest',          4;

EXEC AddPokemon  13, 'Weedle',     'Hairy Bug',     0.3,     3.2,        255,       39, 'Medium Fast',  'Forest',          4;
EXEC AddPokemon  14, 'Kakuna',     'Cocoon',        0.6,    10.0,        120,       72, 'Medium Fast',  'Forest',          4;
EXEC AddPokemon  15, 'Beedrill',   'Poison Bee',    1.0,    29.5,         45,      178, 'Medium Fast',  'Forest',          4;

EXEC AddPokemon  16, 'Pidgey',     'Tiny Bird',     0.3,     1.8,        255,       50, 'Medium Slow',  'Forest',          4;
EXEC AddPokemon  17, 'Pidgeotto',  'Bird',          1.1,    30.0,        120,      122, 'Medium Slow',  'Forest',          4;
EXEC AddPokemon  18, 'Pidgeot',    'Bird',          1.5,    39.5,         45,      216, 'Medium Slow',  'Forest',          4;

EXEC AddPokemon  19, 'Rattata',    'Mouse',         0.3,     3.5,        255,       51, 'Medium Fast',  'Grassland',       4;
EXEC AddPokemon  20, 'Raticate',   'Mouse',         0.7,    18.5,        127,      145, 'Medium Fast',  'Grassland',       4;

EXEC AddPokemon  21, 'Spearow',    'Tiny Bird',     0.3,     2.0,        255,       52, 'Medium Fast',  'Rough-terrain',   4;
EXEC AddPokemon  22, 'Fearow',     'Beak',          1.2,    38.0,         90,      155, 'Medium Fast',  'Rough-terrain',   4;

EXEC AddPokemon  23, 'Ekans',      'Snake',         2.0,     6.9,        255,       58, 'Medium Fast',  'Grassland',       4;
EXEC AddPokemon  24, 'Arbok',      'Cobra',         3.5,    65.0,         90,      157, 'Medium Fast',  'Grassland',       4;

EXEC AddPokemon  25, 'Pikachu',    'Mouse',         0.4,     6.0,        190,      112, 'Medium Fast',  'Forest',          4;
EXEC AddPokemon  26, 'Raichu',     'Mouse',         0.8,    30.0,         75,      218, 'Medium Fast',  'Forest',          4;

EXEC AddPokemon  27, 'Sandshrew',  'Mouse',         0.6,    12.0,        255,       60, 'Medium Fast',  'Rough-terrain',   4;
EXEC AddPokemon  28, 'Sandslash',  'Mouse',         1.0,    29.5,         90,      158, 'Medium Fast',  'Rough-terrain',   4;

EXEC AddPokemon  29, 'Nidoran-F',  'Poison Pin',    0.4,     7.0,        235,       55, 'Medium Slow',  'Grassland',       8;
EXEC AddPokemon  30, 'Nidorina',   'Poison Pin',    0.8,    20.0,        120,      128, 'Medium Slow',  'Grassland',       8;
EXEC AddPokemon  31, 'Nidoqueen',  'Drill',         1.3,    60.0,         45,      227, 'Medium Slow',  'Grassland',       8;

EXEC AddPokemon  32, 'Nidoran-M',  'Poison Pin',    0.5,     9.0,        235,       55, 'Medium Slow',  'Grassland',       0;
EXEC AddPokemon  33, 'Nidorino',   'Poison Pin',    0.9,    19.5,        120,      128, 'Medium Slow',  'Grassland',       0;
EXEC AddPokemon  34, 'Nidoking',   'Drill',         1.4,    62.0,         45,      227, 'Medium Slow',  'Grassland',       0;

EXEC AddPokemon  35, 'Clefairy',   'Fairy',         0.6,     7.5,        150,      113, 'Fast',         'Mountain',        6;
EXEC AddPokemon  36, 'Clefable',   'Fairy',         1.3,    40.0,         25,      217, 'Fast',         'Mountain',        6;

EXEC AddPokemon  37, 'Vulpix',     'Fox',           0.6,     9.9,        190,       60, 'Medium Fast',  'Grassland',       6;
EXEC AddPokemon  38, 'Ninetales',  'Fox',           1.1,    19.9,         75,      177, 'Medium Fast',  'Grassland',       6;

EXEC AddPokemon  39, 'Jigglypuff', 'Balloon',       0.5,     5.5,        170,       95, 'Fast',         'Grassland',       6;
EXEC AddPokemon  40, 'Wigglytuff', 'Balloon',       1.0,    12.0,         50,      196, 'Fast',         'Grassland',       6;

EXEC AddPokemon  41, 'Zubat',      'Bat',           0.8,     7.5,        255,       49, 'Medium Fast',  'Cave',            4;
EXEC AddPokemon  42, 'Golbat',     'Bat',           1.6,    55.0,         90,      159, 'Medium Fast',  'Cave',            4;

EXEC AddPokemon  43, 'Oddish',     'Weed',          0.5,     5.4,        255,       64, 'Medium Slow',  'Grassland',       4;
EXEC AddPokemon  44, 'Gloom',      'Weed',          0.8,     8.6,        120,      138, 'Medium Slow',  'Grassland',       4;
EXEC AddPokemon  45, 'Vileplume',  'Flower',        1.2,    18.6,         45,      221, 'Medium Slow',  'Grassland',       4;

EXEC AddPokemon  46, 'Paras',      'Mushroom',      0.3,     5.4,        190,       57, 'Medium Fast',  'Forest',          4;
EXEC AddPokemon  47, 'Parasect',   'Mushroom',      1.0,    29.5,         75,      142, 'Medium Fast',  'Forest',          4;

EXEC AddPokemon  48, 'Venonat',    'Insect',        1.0,    30.0,        190,       61, 'Medium Fast',  'Forest',          4;
EXEC AddPokemon  49, 'Venomoth',   'Poison Moth',   1.5,    12.5,         75,      158, 'Medium Fast',  'Forest',          4;

EXEC AddPokemon  50, 'Diglett',    'Mole',          0.2,     0.8,        255,       53, 'Medium Fast',  'Cave',            4;
EXEC AddPokemon  51, 'Dugtrio',    'Mole',          0.7,    33.3,         50,      149, 'Medium Fast',  'Cave',            4;

EXEC AddPokemon  52, 'Meowth',     'Scratch Cat',   0.4,     4.2,        255,       58, 'Medium Fast',  'Urban',           4;
EXEC AddPokemon  53, 'Persian',    'Classy Cat',    1.0,    32.0,         90,      154, 'Medium Fast',  'Urban',           4;

EXEC AddPokemon  54, 'Psyduck',    'Duck',          0.8,    19.6,        190,       64, 'Medium Fast',  'Water''s-edge',   4;
EXEC AddPokemon  55, 'Golduck',    'Duck',          1.7,    76.6,         75,      175, 'Medium Fast',  'Water''s-edge',   4;

EXEC AddPokemon  56, 'Mankey',     'Pig Monkey',    0.5,    28.0,        190,       61, 'Medium Fast',  'Mountain',        4;
EXEC AddPokemon  57, 'Primeape',   'Pig Monkey',    1.0,    32.0,         75,      159, 'Medium Fast',  'Mountain',        4;

EXEC AddPokemon  58, 'Growlithe',  'Puppy',         0.7,    19.0,        190,       70, 'Slow',         'Grassland',       2;
EXEC AddPokemon  59, 'Arcanine',   'Legendary',     1.9,   155.0,         75,      194, 'Slow',         'Grassland',       2;

EXEC AddPokemon  60, 'Poliwag',    'Tadpole',       0.6,    12.4,        255,       60, 'Medium Slow',  'Water''s-edge',   4;
EXEC AddPokemon  61, 'Poliwhirl',  'Tadpole',       1.0,    20.0,        120,      135, 'Medium Slow',  'Water''s-edge',   4;
EXEC AddPokemon  62, 'Poliwrath',  'Tadpole',       1.3,    54.0,         45,      230, 'Medium Slow',  'Water''s-edge',   4;

EXEC AddPokemon  63, 'Abra',       'Psi',           0.9,    19.5,        200,       62, 'Medium Slow',  'Urban',           2;
EXEC AddPokemon  64, 'Kadabra',    'Psi',           1.3,    56.5,        100,      140, 'Medium Slow',  'Urban',           2;
EXEC AddPokemon  65, 'Alakazam',   'Psi',           1.5,    48.0,         50,      225, 'Medium Slow',  'Urban',           2;

EXEC AddPokemon  66, 'Machop',     'Superpower',    0.8,    19.5,        180,       61, 'Medium Slow',  'Mountain',        2;
EXEC AddPokemon  67, 'Machoke',    'Superpower',    1.5,    70.5,         90,      142, 'Medium Slow',  'Mountain',        2;
EXEC AddPokemon  68, 'Machamp',    'Superpower',    1.6,   130.0,         45,      227, 'Medium Slow',  'Mountain',        2;

EXEC AddPokemon  69, 'Bellsprout', 'Flower',        0.7,     4.0,        255,       60, 'Medium Slow',  'Forest',          4;
EXEC AddPokemon  70, 'Weepinbell', 'Flycatcher',    1.0,     6.4,        120,      137, 'Medium Slow',  'Forest',          4;
EXEC AddPokemon  71, 'Victreebel', 'Flycatcher',    1.7,    15.5,         45,      221, 'Medium Slow',  'Forest',          4;

EXEC AddPokemon  72, 'Tentacool',  'Jellyfish',     0.9,    45.5,        190,       67, 'Slow',         'Sea',             4;
EXEC AddPokemon  73, 'Tentacruel', 'Jellyfish',     1.6,    55.0,         60,      180, 'Slow',         'Sea',             4;

EXEC AddPokemon  74, 'Geodude',    'Rock',          0.4,    20.0,        255,       60, 'Medium Slow',  'Mountain',        4;
EXEC AddPokemon  75, 'Graveler',   'Rock',          1.0,   105.0,        120,      137, 'Medium Slow',  'Mountain',        4;
EXEC AddPokemon  76, 'Golem',      'Megaton',       1.4,   300.0,         45,      223, 'Medium Slow',  'Mountain',        4;

EXEC AddPokemon  77, 'Ponyta',     'Fire Horse',    1.0,    30.0,        190,       82, 'Medium Fast',  'Grassland',       4;
EXEC AddPokemon  78, 'Rapidash',   'Fire Horse',    1.7,    95.0,         60,      175, 'Medium Fast',  'Grassland',       4;

EXEC AddPokemon  79, 'Slowpoke',   'Dopey',         1.2,    36.0,        190,       63, 'Medium Fast',  'Water''s-edge',   4;
EXEC AddPokemon  80, 'Slowbro',    'Hermit Crab',   1.6,    78.5,         75,      172, 'Medium Fast',  'Water''s-edge',   4;

EXEC AddPokemon  81, 'Magnemite',  'Magnet',        0.3,     6.0,        190,       65, 'Medium Fast',  'Rough-terrain',  -1;
EXEC AddPokemon  82, 'Magneton',   'Magnet',        1.0,    60.0,         60,      163, 'Medium Fast',  'Rough-terrain',  -1;

EXEC AddPokemon  83, 'Farfetch''d','Wild Duck',     0.8,    15.0,         45,      132, 'Medium Fast',  'Grassland',       4;

EXEC AddPokemon  84, 'Doduo',      'Twin Bird',     1.4,    39.2,        190,       62, 'Medium Fast',  'Grassland',       4;
EXEC AddPokemon  85, 'Dodrio',     'Triple Bird',   1.8,    85.2,         45,      165, 'Medium Fast',  'Grassland',       4;

EXEC AddPokemon  86, 'Seel',       'Sea Lion',      1.1,    90.0,        190,       65, 'Medium Fast',  'Sea',             4;
EXEC AddPokemon  87, 'Dewgong',    'Sea Lion',      1.7,   120.0,         75,      166, 'Medium Fast',  'Sea',             4;

EXEC AddPokemon  88, 'Grimer',     'Sludge',        0.9,    30.0,        190,       65, 'Medium Fast',  'Urban',           4;
EXEC AddPokemon  89, 'Muk',        'Sludge',        1.2,    30.0,         75,      175, 'Medium Fast',  'Urban',           4;

EXEC AddPokemon  90, 'Shellder',   'Bivalve',       0.3,     4.0,        190,       61, 'Slow',         'Sea',             4;
EXEC AddPokemon  91, 'Cloyster',   'Bivalve',       1.5,   132.5,         60,      184, 'Slow',         'Sea',             4;

EXEC AddPokemon  92, 'Gastly',     'Gas',           1.3,     0.1,        190,       62, 'Medium Slow',  'Cave',            4;
EXEC AddPokemon  93, 'Haunter',    'Gas',           1.6,     0.1,         90,      142, 'Medium Slow',  'Cave',            4;
EXEC AddPokemon  94, 'Gengar',     'Shadow',        1.5,    40.5,         45,      225, 'Medium Slow',  'Cave',            4;

EXEC AddPokemon  95, 'Onix',       'Rock Snake',    8.8,   210.0,         45,       77, 'Medium Fast',  'Cave',            4;

EXEC AddPokemon  96, 'Drowzee',    'Hypnosis',      1.0,    32.4,        190,       66, 'Medium Fast',  'Grassland',       4;
EXEC AddPokemon  97, 'Hypno',      'Hypnosis',      1.6,    75.6,         75,      169, 'Medium Fast',  'Grassland',       4;

EXEC AddPokemon  98, 'Krabby',     'River Crab',    0.4,     6.5,        225,       65, 'Medium Fast',  'Water''s-edge',   4;
EXEC AddPokemon  99, 'Kingler',    'Pincer',        1.3,    60.0,         60,      166, 'Medium Fast',  'Water''s-edge',   4;

EXEC AddPokemon 100, 'Voltorb',    'Ball',          0.5,    10.4,        190,       66, 'Medium Fast',  'Urban',          -1;
EXEC AddPokemon 101, 'Electrode',  'Ball',          1.2,    66.6,         60,      172, 'Medium Fast',  'Urban',          -1;

EXEC AddPokemon 102, 'Exeggcute',  'Egg',           0.4,     2.5,         90,       65, 'Slow',         'Forest',          4;
EXEC AddPokemon 103, 'Exeggutor',  'Coconut',       2.0,   120.0,         45,      186, 'Slow',         'Forest',          4;

EXEC AddPokemon 104, 'Cubone',     'Lonely',        0.4,     6.5,        190,       64, 'Medium Fast',  'Mountain',        4;
EXEC AddPokemon 105, 'Marowak',    'Bone Keeper',   1.0,    45.0,         75,      149, 'Medium Fast',  'Mountain',        4;

EXEC AddPokemon 106, 'Hitmonlee',  'Kicking',       1.5,    49.8,         45,      159, 'Medium Fast',  'Urban',           0;
EXEC AddPokemon 107, 'Hitmonchan', 'Punching',      1.4,    50.2,         45,      159, 'Medium Fast',  'Urban',           0;

EXEC AddPokemon 108, 'Lickitung',  'Licking',       1.2,    65.5,         45,       77, 'Medium Fast',  'Grassland',       4;

EXEC AddPokemon 109, 'Koffing',    'Poison Gas',    0.6,     1.0,        190,       68, 'Medium Fast',  'Urban',           4;
EXEC AddPokemon 110, 'Weezing',    'Poison Gas',    1.2,     9.5,         60,      172, 'Medium Fast',  'Urban',           4;

EXEC AddPokemon 111, 'Rhyhorn',    'Spikes',        1.0,   115.0,        120,       69, 'Slow',         'Rough-terrain',   4;
EXEC AddPokemon 112, 'Rhydon',     'Drill',         1.9,   120.0,         60,      170, 'Slow',         'Rough-terrain',   4;

EXEC AddPokemon 113, 'Chansey',    'Egg',           1.1,    34.6,         30,      395, 'Fast',         'Urban',           8;

EXEC AddPokemon 114, 'Tangela',    'Vine',          1.0,    35.0,         45,       87, 'Medium Fast',  'Grassland',       4;

EXEC AddPokemon 115, 'Kangaskhan', 'Parent',        2.2,    80.0,         45,      172, 'Medium Fast',  'Grassland',       8;

EXEC AddPokemon 116, 'Horsea',     'Dragon',        0.4,     8.0,        225,       59, 'Medium Fast',  'Sea',             4;
EXEC AddPokemon 117, 'Seadra',     'Dragon',        1.2,    25.0,         75,      154, 'Medium Fast',  'Sea',             4;

EXEC AddPokemon 118, 'Goldeen',    'Goldfish',      0.6,    15.0,        225,       64, 'Medium Fast',  'Water''s-edge',   4;
EXEC AddPokemon 119, 'Seaking',    'Goldfish',      1.3,    39.0,         60,      158, 'Medium Fast',  'Water''s-edge',   4;

EXEC AddPokemon 120, 'Staryu',     'Star Shape',    0.8,    34.5,        225,       68, 'Slow',         'Sea',            -1;
EXEC AddPokemon 121, 'Starmie',    'Mysterious',    1.1,    80.0,         60,      182, 'Slow',         'Sea',            -1;

EXEC AddPokemon 122, 'Mr. Mime',   'Barrier',       1.3,    54.5,         45,      161, 'Medium Fast',  'Urban',           4;

EXEC AddPokemon 123, 'Scyther',    'Mantis',        1.5,    56.0,         45,      100, 'Medium Fast',  'Grassland',       4;

EXEC AddPokemon 124, 'Jynx',       'Human Shape',   1.4,    40.6,         45,      159, 'Medium Fast',  'Urban',           8;

EXEC AddPokemon 125, 'Electabuzz', 'Electric',      1.1,    30.0,         45,      172, 'Medium Fast',  'Grassland',       2;

EXEC AddPokemon 126, 'Magmar',     'Spitfire',      1.3,    44.5,         45,      173, 'Medium Fast',  'Mountain',        2;

EXEC AddPokemon 127, 'Pinsir',     'Stag Beetle',   1.5,    55.0,         45,      175, 'Slow',         'Forest',          4;

EXEC AddPokemon 128, 'Tauros',     'Wild Bull',     1.4,    88.4,         45,      172, 'Slow',         'Grassland',       0;

EXEC AddPokemon 129, 'Magikarp',   'Fish',          0.9,    10.0,        255,       40, 'Slow',         'Water''s-edge',   4;
EXEC AddPokemon 130, 'Gyarados',   'Atrocious',     6.5,   235.0,         45,      189, 'Slow',         'Water''s-edge',   4;

EXEC AddPokemon 131, 'Lapras',     'Transport',     2.5,   220.0,         45,      187, 'Slow',         'Sea',             4;

EXEC AddPokemon 132, 'Ditto',      'Transform',     0.3,     4.0,         35,      101, 'Medium Fast',  'Urban',          -1;

EXEC AddPokemon 133, 'Eevee',      'Evolution',     0.3,     6.5,         45,       65, 'Medium Fast',  'Urban',           1;
EXEC AddPokemon 134, 'Vaporeon',   'Bubble Jet',    1.0,    29.0,         45,      184, 'Medium Fast',  'Urban',           1;
EXEC AddPokemon 135, 'Jolteon',    'Lightning',     0.8,    24.5,         45,      184, 'Medium Fast',  'Urban',           1;
EXEC AddPokemon 136, 'Flareon',    'Flame',         0.9,    25.0,         45,      184, 'Medium Fast',  'Urban',           1;

EXEC AddPokemon 137, 'Porygon',    'Virtual',       0.8,    36.5,         45,       79, 'Medium Fast',  'Urban',          -1;

EXEC AddPokemon 138, 'Omanyte',    'Spiral',        0.4,     7.5,         45,       71, 'Medium Fast',  'Sea',             1;
EXEC AddPokemon 139, 'Omastar',    'Spiral',        1.0,    35.0,         45,      173, 'Medium Fast',  'Sea',             1;

EXEC AddPokemon 140, 'Kabuto',     'Shellfish',     0.5,    11.5,         45,       71, 'Medium Fast',  'Sea',             1;
EXEC AddPokemon 141, 'Kabutops',   'Shellfish',     1.3,    40.5,         45,      173, 'Medium Fast',  'Sea',             1;

EXEC AddPokemon 142, 'Aerodactyl', 'Fossil',        1.8,    59.0,         45,      180, 'Slow',         'Mountain',        1;

EXEC AddPokemon 143, 'Snorlax',    'Sleeping',      2.1,   460.0,         25,      189, 'Slow',         'Mountain',        1;

EXEC AddPokemon 144, 'Articuno',   'Freeze',        1.7,    55.4,          3,      261, 'Slow',         'Rare',           -1;
EXEC AddPokemon 145, 'Zapdos',     'Electric',      1.6,    52.6,          3,      261, 'Slow',         'Rare',           -1;
EXEC AddPokemon 146, 'Moltres',    'Flame',         2.0,    60.0,          3,      261, 'Slow',         'Rare',           -1;

EXEC AddPokemon 147, 'Dratini',    'Dragon',        1.8,     3.3,         45,       60, 'Slow',         'Water''s-edge',   4;
EXEC AddPokemon 148, 'Dragonair',  'Dragon',        4.0,    16.5,         45,      147, 'Slow',         'Water''s-edge',   4;
EXEC AddPokemon 149, 'Dragonite',  'Dragon',        2.2,   210.0,         45,      270, 'Slow',         'Water''s-edge',   4;

EXEC AddPokemon 150, 'Mewtwo',     'Genetic',       2.0,   122.0,          3,      306, 'Slow',         'Rare',           -1;
EXEC AddPokemon 151, 'Mew',        'New Species',   0.4,     4.0,         45,      270, 'Medium Slow',  'Rare',           -1;
