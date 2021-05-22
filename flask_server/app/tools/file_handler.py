from os import path
import json
from flask_server.app import logger
from flask_server.config.sys_params import ROOT_DIR
from flask_server.app.tools.log_message_halper import log_msg


#
# получить данные из json-файла
#
def get_json(default_data, relative_path=None, absolute_path=None):
    file_path = absolute_path if relative_path is None else path.join(ROOT_DIR, relative_path)
    try:
        with open(file_path) as json_file:
            return json.load(json_file)
    except FileNotFoundError:
        logger.info(log_msg(
            source=get_json.__name__,
            msg=f'File {file_path} not found. Create empty file.')
        )
        with open(file_path, 'w') as json_file:
            json.dump(default_data, json_file)
        return default_data
    except json.decoder.JSONDecodeError as ex:
        if path.getsize(file_path) <= 0:
            with open(file_path, 'w') as json_file:
                json.dump(default_data, json_file)
            return default_data
        else:
            raise ex