CREATE OR REPLACE FUNCTION private.output_json_fmt(
  p_output_json jsonb,
  p_error_code text,
  p_error_msg text[]) RETURNS jsonb
  LANGUAGE plpgsql
  VOLATILE
  SECURITY DEFINER
AS $$
  DECLARE
    v_output_msg jsonb;
    v_error_msg text;
  BEGIN
    FOR i IN COALESCE(array_lower(p_error_msg,1), 0)..COALESCE(array_upper(p_error_msg,1), -1) LOOP
        v_error_msg := concat_ws(' ', v_error_msg, p_error_msg[i]);
    END LOOP;

    IF LENGTH(TRIM(v_error_msg)) = 0 THEN
      v_error_msg := null;
    END IF;

    v_output_msg := json_build_object(
      'body', p_output_json,
      'code', p_error_code,
      'message', v_error_msg);
    RETURN v_output_msg;
  END;
$$;
REVOKE ALL ON FUNCTION private.output_json_fmt(jsonb, text, text[]) FROM PUBLIC, postgres;
