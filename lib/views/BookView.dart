import 'package:easy_shelf/resource/widgets.dart';
import 'package:easy_shelf/views/book_details.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BooksTile extends StatelessWidget {
  final String imgAssetPath, title, description, categorie;
  final int rating;
  BooksTile(
      {@required this.rating,
      @required this.description,
      @required this.title,
      @required this.categorie,
      @required this.imgAssetPath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(context, MaterialPageRoute(
        //     builder: (context) => BookDetails(null)
        // ));
      },
      child: Container(
        height: 200,
        margin: EdgeInsets.only(right: 16),
        alignment: Alignment.bottomLeft,
        child: Stack(
          children: <Widget>[
            Container(
              height: 180,
              alignment: Alignment.bottomLeft,
              child: Container(
                  width: MediaQuery.of(context).size.width - 80,
                  height: 140,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 110,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 220,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              title,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              description,
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                            Spacer(),
                            Row(
                              children: <Widget>[
                                StarRating(
                                  rating: rating,
                                ),
                                Spacer(),
                                Text(
                                  categorie,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
            Container(
              height: 180,
              margin: EdgeInsets.only(
                left: 12,
                top: 6,
              ),
              child: Image.asset(
                imgAssetPath,
                height: 150,
                width: 100,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SingleBookTile extends StatelessWidget {
  final String title, type, imgAssetPath;
  SingleBookTile({this.title, this.type, this.imgAssetPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125,
      padding: EdgeInsets.only(left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Material(
            elevation: 3,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  imgAssetPath,
                  height: 170,
                  fit: BoxFit.fitHeight,
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            title,
            style: TextStyle(
                color: Color(0xff007084),
                fontWeight: FontWeight.w400,
                fontSize: 14),
          ),
          // type != null
          //     ? Text(
          //         '${type}',
          //         style: TextStyle(
          //           color: Color(0xff007084),
          //           fontSize: 13,
          //           fontWeight: FontWeight.w300,
          //         ),
          //       )
          //     : Container(),
          // SizedBox(
          //   height: 5,
          // ),
        ],
      ),
    );
  }
}

class ExpandableText extends StatefulWidget {
  const ExpandableText(
    this.text, {
    Key key,
    this.trimLines = 2,
    this.colors,
  })  : assert(text != null),
        super(key: key);

  final String text;
  final int trimLines;
  final Color colors;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    final colorClickableText = Colors.blue;
    TextSpan link = TextSpan(
        text: _readMore ? "... read more" : " read less",
        style: TextStyle(
          color: colorClickableText,
        ),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink);
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection
              .rtl, //better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore ? widget.text.substring(0, endIndex) : widget.text,
            style: TextStyle(
              color: widget.colors,
              letterSpacing: 0.6,
              wordSpacing: 0.6,
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}

class Category {
  final int id;
  final String name;
  final String price;
  final String image;
  final int publisher_id;
  final int catagory_id;
  final String catagory_name;
  final String publisher_name;
  final String publisher_date;

  Category(this.id, this.name, this.price, this.publisher_id, this.catagory_id,
      this.image, this.catagory_name, this.publisher_name, this.publisher_date);

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price'],
        publisher_id = json['publisher_id'],
        catagory_id = json["catagory_id"],
        image = json['image'],
        catagory_name = json["catagory_name"],
        publisher_name = json["publisher_name"],
        publisher_date = json["publisher_date"];

  Map<String, dynamic> toJson() => {
        'id': id,
        'price': price,
        'name': name,
        'image': image,
        'publisher_id': publisher_id,
        'catagory_id': catagory_id,
        'catagory_name': catagory_name,
        'publisher_name': publisher_name,
        'publisher_date': publisher_date,
      };
}

// List<Category> categories = categoriesData
//     .map((item) => Category(item['id'], item['name'], item['price'].toString(),
//         item['publisher_id'], 1, item['image']),item['category_id'],item['category_name'],item['publisher_name'])
//     .toList();

// var categoriesData = [
//   {
//     "id": 1,
//     "name": "The Subtle art of not giving f*ck",
//     'price': 17,
//     'publisher_id': 1169,
//     'image': "assets/images/book1.jpg"
//   },
//   {
//     "id": 1,
//     "name": "The Namesake",
//     'price': 25,
//     'publisher_id': 1169,
//     'image': "assets/images/book2.jpg"
//   },
//   {
//     "id": 1,
//     "name": "State of wonder",
//     'price': 13,
//     'publisher_id': 1169,
//     'image': "assets/images/book3.jpg"
//   },
//   {
//     "id": 1,
//     "name": "Inferno",
//     'price': 17,
//     'publisher_id': 1169,
//     'image': "assets/images/book4.jpg"
//   },
// ];
