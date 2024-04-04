# Define custom exceptions here for different use cases

class AppError(Exception):
    pass


class AlreadyExistsError(AppError):
    pass


class NotFoundError(AppError):
    pass


class AuthError(AppError):
    pass


class InvalidParameterError(NotFoundError):
    pass
