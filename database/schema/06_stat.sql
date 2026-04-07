CREATE TABLE stats (
    id               TINYINT          NOT NULL,

    hp               TINYINT           NOT NULL,
    attack           TINYINT           NOT NULL,
    defense          TINYINT           NOT NULL,
    sp_atk           TINYINT           NOT NULL,
    sp_def           TINYINT           NOT NULL,
    speed            TINYINT           NOT NULL,

    CONSTRAINT PK_stats PRIMARY KEY (id)
);
GO

CREATE PROCEDURE add_pokemon_stats
    @p_poke_name       VARCHAR(16),
    @p_hp              TINYINT,
    @p_attack          TINYINT,
    @p_defense         TINYINT,
    @p_sp_atk          TINYINT,
    @p_sp_def          TINYINT,
    @p_speed           TINYINT
AS
BEGIN
    DECLARE @v_poke_id TINYINT;

    EXEC get_pokemon_id @p_poke_name, @v_poke_id OUTPUT;

    INSERT INTO stats (id, hp, attack, defense, sp_atk, sp_def, speed)
    VALUES (@v_poke_id, @p_hp, @p_attack, @p_defense, @p_sp_atk, @p_sp_def, @p_speed);
END;
GO

-- =============================================================

--                      name              hp     atk     def  sp_atk  sp_def     spd
EXEC add_pokemon_stats 'Bulbasaur',       45,     49,     49,     65,     65,     45;
EXEC add_pokemon_stats 'Ivysaur',         60,     62,     63,     80,     80,     60;
EXEC add_pokemon_stats 'Venusaur',        80,     82,     83,    100,    100,     80;
EXEC add_pokemon_stats 'Charmander',      39,     52,     43,     60,     50,     65;
EXEC add_pokemon_stats 'Charmeleon',      58,     64,     58,     80,     65,     80;
EXEC add_pokemon_stats 'Charizard',       78,     84,     78,    109,     85,    100;
EXEC add_pokemon_stats 'Squirtle',        44,     48,     65,     50,     64,     43;
EXEC add_pokemon_stats 'Wartortle',       59,     63,     80,     65,     80,     58;
EXEC add_pokemon_stats 'Blastoise',       79,     83,    100,     85,    105,     78;
EXEC add_pokemon_stats 'Caterpie',        45,     30,     35,     20,     20,     45;
EXEC add_pokemon_stats 'Metapod',         50,     20,     55,     25,     25,     30;
EXEC add_pokemon_stats 'Butterfree',      60,     45,     50,     90,     80,     70;
EXEC add_pokemon_stats 'Weedle',          40,     35,     30,     20,     20,     50;
EXEC add_pokemon_stats 'Kakuna',          45,     25,     50,     25,     25,     35;
EXEC add_pokemon_stats 'Beedrill',        65,     90,     40,     45,     80,     75;
EXEC add_pokemon_stats 'Pidgey',          40,     45,     40,     35,     35,     56;
EXEC add_pokemon_stats 'Pidgeotto',       63,     60,     55,     50,     50,     71;
EXEC add_pokemon_stats 'Pidgeot',         83,     80,     75,     70,     70,    101;
EXEC add_pokemon_stats 'Rattata',         30,     56,     35,     25,     35,     72;
EXEC add_pokemon_stats 'Raticate',        55,     81,     60,     50,     70,     97;
EXEC add_pokemon_stats 'Spearow',         40,     60,     30,     31,     31,     70;
EXEC add_pokemon_stats 'Fearow',          65,     90,     65,     61,     61,    100;
EXEC add_pokemon_stats 'Ekans',           35,     60,     44,     40,     54,     55;
EXEC add_pokemon_stats 'Arbok',           60,     95,     69,     65,     79,     80;
EXEC add_pokemon_stats 'Pikachu',         35,     55,     40,     50,     50,     90;
EXEC add_pokemon_stats 'Raichu',          60,     90,     55,     90,     80,    110;
EXEC add_pokemon_stats 'Sandshrew',       50,     75,     85,     20,     30,     40;
EXEC add_pokemon_stats 'Sandslash',       75,    100,    110,     45,     55,     65;
EXEC add_pokemon_stats 'Nidoran-F',       55,     47,     52,     40,     40,     41;
EXEC add_pokemon_stats 'Nidorina',        70,     62,     67,     55,     55,     56;
EXEC add_pokemon_stats 'Nidoqueen',       90,     92,     87,     75,     85,     76;
EXEC add_pokemon_stats 'Nidoran-M',       46,     57,     40,     40,     40,     50;
EXEC add_pokemon_stats 'Nidorino',        61,     72,     57,     55,     55,     65;
EXEC add_pokemon_stats 'Nidoking',        81,    102,     77,     85,     75,     85;
EXEC add_pokemon_stats 'Clefairy',        70,     45,     48,     60,     65,     35;
EXEC add_pokemon_stats 'Clefable',        95,     70,     73,     95,     90,     60;
EXEC add_pokemon_stats 'Vulpix',          38,     41,     40,     50,     65,     65;
EXEC add_pokemon_stats 'Ninetales',       73,     76,     75,     81,    100,    100;
EXEC add_pokemon_stats 'Jigglypuff',     115,     45,     20,     45,     25,     20;
EXEC add_pokemon_stats 'Wigglytuff',     140,     70,     45,     85,     50,     45;
EXEC add_pokemon_stats 'Zubat',           40,     45,     35,     30,     40,     55;
EXEC add_pokemon_stats 'Golbat',          75,     80,     70,     65,     75,     90;
EXEC add_pokemon_stats 'Oddish',          45,     50,     55,     75,     65,     30;
EXEC add_pokemon_stats 'Gloom',           60,     65,     70,     85,     75,     40;
EXEC add_pokemon_stats 'Vileplume',       75,     80,     85,    110,     90,     50;
EXEC add_pokemon_stats 'Paras',           35,     70,     55,     45,     55,     25;
EXEC add_pokemon_stats 'Parasect',        60,     95,     80,     60,     80,     30;
EXEC add_pokemon_stats 'Venonat',         60,     55,     50,     40,     55,     45;
EXEC add_pokemon_stats 'Venomoth',        70,     65,     60,     90,     75,     90;
EXEC add_pokemon_stats 'Diglett',         10,     55,     25,     35,     45,     95;
EXEC add_pokemon_stats 'Dugtrio',         35,    100,     50,     50,     70,    120;
EXEC add_pokemon_stats 'Meowth',          40,     45,     35,     40,     40,     90;
EXEC add_pokemon_stats 'Persian',         65,     70,     60,     65,     65,    115;
EXEC add_pokemon_stats 'Psyduck',         50,     52,     48,     65,     50,     55;
EXEC add_pokemon_stats 'Golduck',         80,     82,     78,     95,     80,     85;
EXEC add_pokemon_stats 'Mankey',          40,     80,     35,     35,     45,     70;
EXEC add_pokemon_stats 'Primeape',        65,    105,     60,     60,     70,     95;
EXEC add_pokemon_stats 'Growlithe',       55,     70,     45,     70,     50,     60;
EXEC add_pokemon_stats 'Arcanine',        90,    110,     80,    100,     80,     95;
EXEC add_pokemon_stats 'Poliwag',         40,     50,     40,     40,     40,     90;
EXEC add_pokemon_stats 'Poliwhirl',       65,     65,     65,     50,     50,     90;
EXEC add_pokemon_stats 'Poliwrath',       90,     95,     95,     70,     90,     70;
EXEC add_pokemon_stats 'Abra',            25,     20,     15,    105,     55,     90;
EXEC add_pokemon_stats 'Kadabra',         40,     35,     30,    120,     70,    105;
EXEC add_pokemon_stats 'Alakazam',        55,     50,     45,    135,     95,    120;
EXEC add_pokemon_stats 'Machop',          70,     80,     50,     35,     35,     35;
EXEC add_pokemon_stats 'Machoke',         80,    100,     70,     50,     60,     45;
EXEC add_pokemon_stats 'Machamp',         90,    130,     80,     65,     85,     55;
EXEC add_pokemon_stats 'Bellsprout',      50,     75,     35,     70,     30,     40;
EXEC add_pokemon_stats 'Weepinbell',      65,     90,     50,     85,     45,     55;
EXEC add_pokemon_stats 'Victreebel',      80,    105,     65,    100,     70,     70;
EXEC add_pokemon_stats 'Tentacool',       40,     40,     35,     50,    100,     70;
EXEC add_pokemon_stats 'Tentacruel',      80,     70,     65,     80,    120,    100;
EXEC add_pokemon_stats 'Geodude',         40,     80,    100,     30,     30,     20;
EXEC add_pokemon_stats 'Graveler',        55,     95,    115,     45,     45,     35;
EXEC add_pokemon_stats 'Golem',           80,    120,    130,     55,     65,     45;
EXEC add_pokemon_stats 'Ponyta',          50,     85,     55,     65,     65,     90;
EXEC add_pokemon_stats 'Rapidash',        65,    100,     70,     80,     80,    105;
EXEC add_pokemon_stats 'Slowpoke',        90,     65,     65,     40,     40,     15;
EXEC add_pokemon_stats 'Slowbro',         95,     75,    110,    100,     80,     30;
EXEC add_pokemon_stats 'Magnemite',       25,     35,     70,     95,     55,     45;
EXEC add_pokemon_stats 'Magneton',        50,     60,     95,    120,     70,     70;
EXEC add_pokemon_stats 'Farfetch''d',     52,     90,     55,     58,     62,     60;
EXEC add_pokemon_stats 'Doduo',           35,     85,     45,     35,     35,     75;
EXEC add_pokemon_stats 'Dodrio',          60,    110,     70,     60,     60,    110;
EXEC add_pokemon_stats 'Seel',            65,     45,     55,     45,     70,     45;
EXEC add_pokemon_stats 'Dewgong',         90,     70,     80,     70,     95,     70;
EXEC add_pokemon_stats 'Grimer',          80,     80,     50,     40,     50,     25;
EXEC add_pokemon_stats 'Muk',            105,    105,     75,     65,    100,     50;
EXEC add_pokemon_stats 'Shellder',        30,     65,    100,     45,     25,     40;
EXEC add_pokemon_stats 'Cloyster',        50,     95,    180,     85,     45,     70;
EXEC add_pokemon_stats 'Gastly',          30,     35,     30,    100,     35,     80;
EXEC add_pokemon_stats 'Haunter',         45,     50,     45,    115,     55,     95;
EXEC add_pokemon_stats 'Gengar',          60,     65,     60,    130,     75,    110;
EXEC add_pokemon_stats 'Onix',            35,     45,    160,     30,     45,     70;
EXEC add_pokemon_stats 'Drowzee',         60,     48,     45,     43,     90,     42;
EXEC add_pokemon_stats 'Hypno',           85,     73,     70,     73,    115,     67;
EXEC add_pokemon_stats 'Krabby',          30,    105,     90,     25,     25,     50;
EXEC add_pokemon_stats 'Kingler',         55,    130,    115,     50,     50,     75;
EXEC add_pokemon_stats 'Voltorb',         40,     30,     50,     55,     55,    100;
EXEC add_pokemon_stats 'Electrode',       60,     50,     70,     80,     80,    150;
EXEC add_pokemon_stats 'Exeggcute',       60,     40,     80,     60,     45,     40;
EXEC add_pokemon_stats 'Exeggutor',       95,     95,     85,    125,     75,     55;
EXEC add_pokemon_stats 'Cubone',          50,     50,     95,     40,     50,     35;
EXEC add_pokemon_stats 'Marowak',         60,     80,    110,     50,     80,     45;
EXEC add_pokemon_stats 'Hitmonlee',       50,    120,     53,     35,    110,     87;
EXEC add_pokemon_stats 'Hitmonchan',      50,    105,     79,     35,    110,     76;
EXEC add_pokemon_stats 'Lickitung',       90,     55,     75,     60,     75,     30;
EXEC add_pokemon_stats 'Koffing',         40,     65,     95,     60,     45,     35;
EXEC add_pokemon_stats 'Weezing',         65,     90,    120,     85,     70,     60;
EXEC add_pokemon_stats 'Rhyhorn',         80,     85,     95,     30,     30,     25;
EXEC add_pokemon_stats 'Rhydon',         105,    130,    120,     45,     45,     40;
EXEC add_pokemon_stats 'Chansey',        250,      5,      5,     35,    105,     50;
EXEC add_pokemon_stats 'Tangela',         65,     55,    115,    100,     40,     60;
EXEC add_pokemon_stats 'Kangaskhan',     105,     95,     80,     40,     80,     90;
EXEC add_pokemon_stats 'Horsea',          30,     40,     70,     70,     25,     60;
EXEC add_pokemon_stats 'Seadra',          55,     65,     95,     95,     45,     85;
EXEC add_pokemon_stats 'Goldeen',         45,     67,     60,     35,     50,     63;
EXEC add_pokemon_stats 'Seaking',         80,     92,     65,     65,     80,     68;
EXEC add_pokemon_stats 'Staryu',          30,     45,     55,     70,     55,     85;
EXEC add_pokemon_stats 'Starmie',         60,     75,     85,    100,     85,    115;
EXEC add_pokemon_stats 'Mr. Mime',        40,     45,     65,    100,    120,     90;
EXEC add_pokemon_stats 'Scyther',         70,    110,     80,     55,     80,    105;
EXEC add_pokemon_stats 'Jynx',            65,     50,     35,    115,     95,     95;
EXEC add_pokemon_stats 'Electabuzz',      65,     83,     57,     95,     85,    105;
EXEC add_pokemon_stats 'Magmar',          65,     95,     57,    100,     85,     93;
EXEC add_pokemon_stats 'Pinsir',          65,    125,    100,     55,     70,     85;
EXEC add_pokemon_stats 'Tauros',          75,    100,     95,     40,     70,    110;
EXEC add_pokemon_stats 'Magikarp',        20,     10,     55,     15,     20,     80;
EXEC add_pokemon_stats 'Gyarados',        95,    125,     79,     60,    100,     81;
EXEC add_pokemon_stats 'Lapras',         130,     85,     80,     85,     95,     60;
EXEC add_pokemon_stats 'Ditto',           48,     48,     48,     48,     48,     48;
EXEC add_pokemon_stats 'Eevee',           55,     55,     50,     45,     65,     55;
EXEC add_pokemon_stats 'Vaporeon',       130,     65,     60,    110,     95,     65;
EXEC add_pokemon_stats 'Jolteon',         65,     65,     60,    110,     95,    130;
EXEC add_pokemon_stats 'Flareon',         65,    130,     60,     95,    110,     65;
EXEC add_pokemon_stats 'Porygon',         65,     60,     70,     85,     75,     40;
EXEC add_pokemon_stats 'Omanyte',         35,     40,    100,     90,     55,     35;
EXEC add_pokemon_stats 'Omastar',         70,     60,    125,    115,     70,     55;
EXEC add_pokemon_stats 'Kabuto',          30,     80,     90,     55,     45,     55;
EXEC add_pokemon_stats 'Kabutops',        60,    115,    105,     65,     70,     80;
EXEC add_pokemon_stats 'Aerodactyl',      80,    105,     65,     60,     75,    130;
EXEC add_pokemon_stats 'Snorlax',        160,    110,     65,     65,    110,     30;
EXEC add_pokemon_stats 'Articuno',        90,     85,    100,     95,    125,     85;
EXEC add_pokemon_stats 'Zapdos',          90,     90,     85,    125,     90,    100;
EXEC add_pokemon_stats 'Moltres',         90,    100,     90,    125,     85,     90;
EXEC add_pokemon_stats 'Dratini',         41,     64,     45,     50,     50,     50;
EXEC add_pokemon_stats 'Dragonair',       61,     84,     65,     70,     70,     70;
EXEC add_pokemon_stats 'Dragonite',       91,    134,     95,    100,    100,     80;
EXEC add_pokemon_stats 'Mewtwo',         106,    110,     90,    154,     90,    130;
EXEC add_pokemon_stats 'Mew',            100,    100,    100,    100,    100,    100;
