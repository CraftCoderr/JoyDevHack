CREATE TABLE IF NOT EXISTS operations.confirmations (
    phone text NOT NULL,
    sms_code text,
    sms_session text,
    registered_at timestamp with time zone DEFAULT now() NOT NULL
);
COMMENT ON TABLE operations.confirmations IS 'Таблица для хранения СМС кодов подтверждения';
COMMENT ON COLUMN operations.confirmations.phone IS 'Номер телефона';
COMMENT ON COLUMN operations.confirmations.sms_code IS 'Код СМС';
COMMENT ON COLUMN operations.confirmations.sms_code IS 'СМС сессия';
COMMENT ON COLUMN operations.confirmations.registered_at IS 'Дата регистрации';
