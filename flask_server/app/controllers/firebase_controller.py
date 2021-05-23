from flask_server.app.tools.file_handler import get_json
import firebase_admin
from firebase_admin import auth
from firebase_admin import credentials


fr_conf = get_json(relative_path='config/firebase_credentials.json', default_data={})
cred = credentials.Certificate(fr_conf)
firebase_admin.initialize_app(cred)