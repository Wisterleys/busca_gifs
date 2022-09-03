import 'dart:typed_data';

import 'package:buscador_de_gifs/pages/gifpage/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart';
import 'package:transparent_image/transparent_image.dart';


import '../../services/services.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);
  HttpClienAdapt request = HttpClienAdapt();
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
String? _search;
int _offset = 0;
int _limit = 29;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                alignLabelWithHint: true,
                label: Text("Digite sua pesquisa"),
                ),
              onSubmitted: (text){
                setState(() {
                  _search = text==""?null:text;
                  _offset=0;
                });
              },
            ),
            Expanded(
              child: FutureBuilder<Map>(
              future: getData(),
              builder: (context,snapshot){
              var data =  snapshot.data!=null? snapshot.data : {"data":[]};
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                   return Container(
                    width: 200,
                    height: 200,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 8, 8, 8)),
                    ),
                   );
                    
                    
                  default:
                    if(snapshot.hasError){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Erro ao buscar dados na internet")
                        )
                    );
                    return Container();
                  }
                int  _getListCount(List data) {
                    if(_search!=null){
                      return data.length+1;
                    }else{
                      _offset=0;
                      return data.length;
                    }
                  }
                  return GridView.builder(
                    padding: EdgeInsets.all(5),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:100,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,

                      ), 
                      itemCount: _getListCount(data!['data']),
                    itemBuilder: (context,index){
                      String image = "https://www12.senado.leg.br/jovemsenador/home/imagens/carregando/@@images/image.gif";
                       String url;
                      if (data['data'].length>0) {
                        if(index<data['data'].length){
                          url = data['data'][index]['images']['fixed_height']['url'];
                        }else {
                          if(_search!=null){
                            return IconButton(
                            color: Colors.green,
                            onPressed: (){
                              setState(() {
                                _offset+=_limit;
                              });
                            }, 
                            icon: const Icon(Icons.add));
                          }else return Container();
                        };
                      
                      } else {
                        url = image;
                      }
                      return GestureDetector(
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          height: 300.0,
                          fit: BoxFit.cover,
                          image: url
                          ),
                        onTap: (){
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context)=> GifPage(gifData:data['data'][index]))
                            );
                        },
                      );
                    }
                    );
                }
                
              }
              ))
          ],
        ),
          )
    );
  }
  
  Future<Map> getData() async {
    String urls =  "https://api.giphy.com/v1/gifs/trending?api_key=vL70fZv1EVqRh1BrBhSi8N40nrnLRVSN&limit=$_limit&rating=g";
    String searchUrl = "https://api.giphy.com/v1/gifs/search?api_key=vL70fZv1EVqRh1BrBhSi8N40nrnLRVSN&q=$_search&limit=$_limit&offset=$_offset&rating=g&lang=";
    String url = _search!=null? searchUrl : urls;
    return await widget.request.request(
      url: url, method: 'get'
      );
  }
  
  
}
