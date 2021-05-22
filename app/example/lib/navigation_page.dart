import 'package:example/rooms.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'chat.dart';
import 'login.dart';
import 'users.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  bool _error = false;
  bool _initialized = false;
  User? _user;
  int? _selectedIndexBottomNavigationBar;
  Widget? _currentPage;

  @override
  void initState() {
    initializeFlutterFire();
    _selectedIndexBottomNavigationBar = 0;
    _currentPage = RoomsPage();

    super.initState();
  }

  void initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        setState(() {
          _user = user;
        });
      });
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {
        _error = true;
      });
    }
  }

  void _messagesState() {
    setState(() {
      _selectedIndexBottomNavigationBar = 0;
      _currentPage = const RoomsPage();
    });
  }

  void _addState() {
    setState(() {
      _selectedIndexBottomNavigationBar = 1;
      _currentPage = const UsersPage();
    });
  }

  void _accountState() {
    setState(() {
      _selectedIndexBottomNavigationBar = 2;
      _currentPage = Container();
    });
  }

  Widget _bottomNavigationBar() {
    return BottomNavigationBar(
      //type: BottomNavigationBarType.values,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: Icon(Icons.email_outlined),
          label: 'Messages',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.add_rounded),
          label: 'Create',
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.account_box_rounded),
          label: 'Account',
        ),
      ],
      unselectedItemColor: Colors.black45,
      currentIndex: _selectedIndexBottomNavigationBar!,
      onTap: _onItemTappedBottomNavigationBar,
    );
  }

  void _onItemTappedBottomNavigationBar(int index) {
    if (index == _selectedIndexBottomNavigationBar) return;
    _selectedIndexBottomNavigationBar = index;
    switch (index) {
      case 0:
        _messagesState();
        break;
      case 1:
        _addState();
        break;
      case 2:
        _accountState();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.dark,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            color: Theme.of(context).backgroundColor,
            onPressed: _user == null ? null : logout,
          ),
        ],
        title: const Text('Space'),
        centerTitle: true,
      ),
      body: _currentPage,
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
