import 'dart:convert';
import 'package:easy_shelf/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:easy_shelf/helpers/Constants.dart';
import 'package:easy_shelf/sidebar/drawer.dart';
import 'package:easy_shelf/views/BookView.dart';
import 'package:easy_shelf/views/MagazineAndNewsPage.dart';
import 'package:easy_shelf/views/book_details.dart';
import 'package:easy_shelf/widget/Customlisttile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_shelf/data/data.dart';
import 'package:easy_shelf/models/book_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bl;
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget with NavigationStates {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class SquareButton extends StatelessWidget {
  final String label;
  final Icon icon;
  final int route;

  SquareButton({
    @required this.label,
    @required this.icon,
    @required this.route,
  })  : assert(label != null),
        assert(icon != null);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(
          width: 80.0,
          height: 80.0,
          child: CupertinoButton(
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(20.0),
            onPressed: () {},
            color: Theme.of(context).primaryColor,
            child: Icon(
              icon.icon,
              size: 46.0,
            ),
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          width: 70.0,
          height: 20.0,
          child: Center(
            child: Text(
              label,
              style: Theme.of(context).textTheme.caption.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
        ),
      ],
    );
  }
}

class Products {
  final List<Category> products;

  Products(this.products);

  Products.fromJson(Map<String, dynamic> json) : products = json['products'];

  Map<String, dynamic> toJson() => {
        'products': products,
      };
}

class _MyHomePageState extends State<MyHomePage> {
  // final DateFormat formatter = DateFormat.yMMM();
  String selectedSegment = "My books";
  List<String> categories = ["My books", "My newspapers", "My magazines"];
  var isSelected3 = [true, false, false];
  var theSelected = [false, true, false];
  var activeTab = 'magazine';
  List<BookModel> books = new List<BookModel>();
  List<Category> latestList = [];
  List<Category> booksList = [];
  List<Category> magazinesList = [];
  List<Category> newspaperList = [];
  List defaultList = [];

  AutoScrollController controller;

  @override
  void initState() {
    super.initState();
    defaultList = magazinesList;
    // _latestData();
    _booksData();
    _newspaperData();
    _magazineData();
    books = getBooks();
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
  }

  Future _latestData() async {
    String url = urlSt + '/api/v1/recent';

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": authKey
    };
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    print("asd");
    print(response.body);
    List body = jsonDecode(response.body);
    body.forEach((element) {
      setState(() {
        latestList.add(Category(
          element['id'],
          element['title'],
          element['type'],
          element['publisher_id'],
          element['catagory_id'],
          urlSt + 'storage' + element['cover_image'],
          element['catagory']['name'],
          element['publisher']['full_name'],
          element['created_at'],
        ));
      });
    });
    return body;
  }

  // +added
  Future _booksData() async {
    String url = urlSt + '/api/v1/allbooks';

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": authKey
    };
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    print(response.body);
    List body = jsonDecode(response.body);
    body.forEach((element) {
      setState(() {
        booksList.add(Category(
          element['id'],
          element['title'],
          element['type'],
          element['publisher_id'],
          element['catagory_id'],
          urlSt + 'storage' + element['cover_image'],
          element['catagory']['name'],
          element['publisher']['full_name'],
          element['created_at'],
        ));
      });
    });
    return body;
  }

  Future _newspaperData() async {
    String url = urlSt + '/api/v1/allnewspapers';

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": authKey
    };
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    List body = jsonDecode(response.body);
    print(body[0]['catagory']['name']);
    print(body[0]['catagory']);
    print(body[0]['publisher']['full_name']);
    print(body[0]['publisher']);

    body.forEach((element) {
      setState(() {
        newspaperList.add(Category(
          element['id'],
          element['title'],
          element['type'],
          element['publisher_id'],
          element['catagory_id'],
          urlSt + 'storage' + element['cover_image'],
          element['catagory']['name'],
          element['publisher']['full_name'],
          element['created_at'],
        ));
      });
    });
    return body;
  }

  Future _magazineData() async {
    String url = urlSt + '/api/v1/allmagazines';

    Map<String, String> headers = {
      "Content-type": "application/json",
      "Accept": "application/json",
      "Authorization": authKey
    };
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    List body = jsonDecode(response.body);
    print("MEGAZINE");
    print(body[0]['catagory']['name']);
    print(body[0]['catagory']);
    print(body[0]['publisher']['full_name']);
    print(body[0]['publisher']);
    List<Category> mags = [];
    body.forEach((element) {
      setState(() {
        magazinesList.add(Category(
          element['id'],
          element['title'],
          element['type'],
          element['publisher_id'],
          element['catagory_id'],
          urlSt + 'storage' + element['cover_image'],
          element['catagory']['name'],
          element['publisher']['full_name'],
          element['created_at'],
        ));
      });
    });
    return mags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF1EB998)),
          backgroundColor: Colors.white10),
      drawer: DrawerNavigation(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Padding(padding: EdgeInsets.only(left: 25), child: Text("Find a product you want to read", style: kSubheadingextStyle),),
              Container(
                margin: EdgeInsets.only(left: 25, top: 0,right: 35),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 40,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Row(
                  children: <Widget>[
                    SizedBox(width: 20),
                    SvgPicture.asset("assets/icons/search.svg"),
                    SizedBox(width: 10),
                    Text(
                      "Search for anything",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFFA0A5BD),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView(
                  children: <Widget>[
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Container(
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: <Widget>[
                    //           Container(
                    //             padding: EdgeInsets.only(right: 25),
                    //             child: Text(
                    //               "Latest Release",
                    //               style: TextStyle(
                    //                   color: Colors.grey,
                    //                   fontWeight: FontWeight.w600,
                    //                   fontSize: 23),
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             height: 3,
                    //           ),
                    //           Container(
                    //             margin: EdgeInsets.only(left: 10),
                    //             height: 5,
                    //             width: 16,
                    //             decoration: BoxDecoration(
                    //                 color: Color(0xff007084),
                    //                 borderRadius: BorderRadius.circular(12)),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         bl.BlocProvider.of<NavigationBloc>(context)
                    //             .add(NavigationEvents.LatestPageClickedEvent);
                    //       },
                    //       child: Text(
                    //         "See more",
                    //         style:
                    //             kSubtitleTextSyule.copyWith(color: kBlueColor),
                    //       ),
                    //     )
                    //   ],
                    // // ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // latestList.isNotEmpty
                    //     ? Container(
                    //         height: 250,
                    //         child: ListView.builder(
                    //             itemCount: latestList.length,
                    //             scrollDirection: Axis.horizontal,
                    //             shrinkWrap: true,
                    //             physics: ClampingScrollPhysics(),
                    //             itemBuilder: (context, index) {
                    //               return GestureDetector(
                    //                 onTap: () {
                    //                   Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                           builder: (context) => BookDetails(
                    //                               latestList[index])));
                    //                 },
                    //                 child: SingleBookTile(
                    //                   title: latestList[index].name,
                    //                   type: latestList[index].price,
                    //                   imgAssetPath: latestList[index].image,
                    //                 ),
                    //               );
                    //             }),
                    //       )
                    //     : Container(
                    //         height: 200,
                    //         child: Center(
                    //           child: CircularProgressIndicator(),
                    //         ),
                    //       ),

//********************** LIST OF BOOKS********************************************* */

                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Container(
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: <Widget>[
                    //           Container(
                    //             padding: EdgeInsets.only(right: 25),
                    //             child: Text(
                    //               "Books",
                    //               style: TextStyle(
                    //                   color: Colors.grey,
                    //                   fontWeight: FontWeight.w600,
                    //                   fontSize: 23),
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             height: 3,
                    //           ),
                    //           Container(
                    //             margin: EdgeInsets.only(left: 10),
                    //             height: 5,
                    //             width: 16,
                    //             decoration: BoxDecoration(
                    //                 color: Color(0xff007084),
                    //                 borderRadius: BorderRadius.circular(12)),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         bl.BlocProvider.of<NavigationBloc>(context)
                    //             .add(NavigationEvents.BooksListClickEvent);
                    //       },
                    //       child: Text(
                    //         "See more",
                    //         style:
                    //             kSubtitleTextSyule.copyWith(color: kBlueColor),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    // booksList.isNotEmpty
                    //     ? Container(
                    //         height: 250,
                    //         child: ListView.builder(
                    //             itemCount: booksList.length,
                    //             scrollDirection: Axis.horizontal,
                    //             shrinkWrap: true,
                    //             physics: ClampingScrollPhysics(),
                    //             itemBuilder: (context, index) {
                    //               return GestureDetector(
                    //                 onTap: () {
                    //                   Navigator.push(
                    //                       context,
                    //                       MaterialPageRoute(
                    //                           builder: (context) => BookDetails(
                    //                               booksList[index])));
                    //                 },
                    //                 child: SingleBookTile(
                    //                   title: booksList[index].name,
                    //                   type: booksList[index].price,
                    //                   imgAssetPath: booksList[index].image,
                    //                 ),
                    //               );
                    //             }),
                    //       )
                    //     : Container(
                    //         height: 200,
                    //         child: Center(
                    //           child: CircularProgressIndicator(),
                    //         ),
                    //       ),

//********************** LIST OF NEWSPAPER********************************************* */

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.only(right: 25),
                                child: Text(
                                  "Latest",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                      fontSize: 18),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                height: 5,
                                width: 16,
                                decoration: BoxDecoration(
                                    color: Color(0xff007084),
                                    borderRadius: BorderRadius.circular(12)),
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            bl.BlocProvider.of<NavigationBloc>(context)
                                .add(NavigationEvents.BooksListClickEvent);
                          },
                          child: Text(
                            "See more",
                            style: kSubtitleTextSyule.copyWith(
                                color: kBlueColor, fontSize: 14),
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    newspaperList.isNotEmpty
                        ? Container(
                            height: 230,
                            child: ListView.builder(
                                itemCount: newspaperList.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BookDetails(
                                                      newspaperList[index]
                                                      )));
                                    },
                                    child: SingleBookTile(
                                      title: newspaperList[index].name,
                                      type: newspaperList[index].price,
                                      imgAssetPath: newspaperList[index].image,
                                    ),
                                  );
                                }),
                          )
                        : Container(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: <Widget>[
                    //     Container(
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: <Widget>[
                    //           Container(
                    //             padding: EdgeInsets.only(right: 25),
                    //             child: Text(
                    //               "Magazines",
                    //               style: TextStyle(
                    //                   color: Colors.grey,
                    //                   fontWeight: FontWeight.w600,
                    //                   fontSize: 23),
                    //             ),
                    //           ),
                    //           SizedBox(
                    //             height: 3,
                    //           ),
                    //           Container(
                    //             margin: EdgeInsets.only(left: 10),
                    //             height: 5,
                    //             width: 16,
                    //             decoration: BoxDecoration(
                    //                 color: Color(0xff007084),
                    //                 borderRadius: BorderRadius.circular(12)),
                    //           )
                    //         ],
                    //       ),
                    //     ),
                    //     InkWell(
                    //       onTap: () {
                    //         bl.BlocProvider.of<NavigationBloc>(context)
                    //             .add(NavigationEvents.MagazineListClickEvent);
                    //       },
                    //       child: Text(
                    //         "See more",
                    //         style:
                    //             kSubtitleTextSyule.copyWith(color: kBlueColor),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    // SizedBox(
                    //   height: 5,
                    // ),
                    Center(
                      child: ToggleButtons(
                        // borderColor: Color.fromRGBO(44, 149, 121, 1.0),
                        borderWidth: 1,
                        // selectedBorderColor: Color.fromRGBO(44, 149, 121, 0.8),
                        splashColor: Colors.yellow,
                        borderRadius: BorderRadius.circular(10),
                        selectedColor: Colors.green,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text("Books"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text("Magazines"),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text("News"),
                          ),
                        ],

                        onPressed: (int index) {
                          print(index);
                          print(DateFormat.yMMM().format(DateTime.now()));
                          setState(() {
                            index == 1
                                ? activeTab = 'magazine'
                                : index == 0
                                    ? activeTab = 'book'
                                    : activeTab = 'news';
                            for (int buttonIndex = 0;
                                buttonIndex < theSelected.length;
                                buttonIndex++) {
                              if (buttonIndex == index) {
                                theSelected[buttonIndex] = true;
                              } else {
                                theSelected[buttonIndex] = false;
                              }
                            }
                          });
                        },
                        isSelected: theSelected,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
// magazine
// news
// book
                    activeTab == 'magazine'
                        ? magazinesList.isNotEmpty
                            ? Container(
                                // height: 400,
                                child: ListView.builder(
                                    itemCount: 4,
                                    // scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      MagAndNewsDetails(
                                                          magazinesList[index],
                                                          1)));
                                        },
                                        child: CustomListItemTwo(
                                          thumbnail: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(18.0),
                                            child: Image.network(
                                              magazinesList[index].image,
                                              // height: 20,
                                              // width: 20,
                                            ),
                                          ),
                                          title: magazinesList[index].name,
                                          subtitle: DateFormat.yMMMMd().format(
                                              DateTime.tryParse(
                                                  magazinesList[index]
                                                      .publisher_date
                                                      .substring(0, 10))),
                                          publishDate: magazinesList[index]
                                              .publisher_name,
                                          readDuration:
                                              magazinesList[index].price,
                                        ),
                                      );

                                      // GestureDetector(
                                      //   onTap: () {
                                      //     Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) =>
                                      //                 MagAndNewsDetails(
                                      //                     magazinesList[index],
                                      //                     1)));
                                      //   },
                                      //   child: SingleBookTile(
                                      //     title: magazinesList[index].name,
                                      //     type: magazinesList[index].price,
                                      //     imgAssetPath: magazinesList[index].image,
                                      //   ),
                                      // );
                                    }),
                              )
                            : Container(
                                height: 200,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                        : activeTab == 'news'
                            ? newspaperList.isNotEmpty
                                ? Container(
                                    // height: 400,
                                    child: ListView.builder(
                                        itemCount: 4,
                                        // scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MagAndNewsDetails(
                                                              newspaperList[
                                                                  index],
                                                              1)));
                                            },
                                            child: CustomListItemTwo(
                                              thumbnail: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                child: Image.network(
                                                  newspaperList[index].image,
                                                  // height: 20,
                                                  // width: 20,
                                                ),
                                              ),
                                              title: newspaperList[index].name,
                                              subtitle: DateFormat.yMMMMd()
                                                  .format(DateTime.tryParse(
                                                      newspaperList[index]
                                                          .publisher_date
                                                          .substring(0, 10))),
                                              publishDate: newspaperList[index]
                                                  .publisher_name,
                                              readDuration:
                                                  newspaperList[index].price,
                                            ),
                                          );

                                          // GestureDetector(
                                          //   onTap: () {
                                          //     Navigator.push(
                                          //         context,
                                          //         MaterialPageRoute(
                                          //             builder: (context) =>
                                          //                 MagAndNewsDetails(
                                          //                     magazinesList[index],
                                          //                     1)));
                                          //   },
                                          //   child: SingleBookTile(
                                          //     title: magazinesList[index].name,
                                          //     type: magazinesList[index].price,
                                          //     imgAssetPath: magazinesList[index].image,
                                          //   ),
                                          // );
                                        }),
                                  )
                                : Container(
                                    height: 200,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                            : booksList.isNotEmpty
                                ? Container(
                                    // height: 400,
                                    child: ListView.builder(
                                        itemCount: 4,
                                        // scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          MagAndNewsDetails(
                                                              booksList[index],
                                                              1)));
                                            },
                                            child: CustomListItemTwo(
                                              thumbnail: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                child: Image.network(
                                                  booksList[index].image,
                                                  // height: 20,
                                                  // width: 20,
                                                ),
                                              ),
                                              title: booksList[index].name,
                                              subtitle: DateFormat.yMMMMd()
                                                  .format(DateTime.tryParse(
                                                      booksList[index]
                                                          .publisher_date
                                                          .substring(0, 10))),
                                              publishDate: booksList[index]
                                                  .publisher_name,
                                              readDuration:
                                                  booksList[index].price,
                                            ),
                                          );

                                          // GestureDetector(
                                          //   onTap: () {
                                          //     Navigator.push(
                                          //         context,
                                          //         MaterialPageRoute(
                                          //             builder: (context) =>
                                          //                 MagAndNewsDetails(
                                          //                     magazinesList[index],
                                          //                     1)));
                                          //   },
                                          //   child: SingleBookTile(
                                          //     title: magazinesList[index].name,
                                          //     type: magazinesList[index].price,
                                          //     imgAssetPath: magazinesList[index].image,
                                          //   ),
                                          // );
                                        }),
                                  )
                                : Container(
                                    height: 200,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),

                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 28.0),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            bl.BlocProvider.of<NavigationBloc>(context)
                                .add(NavigationEvents.BooksListClickEvent);
                          },
                          child: Text(
                            "See more",
                            style: kSubtitleTextSyule.copyWith(
                                fontWeight: FontWeight.bold,
                                color: kBlueColor,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
