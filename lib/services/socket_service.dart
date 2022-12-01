import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';


enum ServerStatus {
  online,
  offline,
  connecting
}

class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.connecting;
  late io.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  io.Socket get socket => _socket;
  Function get emit => _socket.emit;

  void connect() async{
    
    final token = await AuthService.getToken();
    // Dart client
    _socket = io.io(Environment.socketUrl, 
      io.OptionBuilder().setTransports(['websocket'])
        .enableAutoConnect()
        .enableForceNew()
        .setExtraHeaders({
          'x-token': token
        })
        .build()
    );

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    
    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    _socket.on('nuevo-mensaje', (data) {
      // print(data);
    });

    
  }

  void disconnect() {
    _socket.disconnect();
  }


}