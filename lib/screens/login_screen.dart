import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Entrar'),
          centerTitle: true,
          actions: [
            TextButton(
              child: const Text('CRIAR CONTA'),
              style: TextButton.styleFrom(
                primary: Colors.white,
                textStyle: const TextStyle(fontSize: 15.0),
              ),
              onPressed: (){
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const SignupScreen()));
              },
            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLoading) {
              return const Center(child: CircularProgressIndicator(),);
            }
            return Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(hintText: 'E-mail'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) {
                          if (text!.isEmpty || !text.contains('@')) {
                            return 'E-mail inválido!';
                          }
                        }
                    ),
                    const SizedBox(height: 16.0,),
                    TextFormField(
                        controller: _passController,
                        decoration: const InputDecoration(hintText: 'Senha'),
                        obscureText: true,
                        validator: (text) {
                          if (text!.isEmpty || text.length < 6) {
                            return 'Senha inválida!';
                          }
                        }
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: const Text('Esqueci minha senha'),
                        style: TextButton.styleFrom(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: (){
                          if (_emailController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Insira seu e-mail para recuperação.'),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                )
                            );
                          } else {
                            model.recoverPass(_emailController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Confira seu e-mail!'),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                )
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      height: 44.0,
                      child: ElevatedButton(
                        child: const Text('Entrar'),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            textStyle: const TextStyle(fontSize: 18.0, color: Colors.white)
                        ),
                        onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            model.signIn(
                                email: _emailController.text,
                                pass: _passController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail
                            );
                          }
                        },
                      ),
                    )
                  ],
                )
            );
          },
        )
    );
  }

  void _onSuccess() {
    Navigator.of(context).pop();
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao entrar!'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }

}
