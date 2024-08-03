class NotInitializedError extends Error {
  @override
  String toString() => 'The configuration has not been initialized.';
}

class EmptyEnvFileError extends Error {
  @override
  String toString() => 'The environment file is empty.';
}

class FileNotFoundError extends Error {
  @override
  String toString() => 'The file was not found.';
}
