CREATE OR REPLACE FUNCTION operations.sp_generate_code_for_phone(p_phone text)
  RETURNS jsonb
  AS $$
  DECLARE
    v_error_code text;
    v_error_message text[];
    v_err_msg_text text;
    v_err_detail text;
    v_err_hint text;
    v_output_result jsonb;
    v_sms_code text;
    v_sms_session text;
  BEGIN
    BEGIN
      v_sms_code := floor((random()*(999999-100000)+100000))::text;
      v_sms_session := left(uuid_generate_v1()::text, 4);
      INSERT INTO operations.confirmations(phone, sms_code, sms_session)
        VALUES
        (p_phone, v_sms_code, v_sms_session);

        INSERT INTO operations.confirmations(phone, sms_code, sms_session)
				VALUES (p_phone, v_sms_code, v_sms_session)
				ON CONFLICT (phone) DO UPDATE SET
					sms_code = EXCLUDED.sms_code,
					sms_session = EXCLUDED.sms_session;

      v_output_result := jsonb_build_object('phone', p_phone, 'sms_code', v_sms_code, 'sms_session', v_sms_session);

    EXCEPTION
      WHEN OTHERS THEN
        GET STACKED DIAGNOSTICS
          v_error_code = RETURNED_SQLSTATE,
          v_err_msg_text = MESSAGE_TEXT,
          v_err_detail = PG_EXCEPTION_DETAIL,
          v_err_hint = PG_EXCEPTION_HINT;
          v_error_message := ARRAY[v_err_msg_text, v_err_detail, v_err_hint];
    END;
    RETURN private.output_json_fmt(v_output_result, v_error_code, v_error_message);
  END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION operations.sp_generate_code_for_phone(text) TO postgres;
REVOKE ALL ON FUNCTION operations.sp_generate_code_for_phone(text) FROM public;