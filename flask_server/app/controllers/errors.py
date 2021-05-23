class ValidateError(TypeError):
    def __init__(self, message="Validate params error"):
        self.message = message
        super().__init__(self.message)


class TokenNotFound(ValueError):
    def __init__(self, message="Token not found"):
        self.message = message
        super().__init__(self.message)


class TokenExpired(ValueError):
    def __init__(self, message="Token expired"):
        self.message = message
        super().__init__(self.message)