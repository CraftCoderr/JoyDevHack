import psycopg2
import psycopg2.extras
import time
from sshtunnel import SSHTunnelForwarder
from flask_server.app.tools.file_handler import get_json
from flask_server.app import logger
from functools import wraps
from flask_server.app.tools.log_message_halper import log_msg


db_conf = {}


def init_db_conf(server):
    global db_conf
    db_conf = get_json(relative_path='config/db_conf.json', default_data={})[server]


def default_exception_handler(func):
    @wraps(func)
    def _wrapper(*args, **kwargs):
        try:
            return func(*args, **kwargs)
        except Exception as ex:
            logger.error(log_msg(
                type_msg=ex.__class__.__name__,
                msg=str(ex),
                source=func.__name__)
            )
            raise ex
    return _wrapper


@default_exception_handler
def create_db_connection(user, is_dict=False):
    try:
        connection = psycopg2.connect(
            dbname=db_conf[user]['dbname'],
            user=db_conf[user]['user'],
            password=db_conf[user]['user_password'],
            host=db_conf[user]['host'],
            port=db_conf[user]['port'])
        if is_dict:
            cursor = connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        else:
            cursor = connection.cursor(cursor_factory=psycopg2.extras.DictCursor)
        return connection, cursor
    except Exception as ex:
        # print(f"Error: {ex.__class__.__name__}")
        # print(f"Error: {ex}")
        raise ex


@default_exception_handler
def create_db_connection_tunnel(user):
    server = SSHTunnelForwarder(
        (db_conf[user]['host'], 22),
        ssh_username=db_conf[user]['ssh_username'],
        ssh_password=db_conf[user]['ssh_password'],
        remote_bind_address=('localhost', 5432))

    server.start()

    local_port = str(server.local_bind_port)
    connection = psycopg2.connect(
        dbname=db_conf[user]['dbname'],
        user=db_conf[user]['user'],
        password=db_conf[user]['user_password'],
        host=db_conf[user]['host'],
        port=local_port)
    cursor = connection.cursor(cursor_factory=psycopg2.extras.DictCursor)

    return connection, cursor


def reconnect_to_db(user, cron):
    while True:
        try:
            connection, cursor = create_db_connection(user)
            return connection, cursor
        except Exception:
            time.sleep(cron)
            continue
