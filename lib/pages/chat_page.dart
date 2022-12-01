import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/models/mensajes_response.dart';
import 'package:chat_app/widgets/chat_msg.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';

class ChatPage extends StatefulWidget {
 const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {

  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribiendo = false;
  final List<ChatMsg> _msgs = [];
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    socketService.socket.on('mensaje-personal', _escucharMensaje);
    _cargarHistorial(chatService.usuarioPara.uid);

    super.initState();
  }

  Future<void> _cargarHistorial(String uid) async {
    List<Mensaje>? chat = await chatService.getChat(uid);
    
    final history = chat!.map( (m) => ChatMsg( msg: m.mensaje, uid: m.de, animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 0))..forward() ) );

    setState(() {
      _msgs.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic data){
    ChatMsg newMsg = ChatMsg(msg: data['mensaje'], uid: data['de'], animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 300)));
    setState(() {
      _msgs.insert(0, newMsg);
    });

    newMsg.animationController.forward();
  }

  @override
  void dispose() {
    for(ChatMsg message in _msgs){
      message.animationController.dispose();
    }
    // Off del socket
    socketService.socket.off('mensaje-personal');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: Text(usuarioPara.nombre.substring(0,2), style: const TextStyle(fontSize: 12))
            ),

            const SizedBox(height: 3),

            Text(usuarioPara.nombre, style: const TextStyle(color: Colors.black87, fontSize: 14),),

          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: SizedBox(
        child: Column(
          children: [

            Flexible(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _msgs.length,
                itemBuilder: ( _ , index) => _msgs[index],
                reverse: true,
              )
            ),

            const Divider(height: 1),

            Container(
              color: Colors.white,
              child: _inputChat(),
            )

          ],
        ),
      ),
   );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [

            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: (value) {
                  _handleSubmit(value);
                },
                onChanged: (value) {
                  setState(() {
                    if(value.trim().isNotEmpty){
                      _estaEscribiendo = true;
                    } else {
                      _estaEscribiendo = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Aa'
                ),
                focusNode: _focusNode,
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: 
                (Platform.isIOS) 

                  ? CupertinoButton(
                    onPressed: (_estaEscribiendo) 
                      ? () => _handleSubmit(_textController.text.trim())
                      : null,
                    child: const Text('Enviar'), 
                  )
                  
                  : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: IconThemeData(color: Colors.blue[400]),
                      child: IconButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        icon: const Icon(Icons.send),
                        onPressed: (_estaEscribiendo)
                          ? () => _handleSubmit(_textController.text.trim()) 
                          : null, 
                      ),
                    ),
                  ),
            )
          ],
        ),
      )
    );
  }

  _handleSubmit(String msg) {
    if(msg.isEmpty){ 
      _focusNode.requestFocus();
      return;
    }

    final newMsg = ChatMsg(
      msg: msg, 
      uid: authService.usuario.uid,
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)),
    );

    _msgs.insert(0, newMsg);
    newMsg.animationController.forward();
    _textController.clear();
    _focusNode.requestFocus();
    
    setState(() {
      _estaEscribiendo = false;
    });

    socketService.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': msg
    });
  }
  

}