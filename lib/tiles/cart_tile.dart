import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/model/cart_model.dart';

class CartTile extends StatelessWidget {
  const CartTile(this.cartProduct, {Key? key}) : super(key: key);

  final CartProduct cartProduct;

  @override
  Widget build(BuildContext context) {

    Widget _buildContent() {
      CartModel.of(context).updatePrices();

      return Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            width: 120,
            child: Image.network(cartProduct.productData?.images?[0],
              fit: BoxFit.cover,),
          ),
          Expanded(
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(cartProduct.productData!.title!,
                      style: const TextStyle(fontWeight: FontWeight.w500,
                          fontSize: 17.0),),
                    Text('Tamanho: ${cartProduct.size!}',
                        style: const TextStyle(fontWeight: FontWeight.w300)),
                    Text('R\$ ${cartProduct.productData!.price!.toStringAsFixed(2)}',
                      style: TextStyle(color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          color: Theme.of(context).primaryColor,
                          onPressed: cartProduct.quantity! > 1 ?
                              (){
                                CartModel.of(context).decProduct(cartProduct);}
                              : null,
                        ),
                        Text(cartProduct.quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          color: Theme.of(context).primaryColor,
                          onPressed: (){
                            CartModel.of(context).incProduct(cartProduct);},
                        ),
                        TextButton(child: const Text('Remover'),
                          style: TextButton.styleFrom(primary: Colors.grey[500]),
                          onPressed: (){
                            CartModel.of(context).removeCartItem(cartProduct);
                          },)
                      ],
                    )
                  ],
                ),
              )
          )
        ],
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.productData == null ?
        FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection("products")
              .doc(cartProduct.category).collection("items")
                .doc(cartProduct.pid).get(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                cartProduct.productData = ProductData?.fromDocument(snapshot.data!);
                return _buildContent();
              } else {
                return Container(
                  height: 70.0,
                  child: const CircularProgressIndicator(),
                  alignment: Alignment.center,
                );
              }
            }) : _buildContent(),
    );
  }
}
