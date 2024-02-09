import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen());
  }
}

UserDetails? details;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    delayed();
  }

  delayed() async {
    await Future.delayed(const Duration(seconds: 1));
    customshowDialogue();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 100;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: details == null
              ? const CircularProgressIndicator()
              : Card(
                  color: Colors.yellow,
                  child: SizedBox(
                    height: width * 80,
                    width: width * 80,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            details!.id!.toString(),
                          ),
                          Text(details!.token!)
                        ]),
                  )),
        ),
      ),
    );
  }

  customshowDialogue() {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        content: const Text("data fetching"),
        actions: [
          ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                details = await fetchData();
                setState(() {});
              },
              child: const Text("Fetch"))
        ],
      ),
    );
  }
}

Future<UserDetails?> fetchData() async {
  Map<String, dynamic> querry = {
    "email": "eve.holt@reqres.in",
    "password": "pistol"
  };
  try {
    Response response =
        await Dio().post("https://reqres.in/api/register", data: querry);

    if (response.statusCode == 200) {
      return UserDetails.fromJson(response.data);
    } else {
      return null;
    }
  } catch (e) {
    throw Exception(e);
  }
}

class UserDetails {
  String? token;
  int? id;

  UserDetails({required this.token, required this.id});

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(id: json["id"], token: json["token"]);
  }
}
