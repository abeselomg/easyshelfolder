import 'package:flutter/material.dart';
import 'package:easy_shelf/authapi/api.dart';
import 'depositForm.dart';

class BankList extends StatefulWidget {
  @override
  _BankListState createState() => _BankListState();
}

class _BankListState extends State<BankList> {
  AuthAPI authAPI = new AuthAPI();
  bool loading = true;
  @override
  void initState() {
    // TODO: implement initState
    getbanks();
    super.initState();
  }

  List<dynamic> myProducts = [];
  // List.generate(100000, (index) => {"id": index, "name": "Product $index"})
  //     .toList();

  getbanks() {
    authAPI.getBanks().then((value) {
      print(value['banks']);
      setState(() {
        myProducts = value['banks'];
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Container(
          decoration: BoxDecoration(color: Colors.white),
            child: Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.black,
            )),
          )
        : Scaffold(
            appBar: AppBar(
              // title: Text('Kindacode.com',style: TextStyle(color: Colors.green),),
              backgroundColor: Colors.white10,
              elevation: 0,
              // iconTheme: ,
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20),
                  itemCount: myProducts.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return InkWell(
                      onTap: () {
                        var router = MaterialPageRoute(
                            builder: (BuildContext context) => DepositFormPage(
                                  0,
                                  myProducts[index]["account_no"],
                                  myProducts[index]["legal_name"],
                                  myProducts[index]["banks"]["logo_url"],
                                  myProducts[index]['fname'] +
                                      ' ' +
                                      myProducts[index]['mname'] +
                                      ' ' +
                                      myProducts[index]['lname'],
                                  myProducts[index]["area_code"] +
                                      myProducts[index]["mobile"],
                                ));
                        Navigator.of(context).pushReplacement(router);
                      },
                      child: Container(
// Text(myProducts[index]["banks"]["logo_url"])
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Image.network(
                              myProducts[index]["banks"]["logo_url"],
                              height: 50,
                            ),
                            Text(myProducts[index]["legal_name"]),
                            Text(myProducts[index]["account_no"])
                          ],
                        ),
                        // decoration: BoxDecoration(
                        //     color: Colors.amber,
                        //     borderRadius: BorderRadius.circular(15)),
                      ),
                    );
                  }),
            ),
          );
  }
}
