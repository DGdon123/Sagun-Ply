// ignore_for_file: unnecessary_new

import 'dart:convert';
import 'package:ecommerce/main.dart';
import 'package:ecommerce/ui_helper.dart';
import 'package:flutter/material.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ecommerce/NetworkHandler.dart';
import 'package:ecommerce/cart.dart';

import 'package:ecommerce/services/bpi.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:ecommerce/models/cartmodel.dart';
import 'package:ecommerce/services/api_services.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'api.dart';

import 'cart_provider.dart';
import 'data_class.dart';
import 'models/ply.dart';
import 'models/profile.dart';
import 'models/profiling.dart';

class FourthScreen extends StatefulWidget {
  const FourthScreen({Key? key}) : super(key: key);

  @override
  State<FourthScreen> createState() => _FourthScreenState();
}

class _FourthScreenState extends State<FourthScreen> {
  final storage = FlutterSecureStorage();
  int _cartCount = 0;
  List<Cart> quantity = [];
  List<Grade> gradelist = [];
  List<Product> templist = [];
  List<Product> productlist = [];
  List<Thickness> thicklist = [];
  List<Thickness> thicknesslist = [];
  List<Price> pricelist = [];
  List<Price> pricinglist = [];
  List<Size> sizelist = [];
  List<Size> sizinglist = [];
  var units = ['Select Unit', 'ft', 'mtr'];
  String uni = 'Select Unit';
  String? grade;
  String? product;
  String? thickness;
  String? price;
  String? size;
  String? unit;
  var user = TextEditingController();
  var grading = TextEditingController();
  var products = TextEditingController();
  var thicknessing = TextEditingController();
  var pricing = TextEditingController();
  var prices = TextEditingController();
  var sizing = TextEditingController();
  var quantitative = TextEditingController();
  var uniting = TextEditingController();
  NetworkHandler networkHandler = NetworkHandler();
  CartModel cartModel = CartModel();
  var sizings, height, width;
  Color originalButtonColor = Color(0xFFD71B23);
  Color? _buttonColor;

  Post profileModel = Post();
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    dating();
    fetchData();
  }

  void dating() async {
    var response = await networkHandler.get("user");
    print(response);
    setState(() {
      profileModel = Post.fromJson(response);
      print(profileModel);
    });
  }

  void _registration() async {
    var data = {
      "user_id": profileModel.id,
      "grade_id": grading.text.trim(),
      "product_id": products.text.trim(),
      "thickness_id": thicknessing.text.trim(),
      "size_id": sizing.text.trim(),
      "quantity": quantitative.text.trim(),
      "unit": uniting.text.trim()
    };
    print(data);
    var res = await Api().postData(data, 'cart/store');
    var body = json.decode(res.body);
    print(body);

    if (body['success']) {
      showDialogBox(true);
      Provider.of<CartModel>(context, listen: false).updateCartCount(
        Provider.of<CartModel>(context, listen: false).cartCount! + 1,
      );
    } else {
      showDialogBox(false);
      Provider.of<CartModel>(context, listen: false).updateCartCount(
        Provider.of<CartModel>(context, listen: false).cartCount! - 1,
      );
    }
  }

  void showDialogBox(bool isSuccessful) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Color(0xFFD71B23),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            title: isSuccessful
                ? Text(
                    "Success",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w600,
                      fontFamily: "Cabin",
                      fontSize: width * 0.058,
                    ),
                  )
                : Text("Unsuccessful"),
            content: isSuccessful
                ? SizedBox(
                    height: UiHelper.displayHeight(context) * 0.122,
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Successfully added to cart!!!",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontWeight: FontWeight.w500,
                            fontFamily: "Cabin",
                            fontSize: width * 0.053,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 17, top: 22),
                          child: Row(
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFFFFFF),
                                ),
                                child: Text("Place Again",
                                    style: TextStyle(
                                      color: Color(0xFFD71B23),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Cabin",
                                      fontSize: width * 0.04,
                                    )),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/fourth');
                                },
                              ),
                              UiHelper.horizontaSpace(hspace: Spacing.xxlarge),
                              ElevatedButton(
                                child: Text("Close",
                                    style: TextStyle(
                                      color: Color(0xFFD71B23),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Cabin",
                                      fontSize: width * 0.04,
                                    )),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFFFFFF),
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/eleventh');
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox(
                    height: 95,
                    child: Column(
                      children: <Widget>[
                        Text("Please fill up all the fields!!!"),
                        Container(
                          margin: const EdgeInsets.only(left: 35, top: 7),
                          child: Row(
                            children: [
                              ElevatedButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
      },
    );
  }

  fetchData() async {
    Ply? dum = await getData();
    setState(() {
      gradelist = dum!.grade;
      productlist = dum.product;
      thicknesslist = dum.thickness;
      pricinglist = dum.price;
      sizinglist = dum.size;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    sizings = MediaQuery.of(context).size;
    height = sizings.height;
    width = sizings.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFD71B23),
        centerTitle: true,
        title: const Text('Home',
            style: TextStyle(
              color: Color(0xFFFFFFFF),
              fontFamily: 'Roboto',
              fontSize: 22,
              fontWeight: FontWeight.w700,
            )),
        iconTheme: const IconThemeData(
          size: 30, //change size on your need
          color: Color(0xFFFFFFFF), //change color on your need
        ),
        elevation: 0,
      ),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width * 0.57,
        backgroundColor: Color(0xFFFFFFFF),
        // ignore: sort_child_properties_last
        child: ListView(
          children: [
            UiHelper.verticalSpace(vspace: Spacing.large),
            ListTile(
                leading: SizedBox(
                  height: 120,
                  child: Container(
                    width: 56,
                    decoration: BoxDecoration(
                      color: Color(0xFFD71B23),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          offset: Offset(0, 8),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ), //BoxShadow
                        //BoxShadow
                      ],
                    ),
                    child: Column(
                      children: [
                        UiHelper.verticalSpace(vspace: Spacing.xsmall),
                        const Icon(
                          Icons.account_circle,
                          color: Color(0xFFFFFFFF),
                          size: 45,
                        ),
                      ],
                    ),
                  ),
                ),
                title: Text(profileModel.name ?? ' ',
                    style: TextStyle(
                        color: Color(0xFFD71B23),
                        fontFamily: "Cabin",
                        fontSize: 22,
                        fontWeight: FontWeight.w600)),
                onTap: (() {
                  Navigator.pushNamed(context, '/eighth');
                })),
            UiHelper.verticalSpace(vspace: Spacing.large),
            const Divider(
              thickness: 1.2, // thickness of the line
              indent: 0, // empty space to the leading edge of divider.
              endIndent: 0, // empty space to the trailing edge of the divider.
              color:
                  Color(0xFFD71B23), // The color to use when painting the line.
              height: 0, // The divider's height extent.
            ),
            ListTile(
                leading: const Icon(
                  Icons.home,
                  color: Color(0xFFD71B23),
                  size: 26,
                ),
                title: const Text('Home',
                    style: TextStyle(
                        color: Color(0xFFD71B23),
                        fontFamily: "Cabin",
                        fontSize: 17,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600)),
                onTap: (() {
                  Navigator.pushNamed(context, '/fourth');
                })),
            ListTile(
                leading: const Icon(
                  Icons.inventory,
                  color: Color(0xFFD71B23),
                  size: 26,
                ),
                title: const Text('Orders',
                    style: TextStyle(
                        color: Color(0xFFD71B23),
                        fontFamily: "Cabin",
                        fontSize: 17,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600)),
                onTap: (() {
                  Navigator.pushNamed(context, '/seventh');
                })),
            const Divider(
              thickness: 1.2, // thickness of the line
              indent: 0, // empty space to the leading edge of divider.
              endIndent: 0, // empty space to the trailing edge of the divider.
              color:
                  Color(0xFFD71B23), // The color to use when painting the line.
              height: 0.001, // The divider's height extent.
            ),
            ListTile(
                leading: const Icon(
                  Icons.shopping_cart_rounded,
                  color: Color(0xFFD71B23),
                  size: 26,
                ),
                title: const Text('Cart',
                    style: TextStyle(
                        color: Color(0xFFD71B23),
                        fontFamily: "Cabin",
                        fontSize: 17,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600)),
                onTap: (() {
                  Navigator.pushNamed(context, '/eleventh');
                })),
            ListTile(
                leading: const Icon(
                  Icons.help_outlined,
                  color: Color(0xFFD71B23),
                  size: 26,
                ),
                title: const Text('Help',
                    style: TextStyle(
                        color: Color(0xFFD71B23),
                        fontFamily: "Cabin",
                        fontSize: 17,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w600)),
                onTap: (() {
                  Navigator.pushNamed(context, '/tenth');
                })),
            const Divider(
              thickness: 1.2, // thickness of the line
              indent: 0, // empty space to the leading edge of divider.
              endIndent: 0, // empty space to the trailing edge of the divider.
              color:
                  Color(0xFFD71B23), // The color to use when painting the line.
              height: 0.001, // The divider's height extent.
            ),
          ],
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                color: Color(0xFFD71B23),
              )
            : Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          height: UiHelper.displayHeight(context) * 0.97,
                          child: Column(
                            children: [
                              UiHelper.verticalSpace(vspace: Spacing.xsmall),
                              Row(
                                children: [
                                  UiHelper.horizontaSpace(
                                      hspace: Spacing.xlarge),
                                  Text(
                                    "Place your Order",
                                    style: TextStyle(
                                      fontFamily: "Catamaran",
                                      color: Color(0xFF222222),
                                      fontSize: width * 0.065,
                                      height: height / 350,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      UiHelper.verticalSpace(
                                          vspace: Spacing.xlarge),
                                      UiHelper.horizontaSpace(
                                          hspace: Spacing.xlarge),
                                      Text(
                                        "Grade",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Mulish",
                                            height: UiHelper.displayHeight(
                                                    context) *
                                                0.0015,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF222222),
                                            fontSize: width * 0.042),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      UiHelper.horizontaSpace(
                                          hspace: Spacing.xlarge),
                                      Container(
                                        height: height / 18,
                                        width: width * 0.9,
                                        margin: const EdgeInsets.only(top: 0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          border: Border.all(
                                              color: const Color(0xFF222222),
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: DropdownButton2(
                                          dropdownMaxHeight: 150,
                                          itemPadding:
                                              const EdgeInsets.only(left: 16),
                                          isExpanded: true,
                                          style: const TextStyle(
                                              height: 1.3,
                                              fontFamily:
                                                  "SignikaNegative-Regular",
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF1B1B1E),
                                              fontSize: 14.7),
                                          underline: Container(
                                              color: Colors.transparent),
                                          hint: const Text("Select Grade"),
                                          value: grade,
                                          onChanged: (newvalue) {
                                            setState(() {
                                              product = null;

                                              grade = newvalue.toString();
                                              templist = productlist
                                                  .where((element) =>
                                                      element.gradeId
                                                          .toString() ==
                                                      grade.toString())
                                                  .toList();
                                            });
                                            grading.text = newvalue.toString();
                                          },
                                          items: gradelist.map((itemone) {
                                            return DropdownMenuItem(
                                                value: itemone.id.toString(),
                                                child: Text(itemone.title));
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      UiHelper.verticalSpace(
                                          vspace: Spacing.xlarge),
                                      UiHelper.horizontaSpace(
                                          hspace: Spacing.xlarge),
                                      Text(
                                        "Product",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Mulish",
                                            height: UiHelper.displayHeight(
                                                    context) *
                                                0.0015,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF222222),
                                            fontSize: width * 0.042),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      UiHelper.horizontaSpace(
                                          hspace: Spacing.xlarge),
                                      Container(
                                        height: height / 18,
                                        width: width * 0.9,
                                        margin: const EdgeInsets.only(top: 0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          border: Border.all(
                                              color: const Color(0xFF222222),
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: DropdownButton2(
                                          dropdownMaxHeight: 150,
                                          itemPadding:
                                              const EdgeInsets.only(left: 16),
                                          isExpanded: true,
                                          style: const TextStyle(
                                              height: 1.3,
                                              fontFamily:
                                                  "SignikaNegative-Regular",
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF1B1B1E),
                                              fontSize: 14.7),
                                          underline: Container(
                                              color: Colors.transparent),
                                          hint: const Text("Select Product"),
                                          value: product,
                                          onChanged: (newvalue) {
                                            setState(() {
                                              thickness = null;
                                              product = newvalue.toString();
                                              thicklist = thicknesslist
                                                  .where((element) =>
                                                      element.productId
                                                              .toString() ==
                                                          product.toString() &&
                                                      element.gradeId
                                                              .toString() ==
                                                          grade.toString())
                                                  .toList();
                                            });
                                            products.text = newvalue.toString();
                                          },
                                          items: templist.map((itemone) {
                                            return DropdownMenuItem(
                                                value: itemone.id.toString(),
                                                child: Text(itemone.title));
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      UiHelper.verticalSpace(
                                          vspace: Spacing.xlarge),
                                      UiHelper.horizontaSpace(
                                          hspace: Spacing.xlarge),
                                      Text(
                                        "Thickness",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Mulish",
                                            height: UiHelper.displayHeight(
                                                    context) *
                                                0.0015,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF222222),
                                            fontSize: width * 0.042),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      UiHelper.horizontaSpace(
                                          hspace: Spacing.xlarge),
                                      Container(
                                        height: height / 18,
                                        width: width * 0.9,
                                        margin: const EdgeInsets.only(top: 0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          border: Border.all(
                                              color: const Color(0xFF222222),
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: DropdownButton2(
                                          dropdownMaxHeight: 150,
                                          itemPadding:
                                              const EdgeInsets.only(left: 16),
                                          isExpanded: true,
                                          style: const TextStyle(
                                              height: 1.3,
                                              fontFamily:
                                                  "SignikaNegative-Regular",
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF1B1B1E),
                                              fontSize: 14.7),
                                          underline: Container(
                                              color: Colors.transparent),
                                          hint: const Text("Select Thickness"),
                                          value: thickness,
                                          onChanged: (newvalue) {
                                            setState(() {
                                              thickness = newvalue.toString();
                                            });
                                            thicknessing.text =
                                                newvalue.toString();
                                          },
                                          items: thicklist.map((itemone) {
                                            return DropdownMenuItem(
                                                value: itemone.id.toString(),
                                                child: Text(itemone.title));
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      UiHelper.verticalSpace(
                                          vspace: Spacing.xlarge),
                                      UiHelper.horizontaSpace(
                                          hspace: Spacing.xlarge),
                                      Text(
                                        "Size",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Mulish",
                                            height: UiHelper.displayHeight(
                                                    context) *
                                                0.0015,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF222222),
                                            fontSize: width * 0.042),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      UiHelper.horizontaSpace(
                                          hspace: Spacing.xlarge),
                                      Container(
                                        height: height / 18,
                                        width: width * 0.9,
                                        margin: const EdgeInsets.only(top: 0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          border: Border.all(
                                              color: const Color(0xFF222222),
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: DropdownButton2(
                                          dropdownMaxHeight: 150,
                                          itemPadding:
                                              const EdgeInsets.only(left: 16),
                                          isExpanded: true,
                                          style: const TextStyle(
                                              height: 1.3,
                                              fontFamily:
                                                  "SignikaNegative-Regular",
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF1B1B1E),
                                              fontSize: 14.7),
                                          underline: Container(
                                              color: Colors.transparent),
                                          hint: const Text("Select Size"),
                                          value: size,
                                          onChanged: (newvalue) {
                                            setState(() {
                                              size = newvalue.toString();
                                            });
                                            sizing.text = newvalue.toString();
                                          },
                                          items: sizinglist.map((itemone) {
                                            return DropdownMenuItem(
                                                value: itemone.id.toString(),
                                                child: Text(itemone.title));
                                          }).toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Row(
                                    children: [
                                      UiHelper.verticalSpace(
                                          vspace: Spacing.xlarge),
                                      UiHelper.horizontaSpace(
                                          hspace: Spacing.xlarge),
                                      Text(
                                        "Unit",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: "Mulish",
                                            height: UiHelper.displayHeight(
                                                    context) *
                                                0.0015,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF222222),
                                            fontSize: width * 0.042),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      UiHelper.horizontaSpace(
                                          hspace: Spacing.xlarge),
                                      Container(
                                        height: height / 18,
                                        width: width * 0.9,
                                        margin: const EdgeInsets.only(top: 0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          border: Border.all(
                                              color: const Color(0xFF222222),
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: DropdownButton2(
                                          dropdownMaxHeight: 150,
                                          itemPadding:
                                              const EdgeInsets.only(left: 16),
                                          isExpanded: true,
                                          style: const TextStyle(
                                              height: 1.3,
                                              fontFamily:
                                                  "SignikaNegative-Regular",
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xFF1B1B1E),
                                              fontSize: 14.7),
                                          underline: Container(
                                              color: Colors.transparent),
                                          value: uni,
                                          items: units.map((String itemone) {
                                            return DropdownMenuItem(
                                                value: itemone,
                                                child: Text(itemone));
                                          }).toList(),
                                          onChanged: (String? newvalue) {
                                            setState(() {
                                              price = null;
                                              uni = newvalue!;
                                              pricelist = pricinglist
                                                  .where((element) =>
                                                      element.productId
                                                              .toString() ==
                                                          product.toString() &&
                                                      element.gradeId
                                                              .toString() ==
                                                          grade.toString() &&
                                                      element.thicknessId
                                                              .toString() ==
                                                          thickness.toString())
                                                  .toList();
                                            });
                                            uniting.text = newvalue.toString();
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 2.2, // thickness of the line
                                    indent:
                                        0, // empty space to the leading edge of divider.
                                    endIndent:
                                        0, // empty space to the trailing edge of the divider.
                                    color: Color.fromARGB(255, 186, 186,
                                        189), // The color to use when painting the line.
                                    height:
                                        30.5, // The divider's height extent.
                                  ),
                                  Row(
                                    children: [
                                      UiHelper.horizontaSpace(
                                          hspace: Spacing.xlarge),
                                      Text(
                                        "Price:",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            height: height * 0.00096,
                                            fontFamily: "Mulish",
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF222222),
                                            fontSize: width * 0.042),
                                      ),
                                      UiHelper.horizontaSpace(
                                          hspace: Spacing.xsmall),
                                      for (var item in pricelist)
                                        Container(
                                          width: width * 0.64,
                                          height: height * 0.033,
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                            style: TextStyle(
                                                fontFamily:
                                                    "SignikaNegative-Bold",
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: width * 0.044),
                                            controller: pricing
                                              ..text = uni == "ft"
                                                  ? "Rs. ${item.ftPrice} per/${uni}²"
                                                  : "Rs. ${item.mtrPrice} per/${uni}²",
                                            enabled: false,
                                          ),
                                        ),
                                      for (var item in pricelist)
                                        Container(
                                          width: 1,
                                          height: 20,
                                          margin:
                                              const EdgeInsets.only(left: 5),
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          child: TextFormField(
                                            decoration: const InputDecoration(
                                                border: InputBorder.none),
                                            style: const TextStyle(
                                                height: 0.64,
                                                fontFamily:
                                                    "SignikaNegative-Bold",
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromARGB(
                                                    255, 0, 0, 0),
                                                fontSize: 17.5),
                                            enabled: false,
                                            controller: prices
                                              ..text = "${item.id}",
                                          ),
                                        ),
                                    ],
                                  ),
                                  const Divider(
                                    thickness: 2.2, // thickness of the line
                                    indent:
                                        0, // empty space to the leading edge of divider.
                                    endIndent:
                                        0, // empty space to the trailing edge of the divider.
                                    color: Color.fromARGB(255, 186, 186,
                                        189), // The color to use when painting the line.
                                    height:
                                        24.5, // The divider's height extent.
                                  ),
                                  UiHelper.verticalSpace(
                                      vspace: Spacing.xxsmall),
                                  Row(children: [
                                    UiHelper.horizontaSpace(
                                        hspace: Spacing.xlarge),
                                    Text(
                                      "Quantity",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontFamily: "Mulish",
                                          height:
                                              UiHelper.displayHeight(context) *
                                                  0.0015,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF222222),
                                          fontSize: width * 0.042),
                                    ),
                                  ]),
                                  UiHelper.verticalSpace(vspace: Spacing.small),
                                  Row(
                                    children: [
                                      UiHelper.horizontaSpace(
                                          hspace: Spacing.xlarge),
                                      Container(
                                        height: height / 18,
                                        width: width * 0.9,
                                        margin: const EdgeInsets.only(top: 0),
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 255, 255, 255),
                                          border: Border.all(
                                              color: const Color(0xFF222222),
                                              width: 1,
                                              style: BorderStyle.solid),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4.0)),
                                        ),
                                        child: TextField(
                                          controller: quantitative,
                                          maxLines: 1,
                                          cursorColor: Colors.black,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            hintText:
                                                'Enter quantity of your plywood',
                                            hintStyle: TextStyle(
                                                height: 2,
                                                fontFamily:
                                                    "SignikaNegative-Regular",
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF1B1B1E),
                                                fontSize: 14.7),
                                            contentPadding: EdgeInsets.all(8),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color.fromARGB(
                                                      255, 255, 255, 255)),
                                            ),
                                          ),
                                          style: const TextStyle(
                                              decoration: TextDecoration.none,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              UiHelper.verticalSpace(vspace: Spacing.medium),
                              Container(
                                child: Column(
                                  children: [
                                    Container(
                                      height: height * 0.065,
                                      width: width * 0.88,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color(
                                              0xFFD71B23), //background color of button
                                          //border width and color

                                          shape: RoundedRectangleBorder(
                                              //to set border radius to button
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                        ),
                                        child: Text(
                                          "Add to cart",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            height: height * 0.001,
                                            fontFamily: "ZenKakuGothicAntique",
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: width * 0.055,
                                          ),
                                        ),
                                        onPressed: () {
                                          if (grading.text.isEmpty &&
                                              products.text.isEmpty &&
                                              thicknessing.text.isEmpty &&
                                              sizing.text.isEmpty &&
                                              uniting.text.isEmpty &&
                                              pricing.text.isEmpty &&
                                              quantitative.text.isEmpty) {
                                            showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                      backgroundColor:
                                                          Color(0xFFD71B23),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      title: Text(
                                                          "Please fill up all the fields!!!",
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xFFFFFFFF),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontFamily:
                                                                "Nunito",
                                                            fontSize:
                                                                width * 0.050,
                                                          )),
                                                      actions: <Widget>[
                                                        Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .only(
                                                            bottom: 11,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              ElevatedButton(
                                                                style: ElevatedButton
                                                                    .styleFrom(
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xFFFFFFFF),
                                                                ),
                                                                child: Text(
                                                                    "Okay",
                                                                    style:
                                                                        TextStyle(
                                                                      color: Color(
                                                                          0xFFD71B23),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontFamily:
                                                                          "Cabin",
                                                                      fontSize:
                                                                          width *
                                                                              0.045,
                                                                    )),
                                                                onPressed: () {
                                                                  // Perform logout here
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ]);
                                                });
                                          } else {
                                            _registration();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 250, 247, 247),
        iconSize: 28,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFFD71B23),
        unselectedItemColor: Color(0xFF222222),
        selectedFontSize: 12,
        onTap: (value) {
          if (value == 0) Navigator.pushNamed(context, '/fourth');
          if (value == 1) Navigator.pushNamed(context, '/seventh');
          if (value == 2) Navigator.pushNamed(context, '/eleventh');
          if (value == 3) Navigator.pushNamed(context, '/eighth');
          if (value == 4) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      backgroundColor: Color(0xFFD71B23),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      title: Text("Are you sure you want to logout?"),
                      titleTextStyle: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontWeight: FontWeight.w700,
                        fontFamily: "Nunito",
                        fontSize: UiHelper.displayWidth(context) * 0.045,
                      ),
                      actions: <Widget>[
                        Container(
                          margin: const EdgeInsets.only(bottom: 11),
                          child: Row(
                            children: [
                              UiHelper.horizontaSpace(hspace: Spacing.xlarge),
                              UiHelper.horizontaSpace(hspace: Spacing.xlarge),
                              UiHelper.horizontaSpace(hspace: Spacing.large),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFFFFFF),
                                ),
                                child: Text("Yes",
                                    style: TextStyle(
                                      color: Color(0xFFD71B23),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Cabin",
                                      fontSize: UiHelper.displayWidth(context) *
                                          0.045,
                                    )),
                                onPressed: () {
                                  // Perform logout here
                                  Navigator.pushNamed(context, '/third');
                                },
                              ),
                              UiHelper.horizontaSpace(hspace: Spacing.xxlarge),
                              UiHelper.horizontaSpace(hspace: Spacing.xlarge),
                              UiHelper.horizontaSpace(hspace: Spacing.large),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFFFFFF),
                                ),
                                child: Text("No",
                                    style: TextStyle(
                                      color: Color(0xFFD71B23),
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Cabin",
                                      fontSize: UiHelper.displayWidth(context) *
                                          0.045,
                                    )),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          ),
                        )
                      ]);
                });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: "Orders",
          ),
          BottomNavigationBarItem(
              icon: Container(
                margin: const EdgeInsets.only(top: 18),
              ), // empty container to align cart button in the center
              label: ""),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout_outlined),
            label: "Logout",
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/eleventh');
            },
            child: Stack(
              children: <Widget>[
                Icon(
                  Icons.shopping_cart,
                  size: 25,
                ),
              ],
            ),
            backgroundColor: Color(0xFFD71B23), // set the background color
          ),
        ),
      ),
      // position the cart button in the center of the bottom navigation bar
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
