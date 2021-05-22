from unittest import TestCase
from flask_server.tests import base
from flask_server.tests.http import get, post, put


class TestIndex(TestCase):

    def test_index(self):
        response = get(
            url='/'
        )
        print(response.data)
        assert response.data == b'Hello world! http://localhost/', 'Произведен запуск не на локальном сервере'

    # @base.tokenization
    # def test_login(self, token):
    #     response = get(
    #         url='/login',
    #         query_params={
    #             'login': '',
    #             'password': ''
    #         }
    #     )
    #     base.check_positive_answer(response)