from flask import request
from app import flask_app, logger
from app.tools.log_message_halper import log_request_msg
from app.tools.system_handler import decorator_request, system_response


def get_json_from_request(required=False):
    try:
        json_data = request.get_json()
        return json_data
    except Exception as e:
        logger.error(
            log_request_msg(
                type_msg=e.__class__.__name__,
                msg=f"Couldn't get json: {str(e)}",
                source=request
            )
        )
        if required is True:
            raise e
        else:
            return None


@flask_app.route("/")
@decorator_request
def index():
    return system_response(result="Hello world! {}".format(request.url_root))