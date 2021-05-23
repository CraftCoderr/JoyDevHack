from flask_server.app import flask_app
from flask_server.config.logging import loggers
from flask_server.app.database.connection import init_db_conf


logger = loggers['test']
client_app = flask_app.test_client()
logger.info('\n\n')
logger.info('-------------------------------------- START TESTS --------------------------------------')

init_db_conf('local')
