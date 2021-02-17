import 'dart:convert';
import 'package:easy_shelf/bloc.navigation_bloc/navigation_bloc.dart';
import 'package:easy_shelf/data/data.dart';
import 'package:easy_shelf/helpers/Constants.dart';
import 'package:easy_shelf/helpers/TitleHead.dart';
import 'package:easy_shelf/views/MagazineAndNewsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' as bl;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'BookView.dart';

class MagazineList extends StatefulWidget with NavigationStates {
  @override
  _MagazineList createState() =>  _MagazineList();
}

class _MagazineList extends State<MagazineList> {

  List<Category> magazines;
  List<dynamic> categoriesList;
  List<SelectedCats> selectedCatsList = List();

  _showReportDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          //Here we will build the content of the dialog
          return AlertDialog(
            title: Text("Filter Magazines"),
            content: MultiSelectChip(
              categoriesList,selectedCatsList,
              onSelectionChanged: (selectedList) {
                _magazineData();
                setState(() {
                  selectedCatsList = selectedList;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Filter"),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          );
        });
  }

  // +added
  Future _magazineData () async {
    String url;
    if(selectedCatsList.isEmpty)
     url = urlSt+ '/api/v1/allmagazines';
    else{
      List<int> selectedList = [];
      selectedCatsList.forEach((element) {
        selectedList.add(element.id);
      });
      url = urlSt+ '/api/v1/magazinefliterbycatagories?catagory_id='+selectedList.join(",");
    }

    Map<String, String> headers = {"Content-type": "application/json","Accept": "application/json","Authorization": authKey};
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    List body = jsonDecode(response.body);
    List<Category> mags = [];
    body.forEach((element) {
      mags.add(Category(element['id'],element['title'], element['type'],element['publisher_id'],element['catagory_id'], urlSt+'storage'+element['cover_image']));
    });
    setState(() {
      magazines = mags;
    });
    // print(body);
    return mags;
  }

  Future _categoriesList() async {
    String url = urlSt+'/api/v1/magazinecatagories';
    Map<String, String> headers = {"Content-type": "application/json","Accept": "application/json","Authorization": authKey};
    Response response = await get(url, headers: headers);
    int statusCode = response.statusCode;
    List body = jsonDecode(response.body);
    return body;
  }

  @override
  void initState(){
    _magazineData();
    _categoriesList().then((value) {
      setState(() {
        categoriesList = value;
      });
    });
    super.initState();
  }
  Future<bool> _willPopCallback() async {
    // await showDialog or Show add banners or whatever
    // then
    bl.BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.HomePageClickedEvent);
    return false; // return true if the route to be popped
  }
  @override
  Widget build(BuildContext context) {
    List selectedList = [];
    selectedCatsList.forEach((element) {
      selectedList.add(element.name);
    });
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            TitleHead(
              title: null,
              logo: 'assets/logo_small.png',
              notification: "2",
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  selectedCatsList.isNotEmpty ?
                  Expanded(
                    child: ListTile(
                      title: Text("Showing", style: kTitleTextStyle),
                      subtitle: Text(selectedList.join(" , "), style: TextStyle(
                          fontSize: 10
                      )),
                    ),
                  ) : Text("Showing All Categories", style: kTitleTextStyle),
                  InkWell(
                    onTap: (){
                      _showReportDialog();
                    },
                    child: Text(
                      "Filter",
                      style: kSubtitleTextSyule.copyWith(color: kBlueColor),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            magazines != null ?
            Expanded(
              child: StaggeredGridView.countBuilder(
                padding: EdgeInsets.all(20),
                crossAxisCount: 2,
                itemCount: magazines.length,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MagAndNewsDetails(magazines[index],1)));
                    },
                    child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(20),
                            height: index.isEven ? 200 : 240,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(magazines[index].image),
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
                                magazines[index].name,
                                style: kTitleTextStyle,
                              ),
                              Text(
                                'Type: ${magazines[index].price}',
                                style: TextStyle(
                                  color: kTextColor.withOpacity(.5),
                                ),
                              )
                            ],
                          ),
                        ]
                    ),
                  );
                },
                staggeredTileBuilder: (index) => StaggeredTile.fit(1),
              ),
            ) : Container(height: MediaQuery.of(context).size.height * 0.7,child: Center(child: CircularProgressIndicator(),),),
          ],
        ),
      ),
    ),
    );
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
  final int id;
  final String name;

  SelectedCats(this.id, this.name);

  SelectedCats.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];

  Map<String, dynamic> toJson() =>
      {
        'id': id,
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
              label: Text(item["name"]),
              selected: selectedChoices.where((element) => element.name == item["name"]).isNotEmpty,
              onSelected: (selected) {
                setState(() {
                  selectedChoices.where((element) => element.name == item["name"]).isNotEmpty
                      ? selectedChoices.removeWhere((element) => element.name == item["name"])
                      : selectedChoices.add(SelectedCats(item["id"],item["name"]));
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