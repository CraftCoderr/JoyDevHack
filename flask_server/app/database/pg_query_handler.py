import json
from flask_server.app.database import connection
import psycopg2.extras
from flask_server.app import logger
import re


def execute_db_function(func):
  def wrapper(*args, **kwargs):
    conn = cursor = ''
    try:
      conn, cursor = connection.create_db_connection('api_user')
      fun = strPY_to_strPG(kwargs['query'])
      cursor.execute(fun)
      kwargs['db_answer'] = cursor.fetchall()
      conn.commit()
      return func(*args, **kwargs)
    except (Exception, psycopg2.Error) as error:
      logger.info('from result_execute_db_function exception: {}'.format(str(error)))
      raise error
    finally:
      if (cursor): cursor.close()
      if (conn): conn.close()
  wrapper.__name__ = func.__name__
  return wrapper


@execute_db_function
def result_execute_db_function(query, db_answer, log_name='app'):
  return db_answer[0]


@execute_db_function
def result_json_execute_db_function(query, db_answer, log_name='app'):
  return str(json.dumps(db_answer[0], sort_keys=False, indent=4, ensure_ascii=False, separators=(',', ': ')))


def jsonPY_to_jsonbPG(json_data: dict):
  if json_data == {} or json_data is None:
    return "NULL"
  json_str = json.dumps(json_data)
  json_str = re.sub("'none'", 'NULL', json_str, flags=re.IGNORECASE)
  json_str = re.sub("none", 'NULL', json_str, flags=re.IGNORECASE)
  json_str = json_str.replace("'", "''")
  return "'{}'".format(json_str)


def strPY_to_strPG(data: str):
  data_pg = data
  data_pg = re.sub("'none'", 'NULL', data_pg, flags=re.IGNORECASE)
  data_pg = re.sub("none", 'NULL', data_pg, flags=re.IGNORECASE)
  return data_pg


def jsonPGstr_to_jsonbPY(json_data_str):
  json_data_str = json_data_str.lower()
  json_data = json.loads(json_data_str)
  return json_data


def converting_to_PG_format(data):
  if isinstance(data, str):
    return strPY_to_strPG(data)
  if isinstance(data, dict):
    return jsonPY_to_jsonbPG(data)
