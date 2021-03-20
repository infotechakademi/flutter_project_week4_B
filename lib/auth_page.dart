import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyAuthPage extends StatefulWidget {
  @override
  _MyAuthPageState createState() => _MyAuthPageState();
}

class _MyAuthPageState extends State<MyAuthPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _loginEmailController;
  TextEditingController _loginPassController;
  TextEditingController _registerEmailController;
  TextEditingController _registerPass1Controller;
  TextEditingController _registerPass2Controller;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  bool isLogined;
  bool isLoginFormActive = true;

  Future<void> _login() async {
    try {
      var userLoginResult = await auth.signInWithEmailAndPassword(
        email: _loginEmailController.text,
        password: _loginPassController.text,
      );
    } catch (e) {
      print("login error: $e");
    }
  }

  Future<void> _register() async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: _registerEmailController.text,
        password: _registerPass1Controller.text,
      );
      setState(() {
        isLoginFormActive = true;
      });
    } catch (e) {
      print("register error: $e");
    }
  }

  Future<void> _signOut() async {
    await auth.signOut();
  }

  Future<void> _forgetPass() async {
    try {
      await auth.sendPasswordResetEmail(email: _loginEmailController.text);
    } catch (e) {
      print("reset error: $e");
    }
  }

  @override
  void initState() {
    // assigning controllers inital value
    _loginEmailController = TextEditingController(text: "test.user@fake.com");
    _loginPassController = TextEditingController(text: "abc123");
    _registerEmailController =
        TextEditingController(text: "test.user1@fake.com");
    _registerPass1Controller = TextEditingController(text: "abc123");
    _registerPass2Controller = TextEditingController(text: "abc123");
    // auth listener
    FirebaseAuth.instance.authStateChanges().listen((User user) {
      if (user == null) {
        print('User is currently signed out!');
        setState(() {
          isLogined = false;
        });
      } else {
        print('User is signed in!');
        setState(() {
          isLogined = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _loginEmailController?.dispose();
    _loginPassController?.dispose();
    _registerEmailController?.dispose();
    _registerPass1Controller?.dispose();
    _registerPass2Controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade300,
      resizeToAvoidBottomInset: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          (isLogined == null)
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : Card(
                  color: Colors.lightBlue.shade100,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (isLogined)
                        ? homeContent()
                        : isLoginFormActive
                            ? loginForm()
                            : registerForm(),
                  ),
                ),
        ],
      ),
    );
  }

  Widget homeContent() {
    return Center(
        child: Column(
      children: [
        Text("Hoş geldin"),
        SizedBox(
          height: 35,
        ),
        TextButton(
            onPressed: () {
              _signOut();
            },
            child: Text("Çıkış")),
      ],
    ));
  }

  registerForm() {
    return Form(
      key: registerFormKey,
      child: Column(
        children: [
          const Text(
            "Üye Kayıt",
            textAlign: TextAlign.center,
          ),
          Divider(),
          SizedBox(
            height: 30,
          ),
          Text("Üye E-Posta"),
          SizedBox(height: 10),
          TextFormField(
            controller: _registerEmailController,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          SizedBox(height: 20),
          Text("Üye Şifre"),
          SizedBox(height: 10),
          TextFormField(
            controller: _registerPass1Controller,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          SizedBox(height: 10),
          Text("Üye Şifre (Tekrar)"),
          SizedBox(height: 10),
          TextFormField(
            controller: _registerPass2Controller,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_registerPass1Controller.text ==
                  _registerPass2Controller.text) {
                _register();
              }
            },
            child: Text("Kayıt"),
          ),
        ],
      ),
    );
  }

  loginForm() {
    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          const Text(
            "Üye Girişi",
            textAlign: TextAlign.center,
          ),
          Divider(),
          SizedBox(
            height: 30,
          ),
          Text("Üye E-Posta"),
          SizedBox(height: 10),
          TextFormField(
            controller: _loginEmailController,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          SizedBox(height: 20),
          Text("Üye Şifre"),
          SizedBox(height: 10),
          TextFormField(
            validator: (String currentValue) {
              if (currentValue.length < 6) {
                return "Geçersiz şifre";
              }
              return null;
            },
            controller: _loginPassController,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: 60,
            child: ButtonBar(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _forgetPass();
                  },
                  child: Text("Şifremi Unutum"),
                ),
                VerticalDivider(
                  color: Colors.blue,
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoginFormActive = false;
                    });
                  },
                  child: Text("Kayıt Ol"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (loginFormKey.currentState.validate()) {
                      _login();
                    }
                  },
                  child: Text("Giriş"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
