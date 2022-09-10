import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;

  ServerStatus get serverStatus => _serverStatus;
  late IO.Socket _socket;
  IO.Socket get socket => _socket;

  SocketService() {
    initConfig();
  }

  void initConfig() {
    _socket = IO.io('http://192.168.1.5:9091/', {
      'transports': ['websocket'],
      'autoConnect': true
    });
    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }
}
