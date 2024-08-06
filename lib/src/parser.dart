/// Creates key-value pairs from a JSON map.
class Parser {
  /// [Parser] methods are pure functions.
  const Parser();

  /// Creates a [Map](dart:core) from a JSON map.
  /// In this case, the input is already a map, so no additional parsing is required.
  Map<String, String> parse(Map<String, dynamic> jsonMap) {
    final out = <String, String>{};
    jsonMap.forEach((key, value) {
      if (value is String) {
        out[key] = value;
      } else {
        // If the value is not a string, you may decide how to handle it
        // For simplicity, convert non-string values to their string representation
        out[key] = value.toString();
      }
    });
    return out;
  }

  /// Parses a single line into a key-value pair.
  Map<String, String> parseOne(
    String line, {
    Map<String, String> env = const {},
  }) {
    // In this case, `parseOne` is not used because the input is a JSON map
    throw UnsupportedError('parseOne is not applicable for JSON input.');
  }

  /// Substitutes $bash_vars in [val] with values from [env].
  String interpolate(String val, Map<String, String?> env) {
    // If your JSON values do not include bash variables, you may skip interpolation
    // For completeness, here's a stub that does nothing
    return val;
  }

  /// If [val] is wrapped in single or double quotes, returns the quote character.
  String surroundingQuote(String val) {
    // No longer needed for JSON values
    return '';
  }

  /// Removes quotes (single or double) surrounding a value.
  String unquote(String val) {
    // No longer needed for JSON values
    return val;
  }

  /// Strips comments (trailing or whole-line).
  String strip(String line, {bool includeQuotes = false}) {
    // Comments are not part of JSON, so this is not used
    return line;
  }

  /// Omits 'export' keyword.
  String swallow(String line) {
    // Not applicable for JSON data
    return line;
  }
}
