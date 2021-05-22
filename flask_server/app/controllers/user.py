from flask_server.app.database.pg_query_handler import result_execute_db_function


def login_user(phone):
    body = None
    code = None
    message = None

    # 1. Пользователь вводит номер телефона для авторизации
    # 2. Номер отправляются на backend, а тот в свою очеред отправляет запрос на  сервис СМС - рассылок(в запросе должен быть сгенерирован hash)
    # 3. Пользователю приходит СМС.Он вводит код из СМС в очередную форму и снова ее отправляет
    # 4. Если СМС совпадает с генерированным - происходит авторизация
    try:
        # generate code for phone
        fun_create_code_for_phone = "operations.sp_generate_code_for_phone('{}')".format(phone)
        result = json.loads(
            db_helper.result_json_execute_db_function(fun_name=fun_create_code_for_phone, log_name='app'))
        print(result)

    if ('sms_code' in result['body']) and ('sms_session' in result['body']):
            sms_code = result['body']['sms_code']
            session = result['body']['sms_session']
            api_id = result['body']['api_id']
            hash = result['body']['hash_in_sms']
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
        else:
            code = result['code'],
            message = result['message']
    except Exception as e:
        code = type(e).__name__
        message = str(e)
    finally:
        return json.dumps({"body": body, "code": code, "message": message}, ensure_ascii=False)
    res = result_execute_db_function(query='SELECT * from operations.users')
    print(res)
    print(type(res))
