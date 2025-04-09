import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class InternetConnections {
  Future<void> checkConnectivity(
    BuildContext context, {
    VoidCallback? onDisconnected,
  }) async {
    final result = await Connectivity().checkConnectivity();

    if (result != ConnectivityResult.mobile &&
        result != ConnectivityResult.wifi) {
      if (!context.mounted) return;

      _showSnackbar(
        context,
        "Your internet is not connected. Please check your connection.",
      );

      if (onDisconnected != null) {
        onDisconnected();
      }
    }
  }

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
  displaySnackBar(String messageText,BuildContext context){
    var snackBar = SnackBar(content: Text(messageText));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
