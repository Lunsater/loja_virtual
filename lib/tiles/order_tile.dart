import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderTile extends StatelessWidget {
  const OrderTile(this.orderId, {Key? key}) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance.collection('orders').doc(orderId).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                int status = snapshot.data!['status'];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Código do pedido: ${snapshot.data!.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(height: 4.0,),
                    Text(
                      _buildProductsText(snapshot.data!)
                    ),
                    const SizedBox(height: 4.0,),
                    const Text('Status do pedido: ',
                      style: TextStyle(fontWeight: FontWeight.bold),),
                    const SizedBox(height: 4.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildCircle('1', 'Preparação', status, 1),
                        Container(
                          height: 1.0,
                          width: 40.0,
                          color: Colors.grey[500],
                        ),
                        _buildCircle('2', 'Transporte', status, 2),
                        Container(
                          height: 1.0,
                          width: 40.0,
                          color: Colors.grey[500],
                        ),
                        _buildCircle('3', 'Entrega', status, 3),
                      ],
                    )
                  ],
                );
              }
            },
          ),
      ),
    );
  }

  String _buildProductsText(DocumentSnapshot snapshot) {
    String text = 'Descrição:\n';
    for (LinkedHashMap p in snapshot.get('products')) {
      text += '${p['quantity']} x ${p['productData']['title']} R\$ ${p['productData']['price']
          .toStringAsFixed(2)}\n';
    }
    text += 'Total: R\$ ${snapshot.get('totalPrice').toStringAsFixed(2)}';
    return text;
  }

  Widget _buildCircle(String title, String subtitle, int status, int thisStatus) {
    Color? bkColor;
    Widget? child;

    if (status < thisStatus) {
      bkColor = Colors.grey[500];
      child = Text(title, style: const TextStyle(color: Colors.white),);
    } else if (status == thisStatus) {
      bkColor = Colors.blue;
      child = Stack(
        alignment: Alignment.center,
        children: [
          Text(title, style: const TextStyle(color: Colors.white),),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          )
        ],
      );
    } else {
      bkColor = Colors.green;
      child = const Icon(Icons.check);
    }

    return Column(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundColor: bkColor,
          child: child,
        ),
        Text(subtitle)
      ],
    );
  }

}

