import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:my_app/entities/EditData.dart';
import 'package:my_app/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/entities/user.dart';
import 'dart:async';
import 'package:my_app/routes/custom_route.dart';
import 'home_page.dart';
import 'package:my_app/entities/globals.dart' as globals;

import 'login_page.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    const appTitle = 'Perfil de Usuario';

    return MaterialApp(
      title: appTitle,
      home: Scaffold(
        drawer: _getDrawer(context),
        appBar: AppBar(
          title: const Text(appTitle),
        ),
        body: const UserProfileForm(),
      ),
    );
  }
}

class UserProfileForm extends StatefulWidget {
  const UserProfileForm({super.key});

  @override
  UserProfileFormState createState() {
    return UserProfileFormState();
  }
}

class UserProfileFormState extends State<UserProfileForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  String _password = "";

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    TextEditingController name =
        TextEditingController(text: globals.userLoggedIn.name);
    TextEditingController password =
        TextEditingController(text: globals.userLoggedIn.password);
    TextEditingController username =
        TextEditingController(text: globals.userLoggedIn.username);
    TextEditingController phone =
        TextEditingController(text: globals.userLoggedIn.phone);
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Add TextFormFields and ElevatedButton here.
            TextFormField(
              // The validator receives the text that the user has entered.
              controller: name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduzca texto';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Nombre',
                icon: Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Icon(Icons.account_circle),
                ),
              ),
            ),

            // TextFormField(
            //   // The validator receives the text that the user has entered.
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Introduzca texto';
            //     }
            //     return null;
            //   },
            //   decoration: const InputDecoration(
            //     border: UnderlineInputBorder(),
            //     labelText: 'Apellidos',
            //     icon: Padding(
            //       padding: EdgeInsets.only(top: 15.0),
            //       child: Icon(Icons.account_circle),
            //     ),
            //   ),
            // ),
            TextFormField(
              // The validator receives the text that the user has entered.
              controller: password,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduzca texto';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Contraseña',
                icon: Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Icon(Icons.lock),
                ),
              ),
              onSaved: (value) => _password = value!,
              obscureText: _obscureText,
            ),
            TextButton(
                onPressed: _toggle,
                child: Text(_obscureText ? "Mostrar" : "Ocultar")),
            TextFormField(
              // The validator receives the text that the user has entered.
              controller: username,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduzca texto';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Nombre de usuario',
                icon: Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Icon(Icons.abc),
                ),
              ),
            ),
            IntlPhoneField(
              controller: phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                border: UnderlineInputBorder(
                  borderSide: BorderSide(),
                ),
                icon: Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Icon(Icons.phone),
                ),
              ),
              initialCountryCode: 'ES',
            ),
            TextFormField(
              // The validator receives the text that the user has entered.
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Introduzca texto';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Foto de perfil',
                icon: Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Icon(Icons.photo_camera),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        duration: Duration(seconds: 3),
                        content: Text('Procesando datos...')),
                  );
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  editUser(name.text, password.text, username.text, phone.text)
                      .then((_) {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    setState(() {});
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Color(0xFF4CAF50),
                          duration: Duration(seconds: 3),
                          content: Text('Usuario editado con éxito')),
                    );
                    Navigator.of(context).pushReplacement(
                      FadePageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  });
                }
              },
              child: const Text('Enviar'),
            ),
            ElevatedButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('¿Está seguro?'),
                  content: const Text('Esta accion es irreservible'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancelar'),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () {
                        beforeDeleteUser(context);
                        setState(() {});
                      },
                      child: const Text('Confirmar'),
                    ),
                  ],
                ),
              ),
              child: const Text('Eliminar usuario'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _getDrawer(BuildContext context) {
  var accountEmail = Text(globals.userLoggedIn.email);
  var accountName = Text(globals.userLoggedIn.username);
  var accountPicture = Icon(FontAwesomeIcons.userLarge);
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
            accountName: accountName,
            accountEmail: accountEmail,
            currentAccountPicture: accountPicture),
        ListTile(
            title: const Text("Inicio"),
            leading: const Icon(Icons.home),
            onTap: () => showHome(context)),
        ListTile(
            title: const Text("Jugar Partido"),
            leading: const Icon(Icons.play_arrow),
            onTap: () => playGame(context)),
        ListTile(
            title: const Text("Logros"),
            leading: const Icon(Icons.auto_stories_sharp),
            onTap: () => achievement(context)),
        ListTile(
            title: const Text("Cerrar Sesion"),
            leading: const Icon(Icons.logout),
            onTap: () => logout(context)),
      ],
    ),
  );
}

logout(BuildContext context) {
  globals.isLoggedIn = false;
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}

beforeDeleteUser(BuildContext context) {
  showDialog<String>(
    context: context,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) => AlertDialog(
      title: const Text('Eliminar usuario'),
      content: const Text('Usuario eliminado'),
      actions: <Widget>[
        TextButton(
          onPressed: () => afterDeleteUser(context),
          child: const Text('Confirmar'),
        ),
      ],
    ),
  );
}

afterDeleteUser(BuildContext context) {
  deleteUser().then((_) {
    Navigator.of(context).pushReplacement(
      FadePageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  });
}
