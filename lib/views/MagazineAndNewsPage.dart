import 'dart:convert';
import 'package:easy_shelf/helpers/Constants.dart';
import 'package:easy_shelf/models/single_book_model.dart';
import 'package:easy_shelf/views/BookView.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';

enum Subscription { fivemonths, tenmonths, oneyear, twoyears }

class MagAndNewsDetails extends StatefulWidget {
  final Category magazine;
  final int fromWhere;
  MagAndNewsDetails(this.magazine, this.fromWhere);

  @override
  _MagDetails createState() => _MagDetails();
}

class _MagDetails extends State<MagAndNewsDetails> {
  var isSelected3 = [true, false, false, false];
  List<SingleBookModel> magazines = [];
  List<SingleBookModel> issues = [];
  ScrollController _scrollController = ScrollController();
  int selectedRadio = 1;
// ...
  Subscription _character = Subscription.fivemonths;
  @override
  void initState() {
    super.initState();
    _issuesList().then((value) {
      jsonDecode(value).forEach((element) {
        setState(() {
          if (element['title'] != widget.magazine.name)
            issues.add(SingleBookModel(
              imgAssetPath: urlSt + 'storage' + element['cover_image'],
              type: element['type'],
              title: element['title'],
            ));
        });
      });
    });
    // _magazineData().then((value) {
    //   if (value != null)
    //     value.forEach((element) {
    //       setState(() {
    //         if (element['title'] != widget.magazine.name)
    //           magazines.add(SingleBookModel(
    //             imgAssetPath: urlSt + 'storage' + element['cover_image'],
    //             type: element['type'],
    //             title: element['title'],
    //           ));
    //       });
    //     });
    // });
  }

  Future _issuesList() async {
    String url;
    if (widget.fromWhere == 1)
      url = urlSt +
          '/api/v1/magazineissues?magazine_id=' +
          widget.magazine.id.toString();
    else
      url = urlSt +
          '/api/v1/newspaperissues?newspaper_id=' +
          widget.magazine.id.toString();

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": authKey
    };
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    String body = response.body;
    return body;
  }

  Future _magazineData() async {
    String url;
    if (widget.fromWhere == 1)
      url = urlSt +
          '/api/v1/magazinefliterbycatagories?catagory_id=' +
          widget.magazine.catagory_id.toString();
    else
      url = urlSt +
          '/api/v1/newspaperfliterbycatagories?catagory_id=' +
          widget.magazine.catagory_id.toString();

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": authKey
    };
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    String body = response.body;
    return jsonDecode(body);
  }

  void goUp() {
    _scrollController.animateTo(
      0.0,
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOutQuart,
    );
  }

  _showFormDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel"));
              }),
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Subscribe"));
              })
            ],
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Column(mainAxisSize: MainAxisSize.min, children: [
                  ListTile(
                    title: const Text('5 months'),
                    leading: Radio(
                      value: Subscription.fivemonths,
                      groupValue: _character,
                      onChanged: (Subscription value) {
                        setState(() {
                          _character = value;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('10 months'),
                    leading: Radio(
                      value: Subscription.tenmonths,
                      groupValue: _character,
                      onChanged: (Subscription value) {
                        setState(() {
                          _character = Subscription.tenmonths;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('1 year '),
                    leading: Radio(
                      value: Subscription.oneyear,
                      groupValue: _character,
                      onChanged: (Subscription value) {
                        setState(() {
                          _character = Subscription.oneyear;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('2 years '),
                    leading: Radio(
                      value: Subscription.twoyears,
                      groupValue: _character,
                      onChanged: (Subscription value) {
                        setState(() {
                          _character = Subscription.twoyears;
                        });
                      },
                    ),
                  )
                ]
                    // List<Widget>.generate(4, (int index) {
                    //   return Radio<int>(
                    //     value: index,
                    //     groupValue: selectedRadio,
                    //     onChanged: (int value) {
                    //       setState(() => selectedRadio = value);
                    //     },
                    //   );
                    // }),

                    );
              },
            ),
          );

          //   AlertDialog(

          //     actions: <Widget>[
          //       FlatButton(
          //           onPressed: () => Navigator.pop(context),
          //           child: Text("Cancel")),
          //       FlatButton(
          //           onPressed: () {
          //             Navigator.pop(context);
          //           },
          //           child: Text("Submit"))
          //     ],
          //     title: Text("form"),
          //     content: SingleChildScrollView(
          //       child: Column(
          //         children: <Widget>[
          //           ListTile(
          // title: const Text('5 months'),
          // leading: Radio(
          //   value: Subscription.fivemonths,
          //   groupValue: _character,
          //   onChanged: (Subscription value) {
          //     setState(() { _character = value; });
          //   },
          // ),),
          //        ListTile(
          // title: const Text('10 months'),
          // leading: Radio(
          //   value: Subscription.tenmonths,
          //   groupValue: _character,
          //   onChanged: (Subscription value) {
          //     setState(() { _character = Subscription.tenmonths; });
          //   },
          // ),)
          // ,         ListTile(
          // title: const Text('1 year '),
          // leading: Radio(
          //   value: Subscription.oneyear,
          //   groupValue: _character,
          //   onChanged: (Subscription value) {
          //     setState(() { _character = Subscription.oneyear; });
          //   },
          // ),),
          //          ListTile(
          // title: const Text('2 years '),
          // leading: Radio(
          //   value: Subscription.twoyears,
          //   groupValue: _character,
          //   onChanged: (Subscription value) {
          //     setState(() { _character = Subscription.twoyears; });
          //   },
          // ),)

          //           // TextField(
          //           //   controller: _categoryfield,
          //           //   decoration: InputDecoration(
          //           //       hintText: "write a category", labelText: "Category"),
          //           // ),
          //           // TextField(
          //           //   controller: _descriptionfield,
          //           //   decoration: InputDecoration(
          //           //       hintText: "write a description",
          //           //       labelText: "Description"),
          //           // )
          //         ],
          //       ),
          //     ),
          //   );
        });
  }

  @override
  Widget build(BuildContext context) {
    String titlename = widget.magazine.name;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.35,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                          image: NetworkImage(
                            widget.magazine.image,
                          ),
                          fit: BoxFit.cover,
                        )),
                      ),
                    ),
                    Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                widget.magazine.name,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 21),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Center(
                              child: Text(
                                DateFormat.yMMMMd().format(DateTime.tryParse(
                                    widget.magazine.publisher_date
                                        .substring(0, 10))),
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Center(
                              child: Text(
                                // widget.magazine.publisher_name,
                                'pub',
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w200,
                                    fontSize: 18),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                // Card(
                                IconButton(
                                  icon: Icon(Icons.favorite),
                                  onPressed: () {},
                                ),
                                // ),
                                widget.magazine.price.toLowerCase() == 'free'
                                    ? Container(
                                        width: 65,
                                        decoration: BoxDecoration(
                                            color: Color(0xFF1EB998),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Center(
                                              child: InkWell(
                                                  onTap: () => Navigator.push(
                                                        context,
                                                        MaterialPageRoute<
                                                            dynamic>(
                                                          builder: (_) =>
                                                              PDFViewerFromUrl(
                                                                  url:
                                                                      'http://web.mit.edu/watsan/Docs/Other%20Documents/KAF/Pandey%20-%20Effects%20of%20Air%20Space%20in%20ABF%202004.pdf',
                                                                  title:
                                                                      titlename),
                                                        ),
                                                      ),
                                                  child: Text("Read",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white)))),
                                        ),
                                      )
                                    : Container(
                                        // width:65,
                                        decoration: BoxDecoration(
                                            color: Color(0xFF1EB998),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(18))),
                                        child: Padding(
                                          padding: const EdgeInsets.all(9.0),
                                          child: Center(
                                            child: InkWell(
                                                onTap: () {
                                                  _showFormDialog(context);
                                                },
                                                child: Text("Subscribe to Read",
                                                    style: TextStyle(
                                                        color: Colors.white))),
                                          ),
                                        )

                                        // onPressed: () {},
                                        // color: Colors.white,
                                        ),
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            ),
                            // Text(widget.magazine.)

                            //                    FlatButton(
                            //   onPressed: () => Navigator.push(
                            //     context,
                            //     MaterialPageRoute<dynamic>(
                            //       builder: (_) => const PDFViewerFromUrl(
                            //         url: 'http://web.mit.edu/watsan/Docs/Other%20Documents/KAF/Pandey%20-%20Effects%20of%20Air%20Space%20in%20ABF%202004.pdf',
                            //       ),
                            //     ),
                            //   ),
                            //   child: const Text('PDF From Url'),
                            // ),
                          ],
                        )

                        // Column(
                        //   children: <Widget>[
                        //     Row(
                        //       children: <Widget>[
                        //         Expanded(
                        //           child: Column(
                        //             crossAxisAlignment: CrossAxisAlignment.start,
                        //             mainAxisAlignment:
                        //                 MainAxisAlignment.spaceBetween,
                        //             children: <Widget>[
                        //               Text(
                        //                 widget.magazine.name,
                        //                 style: TextStyle(
                        //                     color: Colors.black87,
                        //                     fontWeight: FontWeight.w700,
                        //                     fontSize: 21),
                        //               ),
                        //               SizedBox(
                        //                 height: 30,
                        //               ),
                        //               ExpandableText(
                        //                 "“${widget.magazine.name}” is a fairy tale written by the Danish author Hans Christian Andersen. The story follows the journey of a young mermaid who is willing to give up her life in the sea as a mermaid to gain a human soul. The tale was first published in 1837 as part of a collection of fairy tales for children.",
                        //                 trimLines: 3,
                        //                 colors: Colors.black,
                        //               ),
                        //               SizedBox(height: 20),
                        //               Text('Subscription', textScaleFactor: 1.3),
                        //               SizedBox(height: 5),
                        //               Container(
                        //                 width: MediaQuery.of(context).size.width *
                        //                     0.4,
                        //                 child: Row(
                        //                   children: [
                        //                     Expanded(
                        //                         child: SizedBox(
                        //                       height: 70.0,
                        //                       child: ListView(
                        //                         scrollDirection: Axis.horizontal,
                        //                         physics: PageScrollPhysics(),
                        //                         controller: _scrollController,
                        //                         children: [
                        //                           ToggleButtons(
                        //                             borderColor: Color.fromRGBO(
                        //                                 44, 149, 121, 1.0),
                        //                             borderWidth: 5,
                        //                             selectedBorderColor:
                        //                                 Color.fromRGBO(
                        //                                     44, 149, 121, 0.8),
                        //                             splashColor: Colors.yellow,
                        //                             borderRadius:
                        //                                 BorderRadius.circular(10),
                        //                             children: [
                        //                               Column(
                        //                                   crossAxisAlignment:
                        //                                       CrossAxisAlignment
                        //                                           .center,
                        //                                   mainAxisAlignment:
                        //                                       MainAxisAlignment
                        //                                           .center,
                        //                                   children: <Widget>[
                        //                                     Text(
                        //                                       "5",
                        //                                       style: TextStyle(
                        //                                           color: Colors
                        //                                               .black),
                        //                                     ),
                        //                                     Text("month"),
                        //                                   ]),
                        //                               Column(
                        //                                   crossAxisAlignment:
                        //                                       CrossAxisAlignment
                        //                                           .center,
                        //                                   mainAxisAlignment:
                        //                                       MainAxisAlignment
                        //                                           .center,
                        //                                   children: <Widget>[
                        //                                     Text(
                        //                                       "10",
                        //                                       style: TextStyle(
                        //                                           color: Colors
                        //                                               .black),
                        //                                     ),
                        //                                     Text("month"),
                        //                                   ]),
                        //                               Column(
                        //                                   crossAxisAlignment:
                        //                                       CrossAxisAlignment
                        //                                           .center,
                        //                                   mainAxisAlignment:
                        //                                       MainAxisAlignment
                        //                                           .center,
                        //                                   children: <Widget>[
                        //                                     Text(
                        //                                       "1",
                        //                                       style: TextStyle(
                        //                                           color: Colors
                        //                                               .black),
                        //                                     ),
                        //                                     Text("year"),
                        //                                   ]),
                        //                               Column(
                        //                                   crossAxisAlignment:
                        //                                       CrossAxisAlignment
                        //                                           .center,
                        //                                   mainAxisAlignment:
                        //                                       MainAxisAlignment
                        //                                           .center,
                        //                                   children: <Widget>[
                        //                                     Text(
                        //                                       "2",
                        //                                       style: TextStyle(
                        //                                           color: Colors
                        //                                               .black),
                        //                                     ),
                        //                                     Text("year"),
                        //                                   ]),
                        //                             ],
                        //                             onPressed: (int index) {
                        //                               setState(() {
                        //                                 for (int buttonIndex = 0;
                        //                                     buttonIndex <
                        //                                         isSelected3
                        //                                             .length;
                        //                                     buttonIndex++) {
                        //                                   if (buttonIndex ==
                        //                                       index) {
                        //                                     isSelected3[
                        //                                             buttonIndex] =
                        //                                         true;
                        //                                   } else {
                        //                                     isSelected3[
                        //                                             buttonIndex] =
                        //                                         false;
                        //                                   }
                        //                                 }
                        //                               });
                        //                             },
                        //                             isSelected: isSelected3,
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     )),
                        //                     Align(
                        //                       alignment: Alignment.centerLeft,
                        //                       child: InkWell(
                        //                         onTap: () {
                        //                           goUp();
                        //                         },
                        //                         child: Container(
                        //                           height: 70,
                        //                           decoration: BoxDecoration(
                        //                             gradient: LinearGradient(
                        //                               begin: Alignment.centerLeft,
                        //                               end: Alignment.centerRight,
                        //                               colors: <Color>[
                        //                                 Color.fromRGBO(
                        //                                     40, 175, 100, 0.8),
                        //                                 Color.fromRGBO(
                        //                                     44, 149, 121, 0.8),
                        //                               ],
                        //                             ),
                        //                           ),
                        //                           child: Center(
                        //                             child: Icon(Icons
                        //                                 .arrow_forward_ios_sharp),
                        //                           ),
                        //                         ),
                        //                       ),
                        //                     )
                        //                   ],
                        //                 ),
                        //               )
                        //             ],
                        //           ),
                        //         ),
                        //         Expanded(
                        //           child: Column(
                        //             children: <Widget>[
                        //               Image.network(
                        //                 widget.magazine.image,
                        //                 height: 170,
                        //                 fit: BoxFit.fitHeight,
                        //               ),
                        //               SizedBox(
                        //                 height: 10,
                        //               ),
                        //               Container(
                        //                   alignment: Alignment.center,
                        //                   padding:
                        //                       EdgeInsets.symmetric(vertical: 18),
                        //                   decoration: BoxDecoration(
                        //                       border: Border.all(
                        //                           color: Color.fromRGBO(
                        //                               44, 149, 121, 1.0),
                        //                           width: 2),
                        //                       borderRadius:
                        //                           BorderRadius.circular(12)),
                        //                   child: Text(
                        //                     "Buy this Issue",
                        //                     style: TextStyle(
                        //                         color: Colors.black,
                        //                         fontSize: 18,
                        //                         fontWeight: FontWeight.w600),
                        //                   )),
                        //             ],
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ],
                        // ),

                        ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        widget.fromWhere == 1
                            ? "Magazine Issues"
                            : "Newspaper Issues",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    issues.isNotEmpty
                        ? Container(
                            height: 250,
                            child: ListView.builder(
                                itemCount: issues.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return SingleBookTile(
                                    title: issues[index].title,
                                    type: issues[index].type,
                                    imgAssetPath: issues[index].imgAssetPath,
                                  );
                                }),
                          )
                        : Container(
                            height: 200,
                            child: Center(
                              child: Text(
                                'Loading...',
                                style: TextStyle(fontWeight: FontWeight.w300),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Similar products",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 18,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    // SizedBox(
                    //   height: 12,
                    // ),
                    // magazines != null
                    //     ? Container(
                    //         height: 250,
                    //         child: ListView.builder(
                    //             itemCount: magazines.length,
                    //             scrollDirection: Axis.horizontal,
                    //             shrinkWrap: true,
                    //             physics: ClampingScrollPhysics(),
                    //             itemBuilder: (context, index) {
                    //               return SingleBookTile(
                    //                 title: magazines[index].title,
                    //                 type: magazines[index].type,
                    //                 imgAssetPath: magazines[index].imgAssetPath,
                    //               );
                    //             }),
                    //       )
                    //     : Container(
                    //         height: 200,
                    //         child: Center(
                    //           child: CircularProgressIndicator(),
                    //         ),
                    //       ),
                  ],
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment(0.85, -0.9),
            child: InkWell(
              onTap: () {
                print("wish");
              },
              splashColor: Colors.white,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFF1EB998),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.star,
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PDFViewerFromUrl extends StatelessWidget {
  const PDFViewerFromUrl({Key key, @required this.url, this.title})
      : super(key: key);

  final String url;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const PDF().fromUrl(
        url,
        placeholder: (double progress) => Center(child: Text('$progress %')),
        errorWidget: (dynamic error) => Center(child: Text(error.toString())),
      ),
    );
  }
}
