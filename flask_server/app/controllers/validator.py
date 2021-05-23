from functools import wraps
from flask_server.app import logger
from flask import request


class ValidateError(TypeError):
    def __init__(self, message="Validate params error"):
        self.message = message
        super().__init__(self.message)


def validate(request: request):
    for arg in validate_rules:
        if arg in request.args:
            for type, kwargs in validate_rules[arg].items():
                valid_functions[type](value=request.args[arg], **kwargs)


def valid_not_none(value):
    if value is None:
        raise ValidateError('The value must not be empty')


def valid_type(value, need_type):
    if not isinstance(value, need_type):
        raise ValidateError("Type mismatch")


def valid_number_characters(value: str, number: int):
    if len(value) != number:
        raise ValidateError("Mismatch in the number of characters")


valid_functions = {
    'not_none': valid_not_none,
    'type': valid_type,
    'number_characters': valid_number_characters
}


validate_rules = {
    'phone': {
        'not_none': {},
        'number_characters': {'number': 11}
    },
    'sms_code': {
        'not_none': {},
        'number_characters': {'number': 6}
    }
}