CREATE TABLE admins (
    id                BIGINT          NOT NULL IDENTITY(1,1),

    name              VARCHAR(64)     NOT NULL,
    email             VARCHAR(64)     NOT NULL,
    password          VARCHAR(64)     NOT NULL,

    created_at        DATETIME            NULL DEFAULT NULL,
    updated_at        DATETIME            NULL DEFAULT NULL,

    CONSTRAINT PK_admins       PRIMARY KEY (id),
    CONSTRAINT UQ_admins_email UNIQUE      (email)
);

CREATE INDEX IDX_admins_name ON admins (name);
