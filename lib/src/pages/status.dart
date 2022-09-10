import 'dart:ffi';

import 'package:band_names/src/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Server status ${socketService.serverStatus}')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.socket.emit('emitir-mensaje',
              {'nombre': 'flutter', 'mensaje': 'hola desde flutter'});
        },
      ),
    );
  }
}
