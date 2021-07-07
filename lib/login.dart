import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_message/service/authentification.dart';
import 'package:social_message/widget/constant.dart';

var _logPage = [LoginEmailPassword(), LoginImageName()];
var _index = 1.obs;
TextEditingController _email = TextEditingController();
TextEditingController _password = TextEditingController();

class Login extends StatelessWidget {
  Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(
        body: Center(
            child: Container(
                width: 400,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Obx(
                  () => _logPage[_index.value],
                ))));
  }
}

class LoginImageName extends StatefulWidget {
  const LoginImageName({Key? key}) : super(key: key);

  @override
  _LoginImageNameState createState() => _LoginImageNameState();
}

class _LoginImageNameState extends State<LoginImageName> {
  bool isCharging = false;
  TextEditingController nom = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Row(
        //   crossAxisAlignment: CrossAxisAlignment.center,
        //   children: [

        //     Expanded(
        //         child: Center(
        //       child: Text(
        //         'Retour',
        //         style: Theme.of(context)
        //             .textTheme
        //             .headline4!
        //             .copyWith(fontSize: 25),
        //       ),
        //     ))
        //   ],
        // ),
        // SizedBox(
        //   height: 30,
        // ),
        IconButton(
            onPressed: () {
              _index.value = 0;
            },
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 23,
            )),
        CircleAvatar(
          radius: 170,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
          child: Center(
            child: Icon(Icons.add_a_photo_rounded,
                color: Get.isDarkMode ? null : Colors.black54),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: nom,
          validator: (v) {
            if (v == '' || v!.isEmpty) return 'Saisir votre nom';
            if (v.length < 4) return 'Au moins 4 caractères';
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            labelText: 'Nom',
          ),
        ),
        SizedBox(
          height: 30,
        ),
        Row(
          children: [
            OutlinedButton(
                style: OutlinedButton.styleFrom(
                    primary: Theme.of(context).primaryColor),
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back_ios_sharp,
                        color: Get.isDarkMode ? Colors.white : Colors.black,
                        size: 23,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text('Retour',
                          style: TextStyle(
                              fontSize: 18,
                              color: Get.isDarkMode
                                  ? Colors.white
                                  : Colors.black)),
                    ],
                  ),
                )),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Suivant',
                            style: TextStyle(
                                fontSize: 18,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black)),
                        isCharging
                            ? Loading(
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                              )
                            : Icon(
                                Icons.arrow_forward_ios_sharp,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
                                size: 23,
                              )
                      ],
                    ),
                  )),
            ),
          ],
        )
      ],
    );
  }
}

class LoginEmailPassword extends StatefulWidget {
  LoginEmailPassword({
    Key? key,
  }) : super(key: key);

  @override
  _LoginEmailPasswordState createState() => _LoginEmailPasswordState();
}

class _LoginEmailPasswordState extends State<LoginEmailPassword> {
  bool isCharging = false;
  final keyForm = GlobalKey<FormState>();

  var auth = Authentification(FirebaseAuth.instance);
  @override
  Widget build(BuildContext context) {
    return Form(
      key: keyForm,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Center(
                child: Text(
                  'Continuer avec votre email',
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(fontSize: 25),
                  textAlign: TextAlign.center,
                ),
              ))
            ],
          ),
          SizedBox(
            height: 30,
          ),
          TextFormField(
            controller: _email,
            validator: (v) {
              if (v == '' || v!.isEmpty) return 'Saisir votre email';
              if (!v.isEmail) return 'Saisir un email valide';
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              labelText: 'Email',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: _password,
            validator: (v) {
              if (v == '' || v!.isEmpty) return 'Saisir votre mot de passe';
              if (v.length < 6) return 'Au moins 6 caractères';
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              labelText: 'Mot de passe',
            ),
          ),
          SizedBox(
            height: 30,
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
              onPressed: () {},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Suivant',
                        style: TextStyle(
                            fontSize: 18,
                            color:
                                Get.isDarkMode ? Colors.white : Colors.black)),
                    isCharging
                        ? Loading(
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                          )
                        : Icon(
                            Icons.arrow_forward_ios_sharp,
                            color: Get.isDarkMode ? Colors.white : Colors.black,
                            size: 23,
                          )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
