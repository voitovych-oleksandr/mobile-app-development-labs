import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:mobile_labs/domain/services/network_service.dart';

class ConnectivityNetworkService implements NetworkService {
  ConnectivityNetworkService([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  static bool _hasNetwork(List<ConnectivityResult> results) =>
      results.any((ConnectivityResult r) => r != ConnectivityResult.none);

  @override
  Future<bool> isOnline() async =>
      _hasNetwork(await _connectivity.checkConnectivity());

  @override
  Stream<bool> get onlineChanges =>
      _connectivity.onConnectivityChanged.map(_hasNetwork).distinct();
}
