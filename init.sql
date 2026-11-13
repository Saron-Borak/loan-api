-- Runs once, when the pgdata volume is empty
CREATE TABLE IF NOT EXISTS applications (
    id              SERIAL PRIMARY KEY,
    borrower_id     INTEGER        NOT NULL,
    amount_usd      INTEGER        NOT NULL CHECK (amount_usd BETWEEN 100 AND 5000),
    term_months     INTEGER        NOT NULL CHECK (term_months IN (3, 6, 12, 18, 24)),
    status          VARCHAR(20)    NOT NULL DEFAULT 'pending',
    submitted_at    TIMESTAMPTZ    NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS predictions (
    id                   SERIAL PRIMARY KEY,
    application_id       INTEGER       NOT NULL REFERENCES applications(id),
    default_probability  NUMERIC(4,3)  NOT NULL,
    model_version        VARCHAR(20)   NOT NULL,
    created_at           TIMESTAMPTZ   NOT NULL DEFAULT now()
);

INSERT INTO applications (borrower_id, amount_usd, term_months)
VALUES (1042, 1500, 12), (1043, 800, 6);
