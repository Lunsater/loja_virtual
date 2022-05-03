import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/model/cart_model.dart';

class DiscountCart extends StatelessWidget {
  const DiscountCart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
          title: Text("Cupom de Desconto",
            textAlign: TextAlign.start,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        leading: const Icon(Icons.card_giftcard),
        trailing: const Icon(Icons.add),
        children: [
          Padding(
              padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom"
              ),
              initialValue: CartModel.of(context).couponCode ?? '',
              onFieldSubmitted: (text) {
                FirebaseFirestore.instance.collection('coupons').doc(text).get()
                    .then((docSnap) {
                  CartModel.of(context).setCoupon(text, docSnap.get('percent'));
                  ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Desconto de ${docSnap.get('percent')}% aplicado!'),
                  backgroundColor: Theme.of(context).primaryColor,));
                }).onError((error, stackTrace) {
                  CartModel.of(context).setCoupon(null, 0);
                  ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cupom não encontrado!'),
                  backgroundColor: Colors.redAccent,));
                });
              }
            ),
          )
        ],
      ),
    );
  }
}
