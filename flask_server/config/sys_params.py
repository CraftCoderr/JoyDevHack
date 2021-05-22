import os

CONFIGURATION_TYPES = ['prod', 'local']
DEFAULT_CONFIGURATION = CONFIGURATION_TYPES[0]

ROOT_DIR = os.path.dirname(os.path.dirname(__file__))