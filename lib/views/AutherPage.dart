import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_shelf/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:easy_shelf/data/data.dart';
import 'package:easy_shelf/helpers/TitleHead.dart';
import 'package:easy_shelf/models/book_model.dart';
import 'package:easy_shelf/views/BookView.dart';
import 'package:flutter/material.dart';

class AuthorProfile extends StatefulWidget with NavigationStates {
  @override
  _AuthorProfile createState() =>  _AuthorProfile();
}

class _AuthorProfile extends State<AuthorProfile> {
  List<String> segments = ["Books By this Author",];
  List<String> segmenter = ["Related Authors",];

  String selectedSegment = "Books By this Author";
  String selectedSegmenter = "Related Authors";

  List<BookModel> books = new List<BookModel>();

  @override
  void initState(){
    books = getBooks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            //mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // TitleHead(
              //   title: null,
              //   logo: 'assets/logo_small.png',
              //   notification: "2",
              // ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      child: Material(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20.0),
                        ),
                        elevation: 10.0,
                        child: Container(
                          height: deviceSize.height * 0.15,
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Color(0xFF1EB998),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                    Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.red,
                                      image: DecorationImage(
                                        image: CachedNetworkImageProvider("https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png"),
                                        fit: BoxFit.contain,
                                      ),
                                      border: Border.all(
                                        color: Color(0xFF1EB998),
                                        width: 3.0,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30.0,
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        "Test Author" ,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(
                                        "+251915151555" ,
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 13.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 20.0,
                                  ),
                              
                                ],
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                          
                            ],
                          ),
                        )
                        ),
                      ),
                    SizedBox(height: 12,),
                    SizedBox(height: 12,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      height: 40,
                      child: ListView.builder(
                          itemCount: segments.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index){
                            return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    selectedSegment = segments[index];
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(right: 25),
                                      child: Text(segments[index], style: TextStyle(
                                          color: selectedSegment == segments[index] ? Colors.black87 : Colors.grey,
                                          fontWeight: selectedSegment == segments[index] ? FontWeight.w600 : FontWeight.w400,
                                          fontSize: selectedSegment == segments[index] ? 18 : 16
                                      ),),
                                    ),
                                    SizedBox(height: 3,),
                                    selectedSegment == segments[index] ? Container(
                                      height: 5,
                                      width: 16,
                                      decoration: BoxDecoration(
                                          color: Color(0xff007084),
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                    ) : Container()
                                  ],
                                )
                            );
                          }),
                    ),
                    Container(
                      height: 200,
                      child: ListView.builder(
                          itemCount: books.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index){
                            return BooksTile(
                              imgAssetPath: books[index].imgAssetPath,
                              rating: books[index].rating,
                              title: books[index].title,
                              description: books[index].description,
                              categorie: books[index].categorie,
                            );
                          }),
                    ),
                   
                   SizedBox(height: 30,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      height: 40,
                      child: ListView.builder(
                          itemCount: segmenter.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index){
                            return GestureDetector(
                                onTap: (){
                                  setState(() {
                                    selectedSegmenter = segmenter[index];
                                  });
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.only(right: 25),
                                      child: Text("Related Authors", style: TextStyle(
                                          color: selectedSegmenter == segmenter[index] ? Colors.black87 : Colors.grey,
                                          fontWeight: selectedSegmenter == segmenter[index] ? FontWeight.w600 : FontWeight.w400,
                                          fontSize: selectedSegmenter == segmenter[index] ? 18 : 16
                                      ),),
                                    ),
                                    SizedBox(height: 3,),
                                    selectedSegmenter == segmenter[index] ? Container(
                                      height: 5,
                                      width: 16,
                                      decoration: BoxDecoration(
                                          color: Color(0xff007084),
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                    ) : Container()
                                  ],
                                )
                            );
                          }),
                    ),
                    Container(
                      height: 200,
                      child: ListView.builder(
                          itemCount: books.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemBuilder: (context, index){
                            return BooksTile(
                              imgAssetPath: books[index].imgAssetPath,
                              rating: books[index].rating,
                              title: books[index].title,
                              description: books[index].description,
                              categorie: books[index].categorie,
                            );
                          }),
                    ),
                
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}