import 'package:autologin/controller/auth_controller.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> _itemList = [
    {
      "food_image":
          "https://cdn.britannica.com/08/177308-050-94D9D6BE/Food-Pizza-Basil-Tomato.jpg",
      "food_title": " Pizza"
    },
    {
      "food_image":
          "https://content3.jdmagicbox.com/comp/def_content/burger-joints/2-burger-joints-2-bh9g9.jpg",
      "food_title": "Burger"
    },
    {
      "food_image":
          "https://uploads-ssl.webflow.com/5c481361c604e53624138c2f/5c579defb111ce565802f348_egg-roll-website_-thumbnail-_h4tzx1.png",
      "food_title": "Egg roll"
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text("Home Screen"),
        actions: [IconButton(onPressed: () {
          AuthController.logOut();
        }, icon: Icon(Icons.logout))],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return Card(
            elevation: 10,
            child: Container(
              height: 230,
              child: Column(
                children: [
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5),
                      ),
                      child: Image.network(
                        '${_itemList[index]['food_image']}',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    '${_itemList[index]['food_title']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          );
        },
        itemCount: _itemList.length,
      ),
    );
  }
}
