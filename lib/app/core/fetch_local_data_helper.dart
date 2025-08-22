import 'dart:convert';

import 'package:flutter/services.dart';

enum DataSource {
  api,
  localJson,
}

Future<void> fetchAndStoreData<T>({
  required DataSource source,
  required Future<List<T>> Function()? apiCall,
  required String? localJsonPath,
  required Future<void> Function() clearTable,
  required Future<void> Function(List<T> items) insertItems,
  required T Function(Map<String, dynamic>) fromJson,
}) async {
  try {
    List<T> items = [];

    if (source == DataSource.api) {
      if (apiCall != null) {
        items = await apiCall();
      } else {
        throw Exception("API call not provided for $T");
      }
    } else if (source == DataSource.localJson) {
      if (localJsonPath != null) {
        final String response = await rootBundle.loadString(localJsonPath);
        final List<dynamic> data = json.decode(response);
        items = data.map((e) => fromJson(e)).toList();
      } else {
        throw Exception("Local JSON path not provided for $T");
      }
    }

    if (items.isNotEmpty) {
      await clearTable();
      await insertItems(items);
    }
  } catch (e) {
    rethrow;
  }
}


