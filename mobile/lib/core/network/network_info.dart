import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkInfoProvider =
    Provider<NetworkInfo>((ref) => NetworkInfoImpl(Connectivity()));

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectionChecker;

  NetworkInfoImpl(this.connectionChecker);

  @override
  Future<bool> get isConnected async {
    final result = await connectionChecker.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }
}
