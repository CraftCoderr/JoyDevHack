from app import flask_app
from config.logging import loggers
from app.database.connection import init_db_conf


logger = loggers['test']
client_app = flask_app.test_client()
logger.info('\n\n')
logger.info('-------------------------------------- START TESTS --------------------------------------')

init_db_conf('local')
