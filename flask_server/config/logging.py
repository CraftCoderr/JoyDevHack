import logging
from logging.handlers import TimedRotatingFileHandler
from flask_server.config.sys_params import ROOT_DIR
import os

logs_dir = 'logs'

try:
    os.mkdir(os.path.join(ROOT_DIR, logs_dir))
except OSError:
    pass


def create_log(name='app'):
    name_log_file = os.path.join(ROOT_DIR, f"{logs_dir}/{name}.log")
    print(name_log_file)

    log = logging.getLogger(name)
    log.setLevel(logging.DEBUG)

    handler = TimedRotatingFileHandler(name_log_file, when='D', interval=1, backupCount=5)
    handler.setLevel(logging.DEBUG)

    format = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
    handler.setFormatter(format)

    log.addHandler(handler)

    return log


loggers = {
    'app': create_log('app'),
    'test': create_log('test')
}