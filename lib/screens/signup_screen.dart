import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Criar conta'),
          centerTitle: true,
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
                        controller: _nameController,
                        decoration: const InputDecoration(hintText: 'Nome completo'),
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Nome inválido!';
                          }
                        }
                    ),
                    const SizedBox(height: 16.0,),
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
                    const SizedBox(height: 16.0,),
                    TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(hintText: 'Endereço'),
                        validator: (text) {
                          if (text!.isEmpty) {
                            return 'Endereço inválido!';
                          }
                        }
                    ),
                    const SizedBox(height: 16.0,),
                    SizedBox(
                      height: 44.0,
                      child: ElevatedButton(
                        child: const Text('Criar conta'),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor,
                            textStyle: const TextStyle(fontSize: 18.0, color: Colors.white)
                        ),
                        onPressed: (){
                          if (_formKey.currentState!.validate()) {
                            Map<String, dynamic> userData = {
                              'name': _nameController.text,
                              'email': _emailController.text,
                              'address': _addressController.text
                            };
                            model.signUp(
                                userData: userData,
                                pass: _passController.text,
                                onSuccess: _onSuccess,
                                onFail: _onFail);
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
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: const Text('Usuário criado com sucesso!'),
            backgroundColor: Theme.of(context).primaryColor,
            duration: const Duration(seconds: 2),
        )
    );
    Future.delayed(const Duration(seconds: 2)).then((value) => Navigator.of(context).pop());
  }

  void _onFail() {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao criar usuário!'),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}
