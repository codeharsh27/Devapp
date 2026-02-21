import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

// Removed unused 'network_info.dart' import

final connectivityStreamProvider = StreamProvider<bool>((ref) {
  return Connectivity().onConnectivityChanged.map((results) {
    // connectivity_plus 6.0 returns List<ConnectivityResult>
    return !results.contains(ConnectivityResult.none);
  });
});

class ConnectivityStatusWidget extends ConsumerWidget {
  final Widget child;

  const ConnectivityStatusWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // We need a StreamProvider for real-time updates.
    // Since NetworkInfo is just a Future checker, we should ideally have a Stream.
    // But connectivity_plus provides a stream. Let's use that directly or wrap it.

    // For now, let's create a StreamProvider in this file or use a simple Future/Stream builder
    // if we want to rely on the repository.
    // Actually, NetworkInfoImpl uses Connectivity().checkConnectivity().
    // Connectivity().onConnectivityChanged is what we want.

    final connectivityStream = ref.watch(connectivityStreamProvider);

    return Column(
      children: [
        connectivityStream.when(
          data: (isOnline) {
            if (isOnline) return const SizedBox.shrink();
            return Container(
              width: double.infinity,
              color: Colors.redAccent,
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: const Text(
                "No Internet Connection",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            );
          },
          error: (_, __) => const SizedBox.shrink(),
          loading: () => const SizedBox.shrink(),
        ),
        Expanded(child: child),
      ],
    );
  }
}
