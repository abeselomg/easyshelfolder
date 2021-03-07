import 'package:flutter/material.dart';
import 'package:easy_shelf/profile/listOfBanks.dart';
class Topup extends StatefulWidget {
  @override
  _TopupState createState() => _TopupState();
}

class _TopupState extends State<Topup> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/logo.png'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 16),
        child: Column(
          children: <Widget>[
            Text(
              'Top-up Balance',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17
              ),
              ),
            SizedBox(height: 64),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 30,
              color: Colors.green,
              child: Text(
                'Local',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17
              ),
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () {
                   Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                BankList()));
                  },
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.account_balance),
                          // Image.asset(
                          //   'assets/images/nog.png',
                          //   height: MediaQuery.of(context).size.width*.3,
                          //   width: MediaQuery.of(context).size.width*.3,
                          //   ),
                          Text('Bank Account'),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                BankList()));
                  },
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Icon(Icons.wallet_giftcard),
                          // Image.asset(
                          //   'assets/images/nog.png',
                          //   height: MediaQuery.of(context).size.width*.3,
                          //   width: MediaQuery.of(context).size.width*.3,
                          //   ),
                          Text('Wallet Banking'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 30,
              color: Colors.green,
              child: Text(
                'International',
                style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17
              ),
                ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                InkWell(
                  onTap: () {
                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                BankList()));
                  },
                  child: Card(
                    elevation: 5,
                    margin: EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                           Icon(Icons.payment),
                          // Image.asset(
                          //   'assets/images/nog.png',
                          //   height: MediaQuery.of(context).size.width*.3,
                          //   width: MediaQuery.of(context).size.width*.3,
                          //   ),
                          Text('Pay Pal'),
                        ],
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                          Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                BankList()));
                  },
                  child: Card(
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                            Icon(Icons.credit_card),
                          // Image.asset(
                          //   'assets/images/nog.png',
                          //   height: MediaQuery.of(context).size.width*.3,
                          //   width: MediaQuery.of(context).size.width*.3,
                          //   ),
                          Text('Credit/Debit Card'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}