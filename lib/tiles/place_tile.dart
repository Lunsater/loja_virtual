import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceTile extends StatelessWidget {
  const PlaceTile(this.snapshot, {Key? key}) : super(key: key);

  final DocumentSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 100.0,
            child: Image.network(snapshot.get('image'),
              fit: BoxFit.cover,),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(snapshot.get('title'),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0
                  ),),
                Text(snapshot.get('address'), textAlign: TextAlign.start,)
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                child: const Text('Ver no mapa'),
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(color: Colors.blue),
                    padding: EdgeInsets.zero
                ),
                onPressed: () {
                  launch('https://www.google.com/maps/search/?api=1&query=${snapshot.get('lat')},${snapshot.get('long')}');
                },
              ),
              TextButton(
                child: const Text('Ligar'),
                style: TextButton.styleFrom(
                    textStyle: const TextStyle(color: Colors.blue),
                    padding: EdgeInsets.zero
                ),
                onPressed: () {
                  launch('tel: ${snapshot.get('phone')}');
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
