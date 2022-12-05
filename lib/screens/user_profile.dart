import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:my_app/entities/EditData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:my_app/entities/user.dart';
import 'dart:async';
import 'package:my_app/routes/custom_route.dart';
import 'home_page.dart';
import 'package:my_app/entities/globals.dart' as globals;

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

    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          // Add TextFormFields and ElevatedButton here.
          TextFormField(
            // The validator receives the text that the user has entered.
            initialValue: getUser(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Introduzca texto';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Nombre',
            ),
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
              labelText: 'Apellidos',
            ),
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
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Introduzca texto';
              }
              return null;
            },
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Email',
            ),
          ),
          IntlPhoneField(
            decoration: const InputDecoration(
              labelText: 'Teléfono',
              border: OutlineInputBorder(
                borderSide: BorderSide(),
              ),
            ),
            initialCountryCode: 'ES',
            // onChanged: (phone) {
            //   print(phone.completeNumber);
            // },
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
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, or false otherwise.
              if (_formKey.currentState!.validate()) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Procesando datos...')),
                );
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
                    onPressed: () => Navigator.pop(context, 'Confirmar'),
                    child: const Text('Confirmar'),
                  ),
                ],
              ),
            ),
            child: const Text('Eliminar usuario'),
          ),
        ],
      ),
    );
  }
}

Widget build(BuildContext context) {
  return TextButton(
    onPressed: () => showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Eliminar usuario'),
        content: const Text('¿Está seguro? Esta acción es irreversible'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('Confirmar'),
          ),
        ],
      ),
    ),
    child: const Text('Show Dialog'),
  );
}

Widget _getDrawer(BuildContext context) {
  var accountEmail = Text("EMAIL");
  var accountName = Text("USUARIO");
  var accountPicture = Icon(FontAwesomeIcons.userLarge);
  return Drawer(
    child: ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
            accountName: accountName,
            accountEmail: accountEmail,
            currentAccountPicture: accountPicture),
        ListTile(
            title: const Text("Jugar Partido"),
            leading: const Icon(Icons.play_arrow),
            onTap: () => showHome(context)),
        ListTile(
            title: const Text("Editar Perfil"),
            leading: const Icon(Icons.edit),
            onTap: () => showProfile(context)),
        ListTile(
            title: const Text("Historial"),
            leading: const Icon(Icons.history),
            onTap: () => showHome(context)),
        ListTile(
            title: const Text("Cerrar Sesion"),
            leading: const Icon(Icons.logout),
            onTap: () => showHome(context)),
      ],
    ),
  );
}

showHome(BuildContext context) {
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const HomePage(),
    ),
  );
}

showProfile(BuildContext context) {
  Navigator.of(context).pushReplacement(
    FadePageRoute(
      builder: (context) => const UserProfile(),
    ),
  );
}

getUser() {
  if (globals.isLoggedIn) {
    return "ESTA EN TRUE";
  } else {
    return "ESTA EN FALSE";
  }
}
