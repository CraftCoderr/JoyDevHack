from tests import logger, client_app


def decorator_http_query(func):
    def wrapper(*args, **kwargs):
        logger.info('[REQUEST] {type_query}: {url}\t\tparams: {params}\t\tjson={json}\t\theaders: {headers}'.format(
            type_query=func.__name__.upper(),
            url=f"{kwargs['url']}",
            params=kwargs['query_params'] if 'query_params' in kwargs else None,
            json=kwargs['json_data'] if 'json_data' in kwargs else None,
            headers=kwargs['headers'] if 'headers' in kwargs else None)
        )
        response = func(*args, **kwargs)
        logger.info(f"[RESPONSE] {response.json}")
        return response

    wrapper.__name__ = func.__name__
    return wrapper


@decorator_http_query
def get(url, headers=None, query_params=None, json_data=None):
    return client_app.get(
        url,
        query_string=query_params,
        headers=headers)


@decorator_http_query
def post(url, headers={}, json_data=None, query_params=None):
    return client_app.post(
        url,
        headers=headers,
        query_string=query_params,
        json=json_data
    )


@decorator_http_query
def put(url, headers={}, json_data=None, query_params=None):
    return client_app.put(
        url,
        headers=headers,
        query_string=query_params,
        json=json_data
    )