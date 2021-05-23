from config.logging import loggers
from flask import Flask

logger = loggers['app']
flask_app = Flask(__name__)

from app import routes
