import argparse
from flask_server.config.sys_params import CONFIGURATION_TYPES, DEFAULT_CONFIGURATION


def create_parser():
    parser = argparse.ArgumentParser()
    parser.add_argument('-conf', '--configuration',
                        nargs='?',
                        choices=CONFIGURATION_TYPES,
                        default=DEFAULT_CONFIGURATION)
    return parser
