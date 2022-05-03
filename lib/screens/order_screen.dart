import 'package:flutter/material.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen(this.orderId, {Key? key}) : super(key: key);

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedido Realizado'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check, color: Theme.of(context).primaryColor, size: 80.0,),
            const Text('Pedido realizado com sucesso!',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),),
            Text('Código do pedido: $orderId', style: const TextStyle(fontSize: 16.0),)
          ],
        ),
      ),
    );
  }
}
