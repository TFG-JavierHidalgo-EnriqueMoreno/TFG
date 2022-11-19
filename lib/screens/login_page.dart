import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:my_app/entities/constants.dart';
import '../entities/users.dart';
import '../routes/custom_route.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';

  const LoginScreen({Key? key}) : super(key: key);

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _loginUser(LoginData data) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(data.name)) {
        return 'El Usuario no existe';
      }
      // if (mockUsers[data.name] != data.password) {
      //   return 'Password does not match';
      // }
      return null;
    });
  }

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      if (!mockUsers.containsKey(name)) {
        return 'El Usuario no existe';
      }
      return null;
    });
  }

  Future<String?> _signupConfirm(String error, LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: Constants.appName,
      logo: const AssetImage('assets/images/logo.png'),
      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      navigateBackAfterRecovery: true,
      onConfirmRecover: _signupConfirm,
      onConfirmSignup: _signupConfirm,
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
      termsOfService: [
        // TermOfService(
        //   id: 'newsletter',
        //   mandatory: false,
        //   text: 'Newsletter subscription',
        // ),
        TermOfService(
          id: 'general-term',
          mandatory: true,
          text: 'Terminos de servicios',
          linkUrl: 'https://github.com/NearHuscarl/flutter_login',
        ),
      ],
      additionalSignupFields: [
        const UserFormField(
          keyName: 'Username',
          icon: Icon(FontAwesomeIcons.userLarge),
        ),
        const UserFormField(keyName: 'Name'),
        const UserFormField(keyName: 'Surname'),
        UserFormField(
          keyName: 'phone_number',
          displayName: 'Phone Number',
          userType: LoginUserType.phone,
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
        userHint: 'Usuario',
        passwordHint: 'Contraseña',
        confirmPasswordHint: 'Confirmar',
        loginButton: 'INICIAR SESIÓN',
        signupButton: 'REGISTRO',
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
        return _loginUser(loginData);
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
        return _signupUser(signupData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          FadePageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      },
      onRecoverPassword: (name) {
        debugPrint('Recover password info');
        debugPrint('Name: $name');
        return _recoverPassword(name);
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
