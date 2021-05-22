CREATE TABLE IF NOT EXISTS dictionary.users (
    id text NOT NULL,
    registered_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    phone text PRIMARY KEY,
    name text DEFAULT NULL,
    surname text DEFAULT NULL,
    email text DEFAULT NULL,
    token text NOT NULL DEFAULT uuid_generate_v1()
);

COMMENT ON TABLE dictionary.users IS 'Таблица для хранения зарегистрированных пользователей';
COMMENT ON COLUMN dictionary.users.id IS 'Первичный ключ. Уникальный идентификатор записи';
COMMENT ON COLUMN dictionary.users.registered_at IS 'Дата регистрации пользователя. Не изменяется после создания';
COMMENT ON COLUMN dictionary.users.updated_at IS 'Дата последнего изменения. Если не было изменений то null';
COMMENT ON COLUMN dictionary.users.name IS 'Имя пользователя';
COMMENT ON COLUMN dictionary.users.surname IS 'Имя пользователя';
COMMENT ON COLUMN dictionary.users.email IS 'Подтвержденный адрес электронной почты пользователя';
COMMENT ON COLUMN dictionary.users.phone IS 'Подтвержденный номер телефона пользователя';