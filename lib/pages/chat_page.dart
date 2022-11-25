import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/chat_msg.dart';

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

  @override
  void initState() {
    
    super.initState();
  }

  @override
  void dispose() {
    // Off del socket
    for(ChatMsg message in _msgs){
      message.animationController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              child: const Text('EE', style: TextStyle(fontSize: 12))
            ),

            const SizedBox(height: 3),

            const Text('Erick Estrada', style: TextStyle(color: Colors.black87, fontSize: 14),),

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
      uid: '123',
      animationController: AnimationController(vsync: this, duration: const Duration(milliseconds: 200)),
    );

    _msgs.insert(0, newMsg);
    newMsg.animationController.forward();
    _textController.clear();
    _focusNode.requestFocus();
    
    setState(() {
      _estaEscribiendo = false;
    });
  }
}