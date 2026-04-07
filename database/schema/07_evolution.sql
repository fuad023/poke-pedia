CREATE TABLE evolution (
    id               TINYINT           NOT NULL,
    from_poke_id     TINYINT           NOT NULL,
    to_poke_id       TINYINT           NOT NULL,

    CONSTRAINT PK_evo          PRIMARY KEY (id),
    CONSTRAINT UQ_evo          UNIQUE (from_poke_id, to_poke_id),
    CONSTRAINT FK_evo_from     FOREIGN KEY (from_poke_id) REFERENCES pokemon(id),
    CONSTRAINT FK_evo_to       FOREIGN KEY (to_poke_id)   REFERENCES pokemon(id)
);
GO

CREATE TABLE evo_condition (
    id               TINYINT           NOT NULL IDENTITY(1,1),
    evo_id           TINYINT           NOT NULL,
    condition_type   VARCHAR(10)       NOT NULL CHECK (condition_type IN ('level','stone','trade')),
    level_value      TINYINT           NULL,
    stone_id         TINYINT           NULL,

    CONSTRAINT PK_ec           PRIMARY KEY (id),
    CONSTRAINT FK_ec_evolution FOREIGN KEY (evo_id)   REFERENCES evolution(id),
    CONSTRAINT FK_ec_item      FOREIGN KEY (stone_id) REFERENCES items(id),
    CONSTRAINT CK_ec_values CHECK (
        (condition_type = 'level'     AND level_value IS NOT NULL AND stone_id IS NULL    ) OR
        (condition_type = 'stone'     AND level_value IS NULL     AND stone_id IS NOT NULL) OR
        (condition_type = 'trade'     AND level_value IS NULL     AND stone_id IS NULL    )
    )
);
GO

-- =============================================================

CREATE PROCEDURE add_evo_once
    @p_evo_id       TINYINT,
    @p_from_poke_id TINYINT,
    @p_to_poke_id   TINYINT,
    @p_level        TINYINT = NULL,
    @p_stone        VARCHAR(16) = NULL
AS
BEGIN
    DECLARE @v_stone_id TINYINT;

    IF @p_stone IS NULL AND @p_level IS NULL
    BEGIN
        INSERT INTO evolution (id, from_poke_id, to_poke_id)
        VALUES (@p_evo_id, @p_from_poke_id, @p_to_poke_id);

        INSERT INTO evo_condition (evo_id, condition_type, level_value, stone_id)
        VALUES (@p_evo_id, 'trade', NULL, NULL);
    END
    ELSE IF @p_stone IS NULL
    BEGIN
        INSERT INTO evolution (id, from_poke_id, to_poke_id)
        VALUES (@p_evo_id, @p_from_poke_id, @p_to_poke_id);

        INSERT INTO evo_condition (evo_id, condition_type, level_value, stone_id)
        VALUES (@p_evo_id, 'level', @p_level, NULL);
    END
    ELSE
    BEGIN
        EXEC get_item_id @p_stone, @v_stone_id OUTPUT;

        INSERT INTO evolution (id, from_poke_id, to_poke_id)
        VALUES (@p_evo_id, @p_from_poke_id, @p_to_poke_id);

        INSERT INTO evo_condition (evo_id, condition_type, level_value, stone_id)
        VALUES (@p_evo_id, 'stone', NULL, @v_stone_id);
    END
END;
GO

-- =============================================================

CREATE PROCEDURE add_evolution
    @p_evo_id            TINYINT,
    @p_poke_first        VARCHAR(16),
    @p_level_1           TINYINT = NULL,
    @p_stone_1           VARCHAR(16) = NULL,
    @p_poke_second       VARCHAR(16),
    @p_level_2           TINYINT = NULL,
    @p_stone_2           VARCHAR(16) = NULL,
    @p_poke_third        VARCHAR(16) = NULL
AS
BEGIN
    DECLARE @v_poke_first   TINYINT;
    DECLARE @v_poke_second  TINYINT;
    DECLARE @v_poke_third   TINYINT;

    EXEC get_pokemon_id @p_poke_first, @v_poke_first OUTPUT;
    EXEC get_pokemon_id @p_poke_second, @v_poke_second OUTPUT;

    EXEC add_evo_once @p_evo_id, @v_poke_first, @v_poke_second, @p_level_1, @p_stone_1;

    IF @p_poke_third IS NOT NULL
    BEGIN
        DECLARE @next_evo_id TINYINT;
        SET @next_evo_id = @p_evo_id + 1;

        EXEC get_pokemon_id @p_poke_third, @v_poke_third OUTPUT;
        EXEC add_evo_once @next_evo_id, @v_poke_second, @v_poke_third, @p_level_2, @p_stone_2;
    END
END;
GO

-- =============================================================

EXEC add_evolution  1, 'Bulbasaur',    16,  NULL,           'Ivysaur',      32,  NULL,           'Venusaur';
EXEC add_evolution  3, 'Charmander',   16,  NULL,           'Charmeleon',   36,  NULL,           'Charizard';
EXEC add_evolution  5, 'Squirtle',     16,  NULL,           'Wartortle',    36,  NULL,           'Blastoise';
EXEC add_evolution  7, 'Caterpie',      7,  NULL,           'Metapod',      10,  NULL,           'Butterfree';
EXEC add_evolution  9, 'Weedle',        7,  NULL,           'Kakuna',       10,  NULL,           'Beedrill';
EXEC add_evolution 11, 'Pidgey',       18,  NULL,           'Pidgeotto',    36,  NULL,           'Pidgeot';
EXEC add_evolution 13, 'Rattata',      20,  NULL,           'Raticate',   NULL,  NULL,            NULL;
EXEC add_evolution 14, 'Spearow',      20,  NULL,           'Fearow',     NULL,  NULL,            NULL;
EXEC add_evolution 15, 'Ekans',        22,  NULL,           'Arbok',      NULL,  NULL,            NULL;
EXEC add_evolution 16, 'Pikachu',    NULL, 'Thunder Stone', 'Raichu',     NULL,  NULL,            NULL;
EXEC add_evolution 17, 'Sandshrew',    22,  NULL,           'Sandslash',  NULL,  NULL,            NULL;
EXEC add_evolution 18, 'Nidoran-F',    16,  NULL,           'Nidorina',   NULL, 'Moon Stone',    'Nidoqueen';
EXEC add_evolution 20, 'Nidoran-M',    16,  NULL,           'Nidorino',   NULL, 'Moon Stone',    'Nidoking';
EXEC add_evolution 22, 'Clefairy',   NULL, 'Moon Stone',    'Clefable',   NULL,  NULL,            NULL;
EXEC add_evolution 23, 'Vulpix',     NULL, 'Fire Stone',    'Ninetales',  NULL,  NULL,            NULL;
EXEC add_evolution 24, 'Jigglypuff', NULL, 'Moon Stone',    'Wigglytuff', NULL,  NULL,            NULL;
EXEC add_evolution 25, 'Zubat',        22,  NULL,           'Golbat',     NULL,  NULL,            NULL;
EXEC add_evolution 26, 'Oddish',       21,  NULL,           'Gloom',      NULL, 'Leaf Stone',    'Vileplume';
EXEC add_evolution 28, 'Paras',        24,  NULL,           'Parasect',   NULL,  NULL,            NULL;
EXEC add_evolution 29, 'Venonat',      31,  NULL,           'Venomoth',   NULL,  NULL,            NULL;
EXEC add_evolution 30, 'Diglett',      26,  NULL,           'Dugtrio',    NULL,  NULL,            NULL;
EXEC add_evolution 31, 'Meowth',       28,  NULL,           'Persian',    NULL,  NULL,            NULL;
EXEC add_evolution 32, 'Psyduck',      33,  NULL,           'Golduck',    NULL,  NULL,            NULL;
EXEC add_evolution 33, 'Mankey',       28,  NULL,           'Primeape',   NULL,  NULL,            NULL;
EXEC add_evolution 34, 'Growlithe',  NULL, 'Fire Stone',    'Arcanine',   NULL,  NULL,            NULL;
EXEC add_evolution 35, 'Poliwag',      25,  NULL,           'Poliwhirl',  NULL, 'Water Stone',   'Poliwrath';
EXEC add_evolution 37, 'Abra',         16,  NULL,           'Kadabra',    NULL,  NULL,           'Alakazam';
EXEC add_evolution 39, 'Machop',       28,  NULL,           'Machoke',    NULL,  NULL,           'Machamp';
EXEC add_evolution 41, 'Bellsprout',   21,  NULL,           'Weepinbell', NULL, 'Leaf Stone',    'Victreebel';
EXEC add_evolution 43, 'Tentacool',    30,  NULL,           'Tentacruel', NULL,  NULL,            NULL;
EXEC add_evolution 44, 'Geodude',      25,  NULL,           'Graveler',   NULL,  NULL,           'Golem';
EXEC add_evolution 46, 'Ponyta',       40,  NULL,           'Rapidash',   NULL,  NULL,            NULL;
EXEC add_evolution 47, 'Slowpoke',     37,  NULL,           'Slowbro',    NULL,  NULL,            NULL;
EXEC add_evolution 48, 'Magnemite',    30,  NULL,           'Magneton',   NULL,  NULL,            NULL;
EXEC add_evolution 49, 'Doduo',        31,  NULL,           'Dodrio',     NULL,  NULL,            NULL;
EXEC add_evolution 50, 'Seel',         34,  NULL,           'Dewgong',    NULL,  NULL,            NULL;
EXEC add_evolution 51, 'Grimer',       38,  NULL,           'Muk',        NULL,  NULL,            NULL;
EXEC add_evolution 52, 'Shellder',   NULL, 'Water Stone',   'Cloyster',   NULL,  NULL,            NULL;
EXEC add_evolution 53, 'Gastly',       25,  NULL,           'Haunter',    NULL,  NULL,           'Gengar';
EXEC add_evolution 55, 'Drowzee',      26,  NULL,           'Hypno',      NULL,  NULL,            NULL;
EXEC add_evolution 56, 'Krabby',       28,  NULL,           'Kingler',    NULL,  NULL,            NULL;
EXEC add_evolution 57, 'Voltorb',      30,  NULL,           'Electrode',  NULL,  NULL,            NULL;
EXEC add_evolution 58, 'Exeggcute',  NULL, 'Leaf Stone',    'Exeggutor',  NULL,  NULL,            NULL;
EXEC add_evolution 59, 'Cubone',       28,  NULL,           'Marowak',    NULL,  NULL,            NULL;
EXEC add_evolution 60, 'Koffing',      35,  NULL,           'Weezing',    NULL,  NULL,            NULL;
EXEC add_evolution 61, 'Rhyhorn',      42,  NULL,           'Rhydon',     NULL,  NULL,            NULL;
EXEC add_evolution 62, 'Horsea',       32,  NULL,           'Seadra',     NULL,  NULL,            NULL;
EXEC add_evolution 63, 'Goldeen',      33,  NULL,           'Seaking',    NULL,  NULL,            NULL;
EXEC add_evolution 64, 'Staryu',     NULL, 'Water Stone',   'Starmie',    NULL,  NULL,            NULL;
EXEC add_evolution 65, 'Magikarp',     20,  NULL,           'Gyarados',   NULL,  NULL,            NULL;

-- Eevee line
INSERT INTO evolution (id, from_poke_id, to_poke_id) VALUES
(66, 133, 134), -- id=66    Eevee > Vaporeon
(67, 133, 135), -- id=67    Eevee > Jolteon
(68, 133, 136); -- id=68    Eevee > Flareon

-- Eevee branches
INSERT INTO evo_condition (evo_id, condition_type, level_value, stone_id) VALUES
(66, 'stone', NULL, 2),    -- Water Stone   > Vaporeon
(67, 'stone', NULL, 3),    -- Thunder Stone > Jolteon
(68, 'stone', NULL, 1);    -- Fire Stone    > Flareon

EXEC add_evolution 69, 'Omanyte',      40,  NULL,           'Omastar',    NULL,  NULL,            NULL;
EXEC add_evolution 70, 'Kabuto',       40,  NULL,           'Kabutops',   NULL,  NULL,            NULL;
EXEC add_evolution 71, 'Dratini',      30,  NULL,           'Dragonair',    55,  NULL,           'Dragonite';
