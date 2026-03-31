CREATE TABLE Admin (
    id                BIGINT          NOT NULL IDENTITY(1,1),

    name              VARCHAR(64)     NOT NULL,
    email             VARCHAR(64)     NOT NULL,
    password          VARCHAR(64)     NOT NULL,

    email_verified_at DATETIME            NULL DEFAULT NULL,
    remember_token    VARCHAR(100)        NULL DEFAULT NULL,

    created_at        DATETIME            NULL DEFAULT NULL,
    updated_at        DATETIME            NULL DEFAULT NULL,

    CONSTRAINT PK_Admin       PRIMARY KEY (id),
    CONSTRAINT UQ_Admin_email UNIQUE      (email)
);

CREATE INDEX IDX_Admin_name ON Admin (first_name, last_name);
