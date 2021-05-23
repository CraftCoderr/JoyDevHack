CREATE OR REPLACE FUNCTION operations.sp_check_token_expired_at(p_token text)
  RETURNS boolean
  AS $$
  DECLARE
    v_output_result boolean;
    v_token_exp timestamp with time zone;
  BEGIN
      SELECT token_expired_at FROM dictionary.users WHERE token = p_token INTO v_token_exp;
      SELECT CASE WHEN now() >= v_token_exp THEN TRUE ELSE FALSE END INTO v_output_result;
			RETURN v_output_result;
  END;
$$ LANGUAGE plpgsql VOLATILE SECURITY DEFINER;

GRANT EXECUTE ON FUNCTION operations.sp_check_token_expired_at(text) TO postgres;
REVOKE ALL ON FUNCTION operations.sp_check_token_expired_at(text) FROM public;