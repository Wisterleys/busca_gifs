import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget {
  GifPage({Key? key, required this.gifData}) : super(key: key);
  Map gifData;
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Share.share(gifData['images']['fixed_height']['url']);
            }, 
            icon: const Icon(Icons.share)
            )
        ],
        centerTitle: true,
        title: Text(gifData['title'],style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: GestureDetector(
          onLongPress: () {
            Share.share(gifData['images']['fixed_height']['url']);
          },
          child: Image.network(
        gifData['images']['fixed_height']['url'],
        ),
        ),
      ),
    );
  }
}