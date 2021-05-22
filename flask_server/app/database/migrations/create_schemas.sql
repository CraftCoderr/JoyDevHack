-- create schemas in database CARWASH (user postgres):
CREATE SCHEMA IF NOT EXISTS migration AUTHORIZATION api_user;
COMMENT ON SCHEMA migration IS 'Схема предназначена для хранения таблицы управления миграциями базы данных';

CREATE SCHEMA IF NOT EXISTS operations AUTHORIZATION api_user;
COMMENT ON SCHEMA operations IS 'Схема предназначена для хранения данных выполнения операций';

CREATE SCHEMA IF NOT EXISTS private AUTHORIZATION api_user;
COMMENT ON SCHEMA private IS 'Схема предназначена для хранения helper функций, не видных наружу';

CREATE SCHEMA IF NOT EXISTS logging AUTHORIZATION api_user;
COMMENT ON SCHEMA logging IS 'Схема предназначена для хранения истории активности пользователей';

CREATE SCHEMA IF NOT EXISTS dictionary AUTHORIZATION api_user;
COMMENT ON SCHEMA dictionary IS 'Схема предназначена для хранения справочной информации';

CREATE SCHEMA IF NOT EXISTS immutable AUTHORIZATION api_user;
COMMENT ON SCHEMA immutable IS 'Схема предназначена для хранения справочной информации неизменяемой через интерфейс';


CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- rewoke permissions
REVOKE ALL ON ALL TABLES IN SCHEMA
    migration,
    operations,
    private,
    logging,
    dictionary,
    immutable,
    public,
    information_schema,
    pg_catalog
  FROM PUBLIC, api_user;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA
    migration,
    operations,
    private,
    logging,
    dictionary,
    immutable,
    public,
    information_schema,
    pg_catalog
  FROM PUBLIC, api_user;
REVOKE ALL ON DATABASE
    space
  FROM PUBLIC, api_user;
REVOKE ALL ON ALL FUNCTIONS IN SCHEMA
    migration,
    operations,
    private,
    logging,
    dictionary,
    immutable,
    public,
    information_schema,
    pg_catalog
  FROM PUBLIC, api_user;
REVOKE ALL ON SCHEMA
    migration,
    operations,
    private,
    logging,
    dictionary,
    immutable,
    public,
    information_schema,
    pg_catalog
  FROM PUBLIC, api_user;
REVOKE ALL ON TABLESPACE
    pg_default,
    pg_global
  FROM PUBLIC, api_user;

-- grant permissions to api_user
GRANT ALL ON ALL TABLES IN SCHEMA
    migration,
    operations,
    private,
    logging,
    dictionary,
    immutable,
    public,
    information_schema,
    pg_catalog
  TO api_user;
GRANT ALL ON ALL SEQUENCES IN SCHEMA
    migration,
    operations,
    private,
    logging,
    dictionary,
    immutable,
    public,
    information_schema,
    pg_catalog
  TO api_user;
GRANT ALL ON DATABASE space TO api_user;
GRANT ALL ON ALL FUNCTIONS IN SCHEMA
    migration,
    operations,
    private,
    logging,
    dictionary,
    immutable,
    public,
    information_schema,
    pg_catalog
  TO api_user;
GRANT ALL ON SCHEMA
    migration,
    operations,
    private,
    logging,
    dictionary,
    immutable,
    public,
    information_schema,
    pg_catalog
  TO api_user;
GRANT ALL ON TABLESPACE pg_default, pg_global TO api_user;

-- grant permissions to api_user
GRANT CONNECT ON DATABASE space TO api_user;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA
    operations,
    public,
    pg_catalog
  TO api_user;
GRANT USAGE ON SCHEMA
    operations,
    public,
    pg_catalog
  TO api_user;

  GRANT SELECT ON TABLE pg_catalog.pg_type TO api_user;
  GRANT SELECT ON TABLE pg_catalog.pg_namespace TO api_user;