CREATE TABLE users (
    id                BIGINT           NOT NULL IDENTITY(1,1),

    name              NVARCHAR(255)    NOT NULL,
    email             NVARCHAR(255)    NOT NULL,
    email_verified_at DATETIME2            NULL,

    password          NVARCHAR(255)    NOT NULL,
    remember_token    NVARCHAR(100)        NULL,

    created_at        DATETIME2            NULL,
    updated_at        DATETIME2            NULL,

    CONSTRAINT PK_users       PRIMARY KEY (id),
    CONSTRAINT UQ_users_email UNIQUE      (email),
);

-- SANCTUM TOKENS
CREATE TABLE personal_access_tokens (
    id                BIGINT           NOT NULL IDENTITY(1,1),
    tokenable_type    NVARCHAR(255)    NOT NULL,
    tokenable_id      BIGINT           NOT NULL, -- foreign key to users.id

    name              NVARCHAR(255)    NOT NULL,
    token             NVARCHAR(64)     NOT NULL,
    abilities         NVARCHAR(255)        NULL,

    last_used_at      DATETIME2            NULL,
    expires_at        DATETIME2            NULL,
    created_at        DATETIME2            NULL,
    updated_at        DATETIME2            NULL,

    CONSTRAINT PK_pat       PRIMARY KEY (id),
    CONSTRAINT UQ_pat_token UNIQUE      (token),
);

CREATE INDEX IDX_pat_tokenable 
ON personal_access_tokens (tokenable_type, tokenable_id);
