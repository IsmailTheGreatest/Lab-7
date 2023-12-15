import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lab_7/users_model.dart'; // Import your User model classes here

class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final String url_ = 'https://randomuser.me/api/?results=100';
  Users users = Users(results: []);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color(0xffccd5f0) ,
      appBar: AppBar(
        backgroundColor:const Color(0xffccd5f0) ,
        title:  const Center(
          child: Text('List of Hecked Users',  style: TextStyle(
            fontFamily: 'fontik/fontik1.ttf',
            fontSize: 22.0,
            fontWeight: FontWeight.bold,color: Color(0xff350f9c)
          ),),
        ),
      ),
      body: ListView.builder(
        itemCount: users.results.length,
        itemBuilder: (context, index) {
          final Result user = users.results[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.picture.thumbnail),
            ),
            title: Text('${user.name.first} ${user.name.last}',style: const TextStyle(
              fontFamily: 'fontik/fontik1.ttf',
              fontSize: 18.0,
              fontWeight: FontWeight.w800, color: Color(0xff350f9c)
            ), ),
            subtitle: Text(user.email,style: const TextStyle(
              fontFamily: 'fontik',
              fontWeight: FontWeight.normal,color: Color(0xff350f9c)
            ),),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xaa350f9c),
        onPressed: fetch,
        child: const Icon(Icons.system_update_alt, color: Color.fromRGBO(255, 255, 255, 1),),
      ),
    );
  }

  void fetch() async {
    final response = await http.get(Uri.parse(url_));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> results = jsonData['results'];

      final List<Result> converted = results.map((user) {
        return Result(
          gender: user['gender'],
          name: Name(
            title: user['name']['title'],
            first: user['name']['first'],
            last: user['name']['last'],
          ),
          email: user['email'],
          phone: user['phone'],
          picture: Picture(
            thumbnail: user['picture']['thumbnail'],
          ),
        );
      }).toList();

      setState(() {
        users = Users(results: converted);
      });
    }
  }
}
