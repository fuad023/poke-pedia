CREATE TABLE GrowthRate (
    id               TINYINT           NOT NULL,
    name             VARCHAR(16)       NOT NULL,

    CONSTRAINT PK_GrowthRate PRIMARY KEY (id),
    CONSTRAINT UQ_GrowthRate_name UNIQUE (name)
);

CREATE INDEX IDX_GrowthRate_name ON GrowthRate (name);

GO

CREATE PROCEDURE GetGrowthRateId
    @p_name VARCHAR(16),
    @v_id   TINYINT OUTPUT
AS
BEGIN
    SELECT @v_id = id
    FROM GrowthRate
    WHERE name = @p_name;

    IF @v_id IS NULL
    BEGIN
        DECLARE @v_msg VARCHAR(32);
        SET @v_msg = @p_name + ' not found!';
        THROW 50000, @v_msg, 1;
    END
END

GO

INSERT INTO GrowthRate (id, name) VALUES
(1, 'Fast'),
(2, 'Medium Fast'),
(3, 'Medium Slow'),
(4, 'Slow'),
(5, 'Erratic'),      -- exp requirements change unpredictably
(6, 'Fluctuating');  -- exp changes at different level ranges

-- =============================================================

CREATE TABLE Habitat (
    id               TINYINT           NOT NULL,
    name             VARCHAR(16)       NOT NULL,

    CONSTRAINT PK_Habitat PRIMARY KEY (id),
    CONSTRAINT UQ_Habitat_name UNIQUE (name)
);

CREATE INDEX IDX_Habitat_name ON Habitat (name);

GO

CREATE PROCEDURE GetHabitatId
    @p_name VARCHAR(16),
    @v_id   TINYINT OUTPUT
AS
BEGIN
    SELECT @v_id = id
    FROM Habitat
    WHERE name = @p_name;

    IF @v_id IS NULL
    BEGIN
        DECLARE @v_msg VARCHAR(32);
        SET @v_msg = @p_name + ' not found!';
        THROW 50000, @v_msg, 1;
    END
END

GO

INSERT INTO Habitat (id, name) VALUES
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

CREATE TABLE Item (
    id               TINYINT           NOT NULL,
    name             VARCHAR(16)       NOT NULL,

    CONSTRAINT PK_Item PRIMARY KEY (id),
    CONSTRAINT UQ_Item_name UNIQUE (name)
);

CREATE INDEX IDX_Item_name ON Item (name);

GO

CREATE PROCEDURE GetItemId
    @p_name VARCHAR(16),
    @v_id   TINYINT OUTPUT
AS
BEGIN
    SELECT @v_id = id
    FROM Item
    WHERE name = @p_name;

    IF @v_id IS NULL
    BEGIN
        DECLARE @v_msg VARCHAR(32);
        SET @v_msg = @p_name + ' not found!';
        THROW 50000, @v_msg, 1;
    END
END

GO

INSERT INTO Item (id, name) VALUES
(1, 'Fire Stone'),
(2, 'Water Stone'),
(3, 'Thunder Stone'),
(4, 'Leaf Stone'),
(5, 'Moon Stone');
