CREATE TABLE type (
    id               TINYINT           NOT NULL,
    name             VARCHAR(16)       NOT NULL,

    CONSTRAINT PK_type PRIMARY KEY (id),
    CONSTRAINT UQ_type_name UNIQUE (name)
);
GO

CREATE PROCEDURE get_type_id
    @p_type_name     VARCHAR(16),
    @v_type_id       TINYINT OUTPUT
AS
BEGIN
    SELECT @v_type_id = id
    FROM type
    WHERE name = @p_type_name;

    IF @v_type_id IS NULL
    BEGIN
        DECLARE @v_msg VARCHAR(32);
        SET @v_msg = @p_type_name + ' not found!';
        THROW 50000, @v_msg, 1;
    END
END
GO

CREATE TABLE pokemon_type (
    poke_id          TINYINT           NOT NULL,
    type_id          TINYINT           NOT NULL,
    slot             TINYINT           NOT NULL,

    CONSTRAINT PK_PT PRIMARY KEY (poke_id, type_id),
    CONSTRAINT FK_PT_Pokemon FOREIGN KEY (poke_id) REFERENCES pokemon(id),
    CONSTRAINT FK_PT_Type FOREIGN KEY (type_id) REFERENCES type(id),

    CONSTRAINT UQ_PT_slot UNIQUE (poke_id, slot),
    CONSTRAINT CK_PT_slot CHECK (slot IN (1, 2))
);
GO

CREATE PROCEDURE add_pokemon_type
    @p_poke_name     VARCHAR(16),
    @p_type_1        VARCHAR(16),
    @p_type_2        VARCHAR(16)
AS
BEGIN
    DECLARE @v_poke_id   TINYINT;
    DECLARE @v_type_id   TINYINT;

    EXEC get_pokemon_id @p_poke_name, @v_poke_id OUTPUT;
    EXEC get_type_id    @p_type_1,    @v_type_id OUTPUT;

    INSERT INTO pokemon_type (poke_id, type_id, slot)
    VALUES (@v_poke_id, @v_type_id, 1);

    IF @p_type_2 IS NOT NULL
    BEGIN
        EXEC get_type_id @p_type_2, @v_type_id OUTPUT;

        INSERT INTO pokemon_type (poke_id, type_id, slot)
        VALUES (@v_poke_id, @v_type_id, 2);
    END
END
GO

INSERT INTO type (id, name) VALUES
( 1, 'Normal'),
( 2, 'Fire'),
( 3, 'Water'),
( 4, 'Electric'),
( 5, 'Grass'),
( 6, 'Ice'),
( 7, 'Fighting'),
( 8, 'Poison'),
( 9, 'Ground'),
(10, 'Flying'),
(11, 'Psychic'),
(12, 'Bug'),
(13, 'Rock'),
(14, 'Ghost'),
(15, 'Dragon'),
(16, 'Dark'),
(17, 'Steel');
GO

EXEC add_pokemon_type 'Bulbasaur',  'Grass',    'Poison';
EXEC add_pokemon_type 'Ivysaur',    'Grass',    'Poison';
EXEC add_pokemon_type 'Venusaur',   'Grass',    'Poison';

EXEC add_pokemon_type 'Charmander', 'Fire',     NULL;
EXEC add_pokemon_type 'Charmeleon', 'Fire',     NULL;
EXEC add_pokemon_type 'Charizard',  'Fire',     'Flying';

EXEC add_pokemon_type 'Squirtle',   'Water',    NULL;
EXEC add_pokemon_type 'Wartortle',  'Water',    NULL;
EXEC add_pokemon_type 'Blastoise',  'Water',    NULL;

EXEC add_pokemon_type 'Caterpie',   'Bug',      NULL;
EXEC add_pokemon_type 'Metapod',    'Bug',      NULL;
EXEC add_pokemon_type 'Butterfree', 'Bug',      'Flying';

EXEC add_pokemon_type 'Weedle',     'Bug',      'Poison';
EXEC add_pokemon_type 'Kakuna',     'Bug',      'Poison';
EXEC add_pokemon_type 'Beedrill',   'Bug',      'Poison';

EXEC add_pokemon_type 'Pidgey',     'Normal',   'Flying';
EXEC add_pokemon_type 'Pidgeotto',  'Normal',   'Flying';
EXEC add_pokemon_type 'Pidgeot',    'Normal',   'Flying';

EXEC add_pokemon_type 'Rattata',    'Normal',   NULL;
EXEC add_pokemon_type 'Raticate',   'Normal',   NULL;

EXEC add_pokemon_type 'Spearow',    'Normal',   'Flying';
EXEC add_pokemon_type 'Fearow',     'Normal',   'Flying';

EXEC add_pokemon_type 'Ekans',      'Poison',   NULL;
EXEC add_pokemon_type 'Arbok',      'Poison',   NULL;

EXEC add_pokemon_type 'Pikachu',    'Electric', NULL;
EXEC add_pokemon_type 'Raichu',     'Electric', NULL;

EXEC add_pokemon_type 'Sandshrew',  'Ground',   NULL;
EXEC add_pokemon_type 'Sandslash',  'Ground',   NULL;

EXEC add_pokemon_type 'Nidoran-F',   'Poison',   NULL;
EXEC add_pokemon_type 'Nidorina',   'Poison',   NULL;
EXEC add_pokemon_type 'Nidoqueen',  'Poison',   'Ground';

EXEC add_pokemon_type 'Nidoran-M',   'Poison',   NULL;
EXEC add_pokemon_type 'Nidorino',   'Poison',   NULL;
EXEC add_pokemon_type 'Nidoking',   'Poison',   'Ground';

EXEC add_pokemon_type 'Clefairy',   'Normal',   NULL;
EXEC add_pokemon_type 'Clefable',   'Normal',   NULL;

EXEC add_pokemon_type 'Vulpix',     'Fire',     NULL;
EXEC add_pokemon_type 'Ninetales',  'Fire',     NULL;

EXEC add_pokemon_type 'Jigglypuff', 'Normal',   NULL;
EXEC add_pokemon_type 'Wigglytuff', 'Normal',   NULL;

EXEC add_pokemon_type 'Zubat',      'Poison',   'Flying';
EXEC add_pokemon_type 'Golbat',     'Poison',   'Flying';

EXEC add_pokemon_type 'Oddish',     'Grass',    'Poison';
EXEC add_pokemon_type 'Gloom',      'Grass',    'Poison';
EXEC add_pokemon_type 'Vileplume',  'Grass',    'Poison';

EXEC add_pokemon_type 'Paras',      'Bug',      'Grass';
EXEC add_pokemon_type 'Parasect',   'Bug',      'Grass';

EXEC add_pokemon_type 'Venonat',    'Bug',      'Poison';
EXEC add_pokemon_type 'Venomoth',   'Bug',      'Poison';

EXEC add_pokemon_type 'Diglett',    'Ground',   NULL;
EXEC add_pokemon_type 'Dugtrio',    'Ground',   NULL;

EXEC add_pokemon_type 'Meowth',     'Normal',   NULL;
EXEC add_pokemon_type 'Persian',    'Normal',   NULL;

EXEC add_pokemon_type 'Psyduck',    'Water',    NULL;
EXEC add_pokemon_type 'Golduck',    'Water',    NULL;

EXEC add_pokemon_type 'Mankey',     'Fighting', NULL;
EXEC add_pokemon_type 'Primeape',   'Fighting', NULL;

EXEC add_pokemon_type 'Growlithe',  'Fire',     NULL;
EXEC add_pokemon_type 'Arcanine',   'Fire',     NULL;

EXEC add_pokemon_type 'Poliwag',    'Water',    NULL;
EXEC add_pokemon_type 'Poliwhirl',  'Water',    NULL;
EXEC add_pokemon_type 'Poliwrath',  'Water',    'Fighting';

EXEC add_pokemon_type 'Abra',       'Psychic',  NULL;
EXEC add_pokemon_type 'Kadabra',    'Psychic',  NULL;
EXEC add_pokemon_type 'Alakazam',   'Psychic',  NULL;

EXEC add_pokemon_type 'Machop',     'Fighting', NULL;
EXEC add_pokemon_type 'Machoke',    'Fighting', NULL;
EXEC add_pokemon_type 'Machamp',    'Fighting', NULL;

EXEC add_pokemon_type 'Bellsprout', 'Grass',    'Poison';
EXEC add_pokemon_type 'Weepinbell', 'Grass',    'Poison';
EXEC add_pokemon_type 'Victreebel', 'Grass',    'Poison';

EXEC add_pokemon_type 'Tentacool',  'Water',    'Poison';
EXEC add_pokemon_type 'Tentacruel', 'Water',    'Poison';

EXEC add_pokemon_type 'Geodude',    'Rock',     'Ground';
EXEC add_pokemon_type 'Graveler',   'Rock',     'Ground';
EXEC add_pokemon_type 'Golem',      'Rock',     'Ground';

EXEC add_pokemon_type 'Ponyta',     'Fire',     NULL;
EXEC add_pokemon_type 'Rapidash',   'Fire',     NULL;

EXEC add_pokemon_type 'Slowpoke',   'Water',    'Psychic';
EXEC add_pokemon_type 'Slowbro',    'Water',    'Psychic';

EXEC add_pokemon_type 'Magnemite',  'Electric', 'Steel';
EXEC add_pokemon_type 'Magneton',   'Electric', 'Steel';

EXEC add_pokemon_type 'Farfetch''d','Normal',   'Flying';

EXEC add_pokemon_type 'Doduo',      'Normal',   'Flying';
EXEC add_pokemon_type 'Dodrio',     'Normal',   'Flying';

EXEC add_pokemon_type 'Seel',       'Water',    NULL;
EXEC add_pokemon_type 'Dewgong',    'Water',    'Ice';

EXEC add_pokemon_type 'Grimer',     'Poison',   NULL;
EXEC add_pokemon_type 'Muk',        'Poison',   NULL;

EXEC add_pokemon_type 'Shellder',   'Water',    NULL;
EXEC add_pokemon_type 'Cloyster',   'Water',    'Ice';

EXEC add_pokemon_type 'Gastly',     'Ghost',    'Poison';
EXEC add_pokemon_type 'Haunter',    'Ghost',    'Poison';
EXEC add_pokemon_type 'Gengar',     'Ghost',    'Poison';

EXEC add_pokemon_type 'Onix',       'Rock',     'Ground';

EXEC add_pokemon_type 'Drowzee',    'Psychic',  NULL;
EXEC add_pokemon_type 'Hypno',      'Psychic',  NULL;

EXEC add_pokemon_type 'Krabby',     'Water',    NULL;
EXEC add_pokemon_type 'Kingler',    'Water',    NULL;

EXEC add_pokemon_type 'Voltorb',    'Electric', NULL;
EXEC add_pokemon_type 'Electrode',  'Electric', NULL;

EXEC add_pokemon_type 'Exeggcute',  'Grass',    'Psychic';
EXEC add_pokemon_type 'Exeggutor',  'Grass',    'Psychic';

EXEC add_pokemon_type 'Cubone',     'Ground',   NULL;
EXEC add_pokemon_type 'Marowak',    'Ground',   NULL;

EXEC add_pokemon_type 'Hitmonlee',  'Fighting', NULL;
EXEC add_pokemon_type 'Hitmonchan', 'Fighting', NULL;

EXEC add_pokemon_type 'Lickitung',  'Normal',   NULL;

EXEC add_pokemon_type 'Koffing',    'Poison',   NULL;
EXEC add_pokemon_type 'Weezing',    'Poison',   NULL;

EXEC add_pokemon_type 'Rhyhorn',    'Ground',   'Rock';
EXEC add_pokemon_type 'Rhydon',     'Ground',   'Rock';

EXEC add_pokemon_type 'Chansey',    'Normal',   NULL;

EXEC add_pokemon_type 'Tangela',    'Grass',    NULL;

EXEC add_pokemon_type 'Kangaskhan', 'Normal',   NULL;

EXEC add_pokemon_type 'Horsea',     'Water',    NULL;
EXEC add_pokemon_type 'Seadra',     'Water',    NULL;

EXEC add_pokemon_type 'Goldeen',    'Water',    NULL;
EXEC add_pokemon_type 'Seaking',    'Water',    NULL;

EXEC add_pokemon_type 'Staryu',     'Water',    NULL;
EXEC add_pokemon_type 'Starmie',    'Water',    'Psychic';

EXEC add_pokemon_type 'Mr. Mime',   'Psychic',  NULL;

EXEC add_pokemon_type 'Scyther',    'Bug',      'Flying';

EXEC add_pokemon_type 'Jynx',       'Ice',      'Psychic';

EXEC add_pokemon_type 'Electabuzz', 'Electric', NULL;

EXEC add_pokemon_type 'Magmar',     'Fire',     NULL;

EXEC add_pokemon_type 'Pinsir',     'Bug',      NULL;

EXEC add_pokemon_type 'Tauros',     'Normal',   NULL;

EXEC add_pokemon_type 'Magikarp',   'Water',    NULL;
EXEC add_pokemon_type 'Gyarados',   'Water',    'Flying';

EXEC add_pokemon_type 'Lapras',     'Water',    'Ice';

EXEC add_pokemon_type 'Ditto',      'Normal',   NULL;

EXEC add_pokemon_type 'Eevee',      'Normal',   NULL;
EXEC add_pokemon_type 'Vaporeon',   'Water',    NULL;
EXEC add_pokemon_type 'Jolteon',    'Electric', NULL;
EXEC add_pokemon_type 'Flareon',    'Fire',     NULL;

EXEC add_pokemon_type 'Porygon',    'Normal',   NULL;

EXEC add_pokemon_type 'Omanyte',    'Rock',     'Water';
EXEC add_pokemon_type 'Omastar',    'Rock',     'Water';

EXEC add_pokemon_type 'Kabuto',     'Rock',     'Water';
EXEC add_pokemon_type 'Kabutops',   'Rock',     'Water';

EXEC add_pokemon_type 'Aerodactyl', 'Rock',     'Flying';

EXEC add_pokemon_type 'Snorlax',    'Normal',   NULL;

EXEC add_pokemon_type 'Articuno',   'Ice',      'Flying';
EXEC add_pokemon_type 'Zapdos',     'Electric', 'Flying';
EXEC add_pokemon_type 'Moltres',    'Fire',     'Flying';

EXEC add_pokemon_type 'Dratini',    'Dragon',   NULL;
EXEC add_pokemon_type 'Dragonair',  'Dragon',   NULL;
EXEC add_pokemon_type 'Dragonite',  'Dragon',   'Flying';

EXEC add_pokemon_type 'Mewtwo',     'Psychic',  NULL;
EXEC add_pokemon_type 'Mew',        'Psychic',  NULL;
