import 'dart:html';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:social_message/service/authentification.dart';
import 'package:social_message/widget/constant.dart';

var _auth = Authentification(FirebaseAuth.instance);
var _logPage = [
  LoginEmailPassword(
    key: UniqueKey(),
  ),
  LoginImageName(
    key: UniqueKey(),
  )
];
var _index = 0.obs;
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
                  () => AnimatedSwitcher(
                    transitionBuilder: (widget, animation) => ScaleTransition(
                      scale: animation,
                      child: widget,
                    ),
                    duration: Duration(milliseconds: 1000),
                    child: _logPage[_index.value],
                  ),
                )
                //  Obx(
                //   () => _logPage[_index.value],
                // )
                )));
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
  var image;
  final picker = ImagePicker();
  pickAvatar() {
    var uploadImage = FileUploadInputElement()..accept = '.jpg,.png,.jpeg';
    uploadImage.click();
    uploadImage.onChange.listen((event) async {
      var file = uploadImage.files!.first;

      var path = basename(file.name);
      final reader = FileReader();
      reader.readAsArrayBuffer(file);
      reader.onLoad.listen((event) {
        print(event.loaded.toString());

        setState(() {
          image = {'uint8List': reader.result, 'path': path};
        });
      });
    });
  }

  var keyForm = GlobalKey<FormState>();
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
                  'Nouveau utilisateur',
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
          image == null
              ? CircleAvatar(
                  radius: 150,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.3),
                  child: Center(
                    child: IconButton(
                      tooltip: 'Ajouter une photo',
                      onPressed: pickAvatar,
                      icon: Icon(Icons.add_a_photo_rounded,
                          color: Get.isDarkMode ? null : Colors.black54),
                    ),
                  ),
                )
              : CircleAvatar(
                  radius: 170,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.3),
                  backgroundImage: MemoryImage(image['uint8List']),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      FloatingActionButton(
                        backgroundColor: Colors.red,
                        tooltip: 'Supprimer la photo',
                        onPressed: () {
                          setState(() {
                            image = null;
                          });
                        },
                        child: Icon(Icons.remove,
                            color: Get.isDarkMode ? null : Colors.black54),
                      ),
                    ],
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
            style:
                TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              filled: true,
              labelText: 'Nom',
            ),
          ),
          SizedBox(
            height: 30,
          ),
          isCharging
              ? Loading()
              : Row(
                  children: [
                    OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        onPressed: () {
                          _index.value = 0;
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back_ios_sharp,
                                color: Get.isDarkMode
                                    ? Colors.white
                                    : Colors.black,
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
                          onPressed: () async {
                            if (keyForm.currentState!.validate()) {
                              setState(() {
                                isCharging = true;
                              });
                              var check = await _auth.enregistrementAuth(
                                  _email.text, _password.text, nom.text, image);
                              switch (check) {
                                case 'Success':
                                  Get.rawSnackbar(
                                      title: 'Inscription réussie',
                                      message: 'Content de vous voir');
                                  break;
                                case 'Exist':
                                  _index.value = 0;
                                  break;
                                default:
                                  _index.value = 0;
                              }
                              setState(() {
                                isCharging = false;
                              });
                            }
                          },
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
      ),
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
            style:
                TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
            decoration: InputDecoration(
              filled: true,
              labelText: 'Email',
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            obscureText: true,
            controller: _password,
            validator: (v) {
              if (v == '' || v!.isEmpty) return 'Saisir votre mot de passe';
              if (v.length < 6) return 'Au moins 6 caractères';
              return null;
            },
            style:
                TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
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
              onPressed: () async {
                if (keyForm.currentState!.validate()) {
                  print('ok');
                  setState(() {
                    isCharging = true;
                  });
                  var check =
                      await _auth.connection(_email.text, _password.text);
                  setState(() {
                    isCharging = false;
                  });
                  switch (check) {
                    case 'Success':
                      Get.rawSnackbar(
                          title: 'Connexion',
                          message: 'Content de vous revoir');
                      break;
                    case 'Not Exist':
                      _index.value = 1;
                      break;
                    case 'Wrong password':
                      Get.rawSnackbar(
                          icon: Icon(Icons.error_outline_outlined,
                              color: Colors.red),
                          shouldIconPulse: true,
                          title: 'Connexion',
                          message: 'Erreur, mot de passe incorrect');
                      break;
                    default:
                  }
                } else
                  print('error');
              },
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
