import 'package:flutter/material.dart';

//COLORS
const Color profile_info_background = Color.fromRGBO(44, 149, 121, 1.0);
const Color profile_info_categories_background = Color(0xFFF6F5F8);
const Color profile_info_address = Color(0xFF8D7AEE);
const Color profile_info_privacy = Color(0xFFF369B7);
const Color profile_info_general = Color(0xFFFFC85B);
const Color profile_info_notification = Color(0xFF5DD1D3);
const Color profile_item_color = Color(0xFFC4C5C9);
const String imagePath = 'assets/image';

const String devMausam = 'https://app.hellotegena.com/assets/images/user.png';

List<ProfileMenu> lampList = [
  ProfileMenu(title: 'Landscape', subTitle: '384'),
  ProfileMenu(title: 'Discus Pendant', subTitle: '274'),
  ProfileMenu(title: 'Mushroom Lamp', subTitle: '374'),
  ProfileMenu(title: 'Titanic Pendant', subTitle: '562'),
  ProfileMenu(title: 'Torn Lighting', subTitle: '105'),
  ProfileMenu(title: 'Abduction Pendant', subTitle: '365'),
];
const List profileItems = [
  {'count': '846', 'name': 'Collect'},
  {'count': '51', 'name': 'Attention'},
  {'count': '267', 'name': 'Track'},
  {'count': '39', 'name': 'Coupons'},
];

List<Catg> listProfileCategories = [
  Catg(name: 'Transactions', icon: Icons.traffic_outlined, number: 0),
  Catg(name: 'Addresses', icon: Icons.location_on, number: 0),
  Catg(name: 'Pending Balance', icon: Icons.pending, number: 0),
  Catg(name: 'Log Out', icon: Icons.arrow_back, number: 0),
];

List<FurnitureCatg> furnitureCategoriesList = [
  FurnitureCatg(icon: Icons.desktop_windows, elivation: true),
  FurnitureCatg(icon: Icons.account_balance_wallet, elivation: false),
  FurnitureCatg(icon: Icons.security, elivation: false),
  FurnitureCatg(icon: Icons.chat, elivation: false),
  FurnitureCatg(icon: Icons.attach_money, elivation: false),
];

List<ProfileMenu> homeMenuList = [
  ProfileMenu(
    title: 'Send',
    subTitle: 'Send money easy',
    iconColor: profile_info_background,
    icon: Icons.send,
  ),
  ProfileMenu(
    title: 'Qr Barcode',
    subTitle: 'Show your QR barcode',
    iconColor: profile_info_background,
    icon: Icons.camera,
  ),
  ProfileMenu(
    title: 'Top-up',
    subTitle: 'Add balance to your account',
    iconColor: profile_info_background,
    icon: Icons.add_comment,
  ),
  ProfileMenu(
    title: 'Withdraw',
    subTitle: 'withdraw from account',
    iconColor: profile_info_background,
    icon: Icons.subdirectory_arrow_left,
  ),
];

List<ProfileMenu> profileMenuList = [
  ProfileMenu(
    title: 'General',
    subTitle: 'Basic functional settings',
    iconColor: profile_info_background,
    icon: Icons.layers,
  ),
  ProfileMenu(
    title: 'Account Settings',
    subTitle: 'Link Your Accounts',
    iconColor: profile_info_background,
    icon: Icons.account_balance_wallet,
  ),
  ProfileMenu(
    title: 'Security',
    subTitle: 'Change Password',
    iconColor: profile_info_background,
    icon: Icons.security,
  ),
  ProfileMenu(
    title: 'Address',
    subTitle: 'Ensure your harvesting address',
    iconColor: profile_info_background,
    icon: Icons.location_on,
  ),
  ProfileMenu(
    title: 'Notification',
    subTitle: 'Take over the news in time',
    iconColor: profile_info_background,
    icon: Icons.notifications,
  ),
];

class ProfileMenu {
  String title;
  String subTitle;
  IconData icon;
  Color iconColor;
  ProfileMenu({this.icon, this.title, this.iconColor, this.subTitle});
}

class Catg {
  String name;
  IconData icon;
  int number;
  Catg({this.icon, this.name, this.number});
}

class FurnitureCatg {
  IconData icon;
  bool elivation;
  FurnitureCatg({this.icon, this.elivation});
}