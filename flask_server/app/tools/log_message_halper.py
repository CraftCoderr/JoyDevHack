import flask


def log_msg(source: str, msg: str, type_msg=None):
    main_msg = f'{source} - {msg}'
    return main_msg if type_msg is None else f'[{type_msg}] {main_msg}'


def log_request_msg(source: flask.request, msg: str, type_msg=None):
    main_msg = f'[{str(source.method).upper()}: {source.full_path}] {msg}'
    return main_msg if type_msg is None else f'[{type_msg}] {main_msg}'
