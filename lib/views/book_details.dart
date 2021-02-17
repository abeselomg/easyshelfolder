import 'dart:convert';

import 'package:easy_shelf/data/data.dart';
import 'package:easy_shelf/helpers/Constants.dart';
import 'package:easy_shelf/models/single_book_model.dart';
import 'package:easy_shelf/resource/colors.dart';
import 'package:easy_shelf/resource/widgets.dart';
import 'package:easy_shelf/views/AutherPage.dart';
import 'package:easy_shelf/views/BookView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BookDetails extends StatefulWidget {
  final Category book;

  BookDetails(this.book);

  @override
  _BookDetails createState() => _BookDetails();
}

class _BookDetails extends State<BookDetails> {
  List<SingleBookModel> books = [];

  @override
  void initState() {
    super.initState();

    _bookData().then((value) {
      value.forEach((element) {
        setState(() {
          if(element['title'] != widget.book.name)
            books.add(SingleBookModel(
              imgAssetPath: urlSt +'storage'+ element['cover_image'],
              type: element['type'],
              title: element['title'],
            ));
        });
      });
    });
  }

  Future _bookData () async {
    String url = urlSt+ '/api/v1/bookfliterbycatagories?catagory_id='+widget.book.catagory_id.toString();

    Map<String, String> headers = {"Content-type": "application/json","Accept": "application/json","Authorization": authKey};
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    String body = response.body;
    return jsonDecode(body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(
                                widget.book.image,
                              ),
                              fit: BoxFit.contain,
                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 20),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      child: Text(widget.book.name, style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 21
                                      ),),
                                    ),
                                    SizedBox(height: 15,),
                                    Row(
                                      children: <Widget>[
                                        Text("Test Auther", style: TextStyle(
                                            color: Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16
                                        ),),
                                        SizedBox(width: 10,),
                                        InkWell(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(
                                                builder: (context) => AuthorProfile()
                                            ));
                                          },
                                          child: Text("About Auther", style: TextStyle(
                                              color: darkGreen,
                                              fontSize: 14
                                          ),),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    StarRating(rating: 5,),
                                    SizedBox(height: 6,),
                                    Text("Fairy Tales", style: TextStyle(
                                        color: darkGreen,
                                        fontSize: 14
                                    ),)
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 20,),
                            ExpandableText(
                              "“${widget.book.name}” is a fairy tale written by the Danish author Hans Christian Andersen. The story follows the journey of a young mermaid who is willing to give up her life in the sea as a mermaid to gain a human soul. The tale was first published in 1837 as part of a collection of fairy tales for children.",
                              trimLines:3,
                              colors: Colors.black,
                            ),
                            SizedBox(height: 30,),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(vertical: 18),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(12)
                                    ),
                                    child: Text("Read Sample", style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600
                                    ),),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.symmetric(vertical: 18),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: greyColor,width: 2
                                          ),
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      child: Text(
                                        "Buy",
                                        style: TextStyle(
                                            color: greyColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Text("Similar products", style: TextStyle(
                          color: Colors.black87,
                          fontSize: 18,
                          fontWeight: FontWeight.w500
                      ),),
                      SizedBox(height: 12,),
                      books.isNotEmpty ?
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        height: 250,
                        child: ListView.builder(
                            itemCount: books.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context, index){
                              return SingleBookTile(
                                title: books[index].title,
                                type: books[index].type,
                                imgAssetPath: books[index].imgAssetPath,
                              );
                            }),
                      ) : Container(height: 200, child: Center(child: CircularProgressIndicator(),),),
                    ],
                  ),
                ),

              ],
            ),
            Align(
              alignment: Alignment(0.85,-0.9),
              child: InkWell(
                onTap: (){
                  print("wish");
                },
                splashColor: Colors.white,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(Icons.star,color: Colors.white,),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
