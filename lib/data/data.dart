import 'package:easy_shelf/models/book_model.dart';
import 'package:easy_shelf/models/single_book_model.dart';
import 'package:flutter/material.dart';

List<BookModel> getBooks(){

  List<BookModel> books = new List<BookModel>();
  BookModel bookModel  = new BookModel();

  //1
  bookModel.imgAssetPath = "assets/mermaid.png";
  bookModel.title = "The little mermaid";
  bookModel.description = '''“The Little Mermaid” is a
fairy tale written by the Danish author Hans
Christian Andersen.''';
  bookModel.rating = 5;
  bookModel.categorie = "Fairy Tailes";

  books.add(bookModel);
  bookModel = new BookModel();

  //1
  bookModel.imgAssetPath = "assets/blabla.png";
  bookModel.title = "Willows Of Fate";
  bookModel.description = '''Is there room in the hands of fate for free will?All her life, Desdemona has seen things others haven’t.''';
  bookModel.rating = 4;
  bookModel.categorie = "Drama";

  books.add(bookModel);
  bookModel = new BookModel();

  return books;
}

List<SingleBookModel> getSingleBooks(){

  List<SingleBookModel> books = new List<SingleBookModel>();
  SingleBookModel singleBookModel = new SingleBookModel();

  //1
  singleBookModel.imgAssetPath = "assets/six_crows.png";
  singleBookModel.title = "Siz of crows";
  singleBookModel.type = "Classic";
  books.add(singleBookModel);

  singleBookModel = new SingleBookModel();


  //2
  singleBookModel.imgAssetPath = "assets/time_of_witches.png";
  singleBookModel.title = "Tim of Witched";
  singleBookModel.type = "Anthology";
  books.add(singleBookModel);

  singleBookModel = new SingleBookModel();


  //3
  singleBookModel.imgAssetPath = "assets/infinite_future.png";
  singleBookModel.title = "Infinite futures";
  singleBookModel.type = "Mystery";
  books.add(singleBookModel);

  singleBookModel = new SingleBookModel();


  //4
  singleBookModel.imgAssetPath = "assets/junot_diaz.png";
  singleBookModel.title = "Sun the moon";
  singleBookModel.type = "Romance";
  books.add(singleBookModel);

  singleBookModel = new SingleBookModel();


  //1
  singleBookModel.imgAssetPath = "assets/dancing_with_the_tiger.png";
  singleBookModel.title = "Dancing with Tiger";
  singleBookModel.type = "Comic";
  books.add(singleBookModel);

  singleBookModel = new SingleBookModel();

  return books;

}

// Colors
const kTextColor = Color(0xFF0D1333);
const kBlueColor = Color(0xFF6E8AFA);
const kBestSellerColor = Color(0xFFFFD073);
const kGreenColor = Color(0xFF49CC96);


// My Text Styles
const kHeadingextStyle = TextStyle(
  fontSize: 28,
  color: kTextColor,
  fontWeight: FontWeight.bold,
);
const kSubheadingextStyle = TextStyle(
  fontSize: 24,
  color: Color(0xFF61688B),
  height: 2,
);

const kTitleTextStyle = TextStyle(
  fontSize: 20,
  color: kTextColor,
  fontWeight: FontWeight.bold,
);

const kSubtitleTextSyule = TextStyle(
  fontSize: 18,
  color: kTextColor,
  // fontWeight: FontWeight.bold,
);