CREATE TABLE pokemon_theme (
    pokemon_id              TINYINT       NOT NULL PRIMARY KEY,
    body_background         VARCHAR(255)  NOT NULL,
    accent                  VARCHAR(32)   NOT NULL,
    accent_soft             VARCHAR(32)   NOT NULL,
    secondary_color         VARCHAR(32)   NOT NULL,
    title_color             VARCHAR(32)   NOT NULL,
    text_color              VARCHAR(32)   NOT NULL,
    card_background         VARCHAR(64)   NOT NULL,
    hover_shadow            VARCHAR(64)   NOT NULL,
    stat_number_color       VARCHAR(32)   NOT NULL,
    stat_bar_gradient       VARCHAR(255)  NOT NULL,
    section_line_gradient   VARCHAR(255)  NOT NULL,
    entry_version_color     VARCHAR(32)   NOT NULL,
    CONSTRAINT FK_pokemon_theme_pokemon FOREIGN KEY (pokemon_id) REFERENCES pokemon(id)
);
GO

CREATE TABLE pokemon_types (
    pokemon_id   TINYINT      NOT NULL,
    slot_no      TINYINT      NOT NULL,
    type_name    VARCHAR(16)  NOT NULL,
    CONSTRAINT PK_pokemon_types PRIMARY KEY (pokemon_id, slot_no),
    CONSTRAINT FK_pokemon_types_pokemon FOREIGN KEY (pokemon_id) REFERENCES pokemon(id)
);
GO

CREATE TABLE pokemon_abilities (
    pokemon_id      TINYINT       NOT NULL,
    ability_order   TINYINT       NOT NULL,
    ability_name    VARCHAR(32)   NOT NULL,
    CONSTRAINT PK_pokemon_abilities PRIMARY KEY (pokemon_id, ability_order),
    CONSTRAINT FK_pokemon_abilities_pokemon FOREIGN KEY (pokemon_id) REFERENCES pokemon(id)
);
GO

CREATE TABLE pokemon_stats (
    pokemon_id   TINYINT       NOT NULL,
    stat_order   TINYINT       NOT NULL,
    stat_label   VARCHAR(16)   NOT NULL,
    stat_value   TINYINT       NOT NULL,
    stat_max     TINYINT       NOT NULL DEFAULT 255,
    ev_yield     TINYINT       NOT NULL DEFAULT 0,
    CONSTRAINT PK_pokemon_stats PRIMARY KEY (pokemon_id, stat_order),
    CONSTRAINT FK_pokemon_stats_pokemon FOREIGN KEY (pokemon_id) REFERENCES pokemon(id)
);
GO

CREATE TABLE pokemon_training_extra (
    pokemon_id         TINYINT       NOT NULL PRIMARY KEY,
    ev_yield_text      VARCHAR(64)   NOT NULL,
    base_friendship    TINYINT       NOT NULL,
    CONSTRAINT FK_pokemon_training_extra_pokemon FOREIGN KEY (pokemon_id) REFERENCES pokemon(id)
);
GO

CREATE TABLE pokemon_images (
    pokemon_id      TINYINT        NOT NULL PRIMARY KEY,
    image_url       VARCHAR(255)   NOT NULL,
    CONSTRAINT FK_pokemon_images_pokemon FOREIGN KEY (pokemon_id) REFERENCES pokemon(id)
);
GO

CREATE TABLE pokemon_evolutions (
    pokemon_id            TINYINT       NOT NULL,
    evolution_order       TINYINT       NOT NULL,
    evolution_pokemon_id  TINYINT       NOT NULL,
    evolution_level       VARCHAR(32)   NULL,
    CONSTRAINT PK_pokemon_evolutions PRIMARY KEY (pokemon_id, evolution_order),
    CONSTRAINT FK_pokemon_evolutions_pokemon FOREIGN KEY (pokemon_id) REFERENCES pokemon(id),
    CONSTRAINT FK_pokemon_evolutions_target FOREIGN KEY (evolution_pokemon_id) REFERENCES pokemon(id)
);
GO

CREATE TABLE pokemon_version_entries (
    pokemon_id      TINYINT         NOT NULL,
    entry_order     TINYINT         NOT NULL,
    version_name    VARCHAR(32)     NOT NULL,
    entry_text      VARCHAR(1000)   NOT NULL,
    CONSTRAINT PK_pokemon_version_entries PRIMARY KEY (pokemon_id, entry_order),
    CONSTRAINT FK_pokemon_version_entries_pokemon FOREIGN KEY (pokemon_id) REFERENCES pokemon(id)
);
GO

CREATE VIEW vw_pokemon_profile_base AS
SELECT
    p.id,
    p.name,
    p.category,
    p.height,
    p.weight,
    p.catch_rate,
    gr.name AS growth_rate,
    pi.image_url,
    th.body_background,
    th.accent,
    th.accent_soft,
    th.secondary_color,
    th.title_color,
    th.text_color,
    th.card_background,
    th.hover_shadow,
    th.stat_number_color,
    th.stat_bar_gradient,
    th.section_line_gradient,
    th.entry_version_color,
    te.ev_yield_text,
    te.base_friendship
FROM pokemon p
JOIN growth_rates gr ON gr.id = p.growth_rate_id
LEFT JOIN pokemon_images pi ON pi.pokemon_id = p.id
LEFT JOIN pokemon_theme th ON th.pokemon_id = p.id
LEFT JOIN pokemon_training_extra te ON te.pokemon_id = p.id;
GO