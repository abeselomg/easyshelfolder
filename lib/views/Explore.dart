import 'dart:convert';
import 'package:easy_shelf/data/data.dart';
import 'package:easy_shelf/helpers/Constants.dart';
import 'package:easy_shelf/views/BookView.dart';
import 'package:easy_shelf/views/MagazineAndNewsPage.dart';
import 'package:easy_shelf/views/book_details.dart';
import 'package:easy_shelf/views/first.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePage createState() => _ExplorePage();
}

class _ExplorePage extends State<ExplorePage> {
  String selectedSegment = "My books";
  List<String> categories = ["My books","My newspapers","My magazines"];
  List<SelectedCats> selectedCatsList = List();
  List<dynamic> categoriesList = ["Books","Newspapers","Magazines"];
  AutoScrollController controller;
  Map<String,dynamic> myProductsList = {};
  bool logged;

  @override
  void initState() {
    super.initState();
    _booksData();
    _newspaperData();
    _magazineData();
    checkIfAuthenticated().then((success) {
      setState(() {
        logged = success;
      });
    });
    controller = AutoScrollController(
        viewportBoundaryGetter: () =>
            Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        axis: Axis.horizontal);
  }

  // +added
  Future _booksData () async {
    String url = urlSt+ '/api/v1/allbooks';

    Map<String, String> headers = {"Content-type": "application/json","Accept": "application/json","Authorization": authKey};
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    List body = jsonDecode(response.body);
    List<Category> mags = [];
    body.forEach((element) {
      setState(() {
        mags.add(Category(element['id'],element['title'], element['type'],element['publisher_id'],element['catagory_id'], urlSt+'storage'+element['cover_image']));
      });
    });
    setState(() {
      myProductsList.addAll({
        "My books" : mags
      });
    });
    return body;
  }

  Future _newspaperData () async {
    String url = urlSt+ '/api/v1/allnewspapers';

    Map<String, String> headers = {"Content-type": "application/json","Accept": "application/json","Authorization": authKey};
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    List body = jsonDecode(response.body);
    List<Category> mags = [];
    body.forEach((element) {
      setState(() {
        mags.add(Category(element['id'],element['title'], element['type'],element['publisher_id'],element['catagory_id'], urlSt+'storage'+element['cover_image']));
      });
    });
    setState(() {
      myProductsList.addAll({
        "My newspapers" : mags
      });
    });
    return body;
  }

  Future _magazineData () async {
    String url = urlSt+ '/api/v1/allmagazines';

    Map<String, String> headers = {"Content-type": "application/json","Accept": "application/json","Authorization": authKey};
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    List body = jsonDecode(response.body);
    List<Category> mags = [];
    body.forEach((element) {
      setState(() {
        mags.add(Category(element['id'],element['title'], element['type'],element['publisher_id'],element['catagory_id'], urlSt+'storage'+element['cover_image']));
      });
    });
    setState(() {
      myProductsList.addAll({
        "My magazines" : mags
      });
    });
    return mags;
  }


  checkIfAuthenticated() async {  // could be a long running task, like a fetch from keychain
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogged = prefs.getBool('isLoggedIn') ?? false;
    return isLogged;
  }

  @override
  Widget build(BuildContext context) {
    List<String> selectedCats = [];
    selectedCatsList.forEach((element) { selectedCats.add(element.name); });
    if(logged != null){
      if(logged){
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 60,
                    child: Center(
                      child: Text(
                        "My Shelf",
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 30),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      children: <Widget>[
                        SvgPicture.asset("assets/icons/search.svg"),
                        SizedBox(width: 16),
                        Text(
                          "Search for anything",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFA0A5BD),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    height: 40,
                    child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: ClampingScrollPhysics(),
                        controller: controller,
                        itemBuilder: (context, index){
                          return GestureDetector(
                              onTap: (){
                                setState(() {
                                  selectedSegment = categories[index];
                                });
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(right: 25),
                                    child: Text(categories[index], style: TextStyle(
                                        color: selectedSegment == categories[index] ? Colors.black87 : Colors.grey,
                                        fontWeight: selectedSegment == categories[index] ? FontWeight.w600 : FontWeight.w400,
                                        fontSize: selectedSegment == categories[index] ? 23 : 18
                                    ),),
                                  ),
                                  SizedBox(height: 3,),
                                  selectedSegment == categories[index] ? Container(
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
                  SizedBox(height: 5,),
                  myProductsList[selectedSegment] != null ?
                  Expanded(
                    child: StaggeredGridView.countBuilder(
                      padding: EdgeInsets.all(0),
                      crossAxisCount: 2,
                      itemCount: myProductsList[selectedSegment].length,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            if(selectedSegment == "My books")
                              Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetails( myProductsList[selectedSegment][index])));
                            else if(selectedSegment == "My newspapers")
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MagAndNewsDetails(myProductsList[selectedSegment][index],2)));
                            else
                              Navigator.push(context, MaterialPageRoute(builder: (context) => MagAndNewsDetails(myProductsList[selectedSegment][index],1)));
                          },
                          child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(20),
                                  height: index.isEven ? 200 : 240,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(16),
                                    image: DecorationImage(
                                      image: NetworkImage(myProductsList[selectedSegment][index].image),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 18,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      myProductsList[selectedSegment][index].name,
                                      style: kTitleTextStyle,
                                    ),
                                    Text(
                                      'Price: \$${myProductsList[selectedSegment][index].price}',
                                      style: TextStyle(
                                        color: kTextColor.withOpacity(.5),
                                      ),
                                    )
                                  ],
                                ),
                              ]),
                        );
                      },
                      staggeredTileBuilder: (index) => StaggeredTile.fit(1),
                    ),
                  ) : Container(height: 200, child: Center(child: CircularProgressIndicator(),),),
                ],
              ),
            ),
          ),
        );
      }else{
        return FirstPage();
      }
    }else{
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}

class MultiSelectChip extends StatefulWidget {
  final List<dynamic> categoriesList;
  final List<SelectedCats> prevSelected;
  final Function(List<dynamic>) onSelectionChanged;

  MultiSelectChip(this.categoriesList, this.prevSelected,{this.onSelectionChanged});

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class SelectedCats {
  final String name;

  SelectedCats(this.name);

  SelectedCats.fromJson(Map<String, dynamic> json)
      : name = json['name'];

  Map<String, dynamic> toJson() =>
      {
        'name' : name,
      };
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  // String selectedChoice = "";
  List<SelectedCats> selectedChoices = List();

  _buildChoiceList() {
    List<Widget> choices = List();
    selectedChoices = widget.prevSelected;
    widget.categoriesList.forEach((item) {
      choices.add(
          Container(
            padding: const EdgeInsets.all(2.0),
            child: ChoiceChip(
              label: Text(item),
              selected: selectedChoices.where((element) => element.name == item).isNotEmpty,
              onSelected: (selected) {
                setState(() {
                  selectedChoices.where((element) => element.name == item).isNotEmpty
                      ? selectedChoices.removeWhere((element) => element.name == item)
                      : selectedChoices.add(SelectedCats(item));
                  widget.onSelectionChanged(selectedChoices);
                });
              },
            ),
          )
      );
    });

    return choices;
  }

  @override
  Widget build(BuildContext context) {
    print(selectedChoices);
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}