import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({Key? key, this.pageControler}) : super(key: key);

  final PageController? pageControler;

  @override
  Widget build(BuildContext context) {

    Widget _buildDrawerBack() => Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 203, 236, 241),
                Colors.white
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter
          )
      ),
    );

    return Drawer(
      child: Stack(
        children: [
          _buildDrawerBack(),
          ListView(
            padding: const EdgeInsets.only(left: 32.0, top: 16.0),
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8.0),
                padding: const EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170,
                child: Stack(
                  children: [
                    const Positioned(
                      top: 8.0,
                        left: 0.0,
                        child: Text("Flutter's \n Store",
                          style: TextStyle(fontSize: 34.0, fontWeight: FontWeight.bold),
                        )
                    ),
                    Positioned(
                      left: 0.0,
                        bottom: 0.0,
                        child: ScopedModelDescendant<UserModel> (
                          builder: (context, child, model) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Olá, ${model.isLoggedIn() ? model.userData['name'] : ''}',
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                GestureDetector(
                                  child: Text(model.isLoggedIn() ? 'Sair' : 'Entre ou cadastre-se >',
                                    style: TextStyle(color: Theme.of(context).primaryColor,
                                        fontSize: 16.0, fontWeight: FontWeight.bold),
                                  ),
                                  onTap: (){
                                    if (!model.isLoggedIn()) {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => LoginScreen()));
                                    } else {
                                      model.signOut();
                                    }
                                  },
                                )
                              ],
                            );
                          },
                        )
                    )
                  ],
                ),
              ),
              const Divider(),
              DrawerTile(icon: Icons.home, text: 'Início', pageControler: pageControler, page: 0),
              DrawerTile(icon: Icons.list, text: 'Produtos', pageControler: pageControler, page: 1,),
              DrawerTile(icon: Icons.location_on, text: 'Lojas', pageControler: pageControler, page: 2,),
              DrawerTile(icon: Icons.playlist_add_check, text: 'Meus pedidos', pageControler: pageControler, page: 3,),
            ],
          )
        ],
      ),
    );
  }
}
