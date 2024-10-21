Map<String, String> castMapToAllStringMap(Map<String, dynamic> map) {
  return map.map((key, value) => MapEntry(key, value.toString()));
}
