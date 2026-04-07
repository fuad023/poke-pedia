CREATE TABLE growth_rates (
    id               TINYINT           NOT NULL,
    name             VARCHAR(16)       NOT NULL,

    CONSTRAINT PK_gr PRIMARY KEY (id),
    CONSTRAINT UQ_gr_name UNIQUE (name)
);

CREATE INDEX IDX_gr_name ON growth_rates (name);

GO

CREATE PROCEDURE get_growth_rate_id
    @p_name VARCHAR(16),
    @v_id   TINYINT OUTPUT
AS
BEGIN
    SELECT @v_id = id
    FROM growth_rates
    WHERE name = @p_name;

    IF @v_id IS NULL
    BEGIN
        DECLARE @v_msg VARCHAR(32);
        SET @v_msg = @p_name + ' not found!';
        THROW 50000, @v_msg, 1;
    END
END

GO

INSERT INTO growth_rates (id, name) VALUES
(1, 'Fast'),
(2, 'Medium Fast'),
(3, 'Medium Slow'),
(4, 'Slow'),
(5, 'Erratic'),      -- exp requirements change unpredictably
(6, 'Fluctuating');  -- exp changes at different level ranges

-- =============================================================

CREATE TABLE habitats (
    id               TINYINT           NOT NULL,
    name             VARCHAR(16)       NOT NULL,

    CONSTRAINT PK_habitats PRIMARY KEY (id),
    CONSTRAINT UQ_habitats_name UNIQUE (name)
);

CREATE INDEX IDX_habitats_name ON habitats (name);

GO

CREATE PROCEDURE get_habitat_id
    @p_name VARCHAR(16),
    @v_id   TINYINT OUTPUT
AS
BEGIN
    SELECT @v_id = id
    FROM habitats
    WHERE name = @p_name;

    IF @v_id IS NULL
    BEGIN
        DECLARE @v_msg VARCHAR(32);
        SET @v_msg = @p_name + ' not found!';
        THROW 50000, @v_msg, 1;
    END
END

GO

INSERT INTO habitats (id, name) VALUES
(1, 'Grassland'),
(2, 'Forest'),
(3, 'Water''s-edge'),
(4, 'Sea'),
(5, 'Cave'),
(6, 'Mountain'),
(7, 'Rough-terrain'),
(8, 'Urban'),
(9, 'Rare');

-- =============================================================

CREATE TABLE items (
    id               TINYINT           NOT NULL,
    name             VARCHAR(16)       NOT NULL,

    CONSTRAINT PK_items PRIMARY KEY (id),
    CONSTRAINT UQ_items_name UNIQUE (name)
);

CREATE INDEX IDX_items_name ON items (name);

GO

CREATE PROCEDURE get_item_id
    @p_name VARCHAR(16),
    @v_id   TINYINT OUTPUT
AS
BEGIN
    SELECT @v_id = id
    FROM items
    WHERE name = @p_name;

    IF @v_id IS NULL
    BEGIN
        DECLARE @v_msg VARCHAR(32);
        SET @v_msg = @p_name + ' not found!';
        THROW 50000, @v_msg, 1;
    END
END

GO

INSERT INTO items (id, name) VALUES
(1, 'Fire Stone'),
(2, 'Water Stone'),
(3, 'Thunder Stone'),
(4, 'Leaf Stone'),
(5, 'Moon Stone');
