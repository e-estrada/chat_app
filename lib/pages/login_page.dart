
import 'package:flutter/material.dart';
import 'package:chat_app/widgets/widgets.dart';



class LoginPage extends StatelessWidget {
 const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                const Logo(title: 'Messenger'),
        
                _Form(),
        
                const Labels(route: 'register', titulo: '¿No tienes cuenta?', subtitulo: 'Crea una ahora!'),
        
                const Text('Terminos y condiciones de uso', style: TextStyle(fontWeight: FontWeight.w200),),
                
              ],
            ),
          ),
        ),
      ),
   );
  }
}


class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {

  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [

          CustomInput(
            icon: Icons.email_outlined,
            placeHolder: 'Email',
            keyBoardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          
          CustomInput(
            icon: Icons.key_outlined,
            placeHolder: 'Password',
            isPassword: true,
            textController: passCtrl,
          ),

          BotonAzul(text: 'Login', onPressed: () {}),

        ],
      ),
    );
  }
}


