import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/login_screen.dart';
import 'package:loja_virtual/tiles/order_tile.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (UserModel.of(context).isLoggedIn()) {
      String uid = UserModel.of(context).currentUser!.uid;
      
      return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance.collection('users').doc(uid)
            .collection('orders').get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView(
                children: snapshot.data!.docs.map((doc) => OrderTile(doc.id)).toList()
                .reversed.toList(),
              );
            }
          }
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.view_list,
                size: 80, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16.0),
            const Text('Faça o login para acompanhar!',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Entrar'),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  textStyle: const TextStyle(fontSize: 18.0, color: Colors.white)
              ),
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const LoginScreen())
                );
              },
            ),
          ],
        ),
      );
    }
  }
}
