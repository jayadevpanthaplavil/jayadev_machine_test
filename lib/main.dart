import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import 'Data.dart';
import 'JsonToDart.dart';

class UserProvider with ChangeNotifier{
  final ApiService _apiService = ApiService();
  List<Data> _users = [];
  int _currentPage = 1;

  List<Data> get users => _users;

  Future<void> getUsers() async {
    final List<Data> newUsers = await _apiService.getUsers(_currentPage, 6);
    _users.addAll(newUsers);
    _currentPage++;
    notifyListeners();
  }
}



void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
        create: (context) => UserProvider(),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    Provider.of<UserProvider>(context, listen: false).getUsers();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      Provider.of<UserProvider>(context, listen: false).getUsers();
    }
  }




  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return NotificationListener(
      onNotification: (notificationInfo) {
        if (notificationInfo is ScrollStartNotification) {
          print("scroll");
          print("detail:"+notificationInfo.dragDetails.toString());
          /// your code
        }
        return true;
      },

      child: Scaffold(
          appBar: AppBar(
            title: Text("Machine Test - API"),
          ),
          // body: _usersData.isEmpty
          //     ? Center(child: CircularProgressIndicator())
          //     : ListView.builder(
          //   itemCount: _usersData.length,
          //   itemBuilder: (context, index) {
          //     final data = _usersData[index];
          //     return ListTile(
          //       leading: CircleAvatar(
          //         backgroundImage: NetworkImage(data.avatar as String),
          //       ),
          //       title: Text('${data.firstName} ${data.lastName}'),
          //
          //     );
          //   },
          // ),
        body: ListView.builder(
          controller:_scrollController,
          itemCount: userProvider.users.length,
          itemBuilder: (context, index) {

            final user = userProvider.users[index];
            return ListTile(
              title: Text('${user.firstName} ${user.lastName}'),

              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.avatar as String),
              ),
            );
          },

        ),
      ),
    );
  }
}


class ApiService{

  Future<List<Data>> getUsers(int page, int perPage) async {
    final response = await http.get(
        Uri.parse("https://reqres.in/api/users?page=$page&$perPage"));

    if (response.statusCode == 200) {

      JsonToDart _map = JsonToDart.fromJson(json.decode(response.body));

      return _map.data ?? [];
      // final Map<String, dynamic> data = json.decode(response.body);
      // final List<dynamic> usersData = data['data'];
      //
      // return usersData.map((data) => Data.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
