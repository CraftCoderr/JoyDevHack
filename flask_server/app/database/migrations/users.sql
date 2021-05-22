CREATE TABLE IF NOT EXISTS operations.users (
    id uuid PRIMARY KEY NOT NULL DEFAULT uuid_generate_v1(),
    registered_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone,
    password text,
    name text,
    surname text,
    email text DEFAULT NULL,
    phone text UNIQUE NOT NULL
);

COMMENT ON TABLE operations.users IS 'Таблица для хранения зарегистрированных пользователей';
COMMENT ON COLUMN operations.users.id IS 'Первичный ключ. Уникальный идентификатор записи';
COMMENT ON COLUMN operations.users.registered_at IS 'Дата регистрации пользователя. Не изменяется после создания';
COMMENT ON COLUMN operations.users.updated_at IS 'Дата последнего изменения. Если не было изменений то null';
COMMENT ON COLUMN operations.users.password IS 'Зашифрованный пароль пользователя';
COMMENT ON COLUMN operations.users.name IS 'Имя пользователя';
COMMENT ON COLUMN operations.users.surname IS 'Имя пользователя';
COMMENT ON COLUMN operations.users.email IS 'Подтвержденный адрес электронной почты пользователя';
COMMENT ON COLUMN operations.users.phone IS 'Подтвержденный номер телефона пользователя';

insert into operations.users (
    password ,
    name ,
    surname ,
    email ,
    phone ) values
('lena_pwd', 'Lena', 'Kaida', 'elenanikolaevna999@yandex.ru', '7978711111111'),
('vlad_pwd', 'Vlad', 'Stelmah', 'vlad@yandex.ru', '7978711111112');