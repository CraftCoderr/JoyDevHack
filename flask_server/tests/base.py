from tests import logger
from tests.http import get, post, put


admin_login = 'admin'
admin_password = 'admin'
admin_token = None


def create_admin_user():
    try:
        resp = post(
            url='/roles/admin/users',
            json_data={
                'login': admin_login,
                'pass': admin_password
            }
        )
        check_positive_answer(resp)
        return resp
    except AssertionError as aer:
        logger.error(f'[ERROR][Base] don`t create admin-user Lena: {aer}')
    except Exception as ex:
        print(f'[ERROR][Base] {ex}')


def auth():
    global admin_token
    response = None
    try:
        response = get(
            url='/login',
            query_params={
                'login': admin_login,
                'password': admin_password
            }
        )
        check_positive_answer(response)
    except AssertionError as aer:
        if response.json['code'] == 'VR001':
            response = create_admin_user()
        else:
            raise aer
    finally:
        admin_token = response.json['body']['token']
        return admin_token


def check_positive_answer(response):
    if response.status_code == 403:
        raise ErrorTokenExpired
    assert response.status_code == 200, f'Код статуса ответа НЕ 200'


def tokenization(func):
    def wrapper(*args, **kwargs):
        try:
            kwargs['token'] = admin_token if admin_token is not None else auth()
            return func(*args, **kwargs)
        except ErrorTokenExpired:
            kwargs['token'] = auth()
            return func(*args, **kwargs)
    return wrapper


class ErrorTokenExpired(AssertionError):
    pass