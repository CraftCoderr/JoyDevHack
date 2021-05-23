import requests
import json
import psycopg2.errors
from flask_server.app.database.pg_query_handler import result_execute_db_query
from flask_server.config.sys_params import SMS_RU_API_KEY, SMS_HASH
from flask_server.app.controllers.stubs import SMS_ru_stub
from flask_server.config.sys_params import TOKEN_LIVE_TIME

import firebase_admin
from firebase_admin import auth
import flask_server.app.controllers.firebase_controller


def login_sms(phone):
    body = None
    code = None
    message = None

    try:
        # generate code for phone
        fun_create_code_for_phone = "SELECT operations.sp_generate_code_for_phone('{}');".format(phone)
        result = result_execute_db_query(query=fun_create_code_for_phone, fetch='one')[0]

        if ('sms_code' in result['body']) and ('sms_session' in result['body']):
            sms_code = result['body']['sms_code']
            session = result['body']['sms_session']
            api_id = SMS_RU_API_KEY
            hash = SMS_HASH
            msg = '<#>\nВведите проверочный код: {}\n# {}\n{}'.format(sms_code, session, hash)

            response = requests.get(
                'https://sms.ru/sms/send',
                params={
                    'api_id': api_id,
                    'to': phone,
                    'msg': msg,
                    'json': 1
                }
            )

            body = json.loads(response.text)

            for sms in body['sms'].values():
                if sms['status'] != 'OK':
                    code = sms['status_code']
                    message = sms['status_text']
        else:
            code = result['code'],
            message = result['message']
        # body = SMS_ru_stub()
    except Exception as e:
        code = type(e).__name__
        message = str(e)
    finally:
        return json.dumps({"body": body, "code": code, "message": message}, ensure_ascii=False)


def sms_confirmation(current_phone, sms_code):
    check_sms_code = f"SELECT phone FROM operations.confirmations WHERE sms_code = '{sms_code}';"
    phone = result_execute_db_query(query=check_sms_code, fetch='one')

    if phone is not None and current_phone == phone[0]:
        del_query = f"DELETE FROM operations.confirmations WHERE sms_code = '{sms_code}' AND phone = '{current_phone}';"
        result_execute_db_query(query=del_query)
        return {'body': 'OK', 'code': None, 'message': 'success confirmation'}
    else:
        return {'body': None, 'code': 'SMS_error', 'message': 'Invalid sms code'}


def login_user(phone, user_data=None):
    try:
        new_user = auth.create_user(phone_number=f'+{phone}')
        
        query_insert = f"INSERT INTO dictionary.users (id, phone, token_expired_at) VALUES ('{new_user.uid}', '{phone}', now() + interval '{TOKEN_LIVE_TIME}');"
        result_execute_db_query(query=query_insert)
    except (firebase_admin.auth.PhoneNumberAlreadyExistsError, psycopg2.errors.UniqueViolation):
        pass
    except Exception as ex:
        code = ex.__class__.__name__
        message = ex
        return {'body': None, 'code': code, 'message': message}
    finally:
        query = f"SELECT * FROM dictionary.users WHERE phone = '{phone}'"
        user = result_execute_db_query(query=query, is_dict=True, fetch='one')
        if user is None:
            user = auth.get_user_by_phone_number(phone_number=f'+{phone}')
            query_insert = f"INSERT INTO dictionary.users (id, phone, token_expired_at) VALUES ('{user.uid}', '{phone}', now() + interval '{TOKEN_LIVE_TIME}');"
            result_execute_db_query(query=query_insert)
        query_update = f"UPDATE dictionary.users SET token_expired_at = now() + interval '{TOKEN_LIVE_TIME}' WHERE phone = '{phone}'"
        result_execute_db_query(query=query_update)
        body = dict(result_execute_db_query(query=query, is_dict=True, fetch='one'))
        return {'body': body, 'code': None, 'message': None}