import requests
import psycopg2.errors
from flask_server.app.database.pg_query_handler import result_execute_db_query, result_execute_db_query_dict
import json
from flask_server.app.database.pg_query_handler import result_json_execute_db_function, result_execute_db_function
from flask_server.config.sys_params import SMS_RU_API_KEY, SMS_HASH
from flask_server.app.controllers.stubs import SMS_ru_stub


def login_sms(phone):
    body = None
    code = None
    message = None

    try:
        # generate code for phone
        fun_create_code_for_phone = "SELECT operations.sp_generate_code_for_phone('{}');".format(phone)
        result = result_execute_db_query(query=fun_create_code_for_phone, fetch='one')['sp_generate_code_for_phone']

        # if ('sms_code' in result['body']) and ('sms_session' in result['body']):
        #     sms_code = result['body']['sms_code']
        #     session = result['body']['sms_session']
        #     api_id = SMS_RU_API_KEY
        #     hash = SMS_HASH
        #     msg = '<#>\nВведите проверочный код: {}\n# {}\n{}'.format(sms_code, session, hash)
        #
        #     response = requests.get(
        #         'https://sms.ru/sms/send',
        #         params={
        #             'api_id': api_id,
        #             'to': phone,
        #             'msg': msg,
        #             'json': 1
        #         }
        #     )
        #
        #     body = json.loads(response.text)
        #     print(body)
        #
        #     for sms in body['sms'].values():
        #         if sms['status'] != 'OK':
        #             code = sms['status_code']
        #             message = sms['status_text']
        # else:
        #     code = result['code'],
        #     message = result['message']
        body = SMS_ru_stub()
    except Exception as e:
        code = type(e).__name__
        message = str(e)
    finally:
        return json.dumps({"body": body, "code": code, "message": message}, ensure_ascii=False)


def sms_confirmation(current_phone, sms_code):
    check_sms_code = \
        f"SELECT phone FROM operations.confirmations WHERE sms_code = '{sms_code}';"
    phone = result_execute_db_query(query=check_sms_code, fetch='one')

    if phone is not None and current_phone == phone[0]:
        del_query = f"DELETE FROM operations.confirmations WHERE sms_code = '{sms_code}' AND phone = '{current_phone}';"
        result_execute_db_query(query=del_query)
        return {'body': 'OK', 'code': None, 'message': 'success confirmation'}
    else:
        return {'body': None, 'code': 'SMS_error', 'message': 'Invalid sms code'}


def login_user(phone, user_data=None):
    try:
        query_insert = f"INSERT INTO operations.users (phone) VALUES ({phone});"
        result_execute_db_query(query=query_insert)
    except psycopg2.errors.UniqueViolation:
        pass
    except Exception as ex:
        code = ex.__class__.__name__
        message = ex
        return {'body': None, 'code': code, 'message': message}
    finally:
        query = f"SELECT * FROM operations.users WHERE phone = '{phone}'"
        body = dict(result_execute_db_query_dict(query=query, fetch='one'))
        return {'body': body, 'code': None, 'message': None}