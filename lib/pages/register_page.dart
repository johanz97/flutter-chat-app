import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:provider/provider.dart';

import 'package:chatapp/helpers/mostrar_alerta.dart';
import 'package:chatapp/services/auth_service.dart';
import 'package:chatapp/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.95,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Logo(
                    titulo: 'Register',
                  ),
                  _Form(),
                  const Labels(
                    ruta: 'login',
                    link: 'Ingrese ahora',
                    pregunta: '¿Ya tienes cuenta?',
                  ),
                  const Text(
                    'Terminos y condiciones de uso',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            hintText: 'Name user',
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.email_outlined,
            hintText: 'Email adress',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            hintText: 'Password',
            textController: passwordCtrl,
            isPassword: true,
          ),
          BtnAzul(
            onPressed: (authService.autenticar)
                ? null
                : () async {
                    FocusScope.of(context).unfocus();
                    final registerOk = await authService.register(
                        nameCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passwordCtrl.text.trim());
                    if (registerOk == true) {
                      Navigator.pushReplacementNamed(context, 'usuarios');
                    } else {
                      mostrarAlerta(context, 'Registro incorrecto', registerOk);
                    }
                  },
            text: 'Registrar',
          )
        ],
      ),
    );
  }
}
