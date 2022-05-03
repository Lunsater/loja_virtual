import 'package:carousel_pro_nullsafety/carousel_pro_nullsafety.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/model/cart_model.dart';
import 'package:loja_virtual/model/user_model.dart';
import 'package:loja_virtual/screens/cart_screen.dart';
import 'package:loja_virtual/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen(this.product, {Key? key}) : super(key: key);

  final ProductData product;

  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  _ProductScreenState(this.product);

  final ProductData product;

  String? size;

  @override
  Widget build(BuildContext context) {

    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title!),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          AspectRatio(
              aspectRatio: 0.9,
            child: Carousel(
              images: product.images!.map((url) => Image.network(url)).toList(),
              dotSize: 7.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(product.title!,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500
                    ),
                    maxLines: 3,
                  ),
                  Text('R\$ ${product.price!.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                    ),),
                  const SizedBox(height: 16.0,),
                  const Text('Tamanho',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(
                    height: 34.0,
                    child: GridView(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        scrollDirection: Axis.horizontal,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 0.5
                        ),
                      children: product.sizes!.map((s) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              size = s;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                color: size == s ? primaryColor : Colors.grey,
                                width: 3.0
                              )
                            ),
                            width: 50.0,
                            alignment: Alignment.center,
                            child: Text(s),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    height: 44.0,
                    child: ElevatedButton(
                      onPressed: size == null ? null : (){
                        if (UserModel.of(context).isLoggedIn()) {
                          CartProduct cartProduct = CartProduct();
                          cartProduct.pid = product.id;
                          cartProduct.size = size;
                          cartProduct.quantity = 1;
                          cartProduct.category = product.category;
                          cartProduct.productData = product;

                          CartModel.of(context).addCartItem(cartProduct);

                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => const CartScreen()));
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const LoginScreen())
                          );
                        }
                      },
                      child: Text(UserModel.of(context).isLoggedIn() ?
                        'Adicionar ao carrinho' : 'Entre para comprar',
                          style: const TextStyle(fontSize: 18.0),
                        ),
                      style: ElevatedButton.styleFrom(
                        primary: primaryColor,
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0,),
                  const Text('Descrição',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  Text(product.description!,
                    style: const TextStyle(
                        fontSize: 16.0,
                    ),
                  ),
                ],
              ),
          )
        ],
      ),
    );
  }
}
