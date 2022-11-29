import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import 'package:my_app/entities/constants.dart';
import 'package:my_app/screens/home_page.dart';
import '../controllers/userController.dart';
import '../entities/users.dart';
import '../routes/custom_route.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/auth';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends StateMVC<LoginScreen> {
  /// Let the 'business logic' run in a Controller
  _LoginScreenState() : super(userController()) {
    /// Acquire a reference to the passed Controller.
    con = controller as userController;
  }

  late userController con;
  // @override
  // void initState() {
  //   /// Look inside the parent function and see it calls
  //   /// all it's Controllers if any.
  //   super.initState();

  //   /// Retrieve the 'app level' State object
  //   //appState = rootState!;

  //   /// You're able to retrieve the Controller(s) from other State objects.
  //   var con = appState.controller;

  //   con = appState.controllerByType<userController>();

  //   con = appState.controllerById(con?.keyId);
  // }

  late AppStateMVC appState;

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: Constants.appName,
      logo: const AssetImage('assets/images/logo.png'),
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      navigateBackAfterRecovery: true,
      onConfirmRecover: con.signupConfirm,
      onConfirmSignup: con.signupConfirm,
      loginAfterSignUp: false,
      // loginProviders: [
      //   LoginProvider(
      //     button: Buttons.linkedIn,
      //     label: 'Sign in with LinkedIn',
      //     callback: () async {
      //       return null;
      //     },
      //     providerNeedsSignUpCallback: () {
      //       // put here your logic to conditionally show the additional fields
      //       return Future.value(true);
      //     },
      //   ),
      //   LoginProvider(
      //     icon: FontAwesomeIcons.google,
      //     label: 'Google',
      //     callback: () async {
      //       return null;
      //     },
      //   ),
      //   LoginProvider(
      //     icon: FontAwesomeIcons.githubAlt,
      //     callback: () async {
      //       debugPrint('start github sign in');
      //       await Future.delayed(loginTime);
      //       debugPrint('stop github sign in');
      //       return null;
      //     },
      //   ),
      // ],

      // termsOfService: [
      //   // TermOfService(
      //   //   id: 'newsletter',
      //   //   mandatory: false,
      //   //   text: 'Newsletter subscription',
      //   // ),
      //   TermOfService(
      //     id: 'general-term',
      //     mandatory: true,
      //     text: 'Terminos de servicios',
      //     linkUrl: 'https://github.com/NearHuscarl/flutter_login',
      //   ),
      // ],
      additionalSignupFields: [
        const UserFormField(
          keyName: 'Username',
          displayName: "Nombre de usuario",
          icon: Icon(FontAwesomeIcons.userLarge),
        ),
        const UserFormField(keyName: 'Nombre'),
        const UserFormField(keyName: 'Apellidos'),
        UserFormField(
          keyName: 'phone_number',
          displayName: 'Numero de teléfono',
          userType: LoginUserType.phone,
          icon: const Icon(Icons.phone_android),
          fieldValidator: (value) {
            final phoneRegExp = RegExp(
              '^(\\+\\d{1,2}\\s)?\\(?\\d{3}\\)?[\\s.-]?\\d{3}[\\s.-]?\\d{4}\$',
            );
            if (value != null &&
                value.length < 7 &&
                !phoneRegExp.hasMatch(value)) {
              return "El número de teléfono no es correcto";
            }
            return null;
          },
        ),
      ],
      messages: LoginMessages(
        forgotPasswordButton: 'Recuperar contraseña',
        userHint: 'Correo',
        passwordHint: 'Contraseña',
        confirmPasswordHint: 'Confirmar',
        loginButton: 'INICIAR SESIÓN',
        signupButton: 'IR AL REGISTRO',
        recoverPasswordButton: 'ENVIAR',
        goBackButton: 'VOLVER',
        confirmPasswordError: 'Las contraseñas no coinciden',
        recoverPasswordIntro: 'Introduzca su dirección de correo',
        recoverPasswordDescription:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
        recoverPasswordSuccess: 'La contraseña se ha recuperado correctamente',
        flushbarTitleError: '¡Oh no!',
        flushbarTitleSuccess: '¡Exito!',
        recoverCodePasswordDescription:
            'Se enviará un correo para recuperar su contraseña',
        confirmRecoverIntro:
            "Introduzca el código recibido en el correo y su nueva contraseña",
        setPasswordButton: "CAMBIAR CONTRASEÑA",
        additionalSignUpSubmitButton: "REGISTRARME",
        additionalSignUpFormDescription:
            "Por favor complete este formulario para completar el registro",
      ),
      theme: LoginTheme(
        //   primaryColor: Colors.teal,
        //   accentColor: Colors.yellow,
        //   errorColor: Colors.deepOrange,
        //   pageColorLight: Colors.indigo.shade300,
        //   pageColorDark: Colors.indigo.shade500,
        //   logoWidth: 0.80,
        titleStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'Quicksand',
          letterSpacing: 4,
        ),
        //   // beforeHeroFontSize: 50,
        //   // afterHeroFontSize: 20,
        //   bodyStyle: TextStyle(
        //     fontStyle: FontStyle.italic,
        //     decoration: TextDecoration.underline,
        //   ),
        //   textFieldStyle: TextStyle(
        //     color: Colors.orange,
        //     shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
        //   ),
        buttonStyle: TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.white,
        ),

        //   cardTheme: CardTheme(
        //     color: Colors.yellow.shade100,
        //     elevation: 5,
        //     margin: EdgeInsets.only(top: 15),
        //     shape: ContinuousRectangleBorder(
        //         borderRadius: BorderRadius.circular(100.0)),
        //   ),
        //   inputTheme: InputDecorationTheme(
        //     filled: true,
        //     fillColor: Colors.purple.withOpacity(.1),
        //     contentPadding: EdgeInsets.zero,
        //     errorStyle: TextStyle(
        //       backgroundColor: Colors.orange,
        //       color: Colors.white,
        //     ),
        //     labelStyle: TextStyle(fontSize: 12),
        //     enabledBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
        //       borderRadius: inputBorder,
        //     ),
        //     focusedBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
        //       borderRadius: inputBorder,
        //     ),
        //     errorBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.red.shade700, width: 7),
        //       borderRadius: inputBorder,
        //     ),
        //     focusedErrorBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.red.shade400, width: 8),
        //       borderRadius: inputBorder,
        //     ),
        //     disabledBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(color: Colors.grey, width: 5),
        //       borderRadius: inputBorder,
        //     ),
      ),
      userValidator: (value) {
        if (value!.isEmpty) {
          return "Introduzca un nombre de usuario";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return 'La contraseña esta vacia';
        }
        return null;
      },
      onLogin: (loginData) {
        debugPrint('Login info');
        debugPrint('Name: ${loginData.name}');
        debugPrint('Password: ${loginData.password}');
        return con.loginUser(loginData);
      },
      onSignup: (signupData) {
        debugPrint('Signup info');
        debugPrint('Name: ${signupData.name}');
        debugPrint('Password: ${signupData.password}');

        signupData.additionalSignupData?.forEach((key, value) {
          debugPrint('$key: $value');
        });
        if (signupData.termsOfService.isNotEmpty) {
          debugPrint('Terms of service: ');
          for (final element in signupData.termsOfService) {
            debugPrint(
              ' - ${element.term.id}: ${element.accepted == true ? 'accepted' : 'rejected'}',
            );
          }
        }
        return con.signupUser(signupData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          FadePageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      },
      onRecoverPassword: (name) {
        debugPrint('Recover password info');
        debugPrint('Name: $name');
        return con.recoverPassword(name);
        // Show new password dialog
      },
      headerWidget: const IntroWidget(),
    );
  }
}

class IntroWidget extends StatelessWidget {
  const IntroWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const Text.rich(
        //   TextSpan(
        //     children: [
        //       TextSpan(
        //         text: "You are trying to login/sign up on server hosted on ",
        //       ),
        //       TextSpan(
        //         text: "example.com",
        //         style: TextStyle(fontWeight: FontWeight.bold),
        //       ),
        //     ],
        //   ),
        //   textAlign: TextAlign.justify,
        // ),
        Row(
          children: const <Widget>[
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Inicio de sesión"),
            ),
            Expanded(child: Divider()),
          ],
        ),
      ],
    );
  }
}
