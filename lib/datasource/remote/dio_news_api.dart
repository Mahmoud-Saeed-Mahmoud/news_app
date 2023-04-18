import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api.dart';

/// A class that provides API functionality using Dio.
class Api {
  final Dio _dioRef;

  /// Creates a new [Api] instance with the given Dio client reference.
  Api(this._dioRef);

  /// Sends a GET request to the specified [endpoint] with the given [query]
  /// parameters and API key, and returns the response.
  ///
  /// If an error occurs during the request, it throws an [Error].
  Future<Response> get(String endpoint, String query) async {
    return _dioRef
        .get(
          '$endpoint?$query&apiKey=${Constants.apiKey}',
        )
        .catchError((error, stackTrace) => throw Error);
  }
}

/// A provider that returns a new instance of Dio with a base URL set to the
/// [Constants.baseUrl] constant.
final dioProvider = Provider<Dio>(
  (ref) {
    return Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
      ),
    );
  },
);
