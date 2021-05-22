CREATE OR REPLACE FUNCTION private.output_json_fmt(
  p_user_id uuid,
  p_output_json jsonb,
  p_error_code text,
  p_error_msg text[],
  p_log_flag boolean DEFAULT true,
  p_transaction_id uuid DEFAULT NULL) RETURNS jsonb
  LANGUAGE plpgsql
  VOLATILE
  SECURITY DEFINER
AS $$
  DECLARE
    v_output_msg jsonb;
    v_error_msg text;
  BEGIN
    FOR i IN COALESCE(array_lower(p_error_msg,1), 0)..COALESCE(array_upper(p_error_msg,1), -1) LOOP
      IF private.is_valid_jsonb(p_error_msg[i]) THEN
        p_output_json := COALESCE(p_output_json || p_error_msg[i]::jsonb,  p_error_msg[i]::jsonb);
      ELSE
        v_error_msg := concat_ws(' ', v_error_msg, p_error_msg[i]);
      END IF;
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
REVOKE ALL ON FUNCTION private.output_json_fmt(uuid, jsonb, text, text[], boolean, uuid) FROM PUBLIC, api_user;
