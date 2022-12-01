import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chat_app/services/auth_service.dart';

class ChatMsg extends StatelessWidget {
  
  final String msg;
  final String uid;
  final AnimationController animationController;
  
  const ChatMsg({
    super.key, 
    required this.msg, 
    required this.uid, 
    required this.animationController
  });

  @override
  Widget build(BuildContext context) {

    final authService = Provider.of<AuthService>(context, listen: false);

    return FadeTransition(
      opacity: animationController,
      child: SizeTransition(
        sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
        child: Container(
          child: (uid == authService.usuario.uid)
            ? _myMsg()
            : _notMyMsg()
        ),
      ),
    );
  }

  Widget _myMsg(){
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 5, left: 50, right: 5),
        decoration: BoxDecoration(
          color: const Color(0xff4D9EF6),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text(msg, style: const TextStyle(color: Colors.white),),
      ),
    );
  }

  Widget _notMyMsg(){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 5, left: 5, right: 50),
        decoration: BoxDecoration(
          color: const Color(0xffE4E5E8),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Text(msg, style: const TextStyle(color: Colors.black87),),
      ),
    );
  }


}