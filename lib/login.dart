import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social_message/service/authentification.dart';
import 'package:auth_buttons/auth_buttons.dart'
    show GoogleAuthButton, AuthButtonStyle, AuthButtonType, AuthIconType;
import 'body.dart';
import 'widget/constant.dart';

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
      child: Number(),
    )));
  }
}

class Number extends StatelessWidget {
  Number({
    Key? key,
  }) : super(key: key);
  var isCharging = false.obs;
  final _formKey = GlobalKey<FormState>();
  var auth = Authentification(FirebaseAuth.instance);
  TextEditingController number = TextEditingController();
  String? code;
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Suivez les étape afin d\'activer votre compte',
            style: Theme.of(context).textTheme.headline4!,
            textAlign: TextAlign.center,
          ),
          TextFormField(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Saisir votre numéro';
              } else {
                return null;
              }
            },
            controller: number,
            decoration: InputDecoration(
                prefix: CountryCodePicker(
                  dialogBackgroundColor: Theme.of(context).cardColor,
                  onChanged: (v) {
                    code = v.dialCode;
                  },
                  searchStyle: Theme.of(context).textTheme.bodyText1,
                  textStyle: Theme.of(context).textTheme.bodyText1,
                  barrierColor: Get.isDarkMode ? Colors.black26 : null,
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'IT',
                  favorite: ['FR', '+235', '+212'],
                  // optional. Shows only country name and flag
                  showCountryOnly: false,
                  showFlag: false,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                ),
                filled: true,
                labelText: 'Entrer votre numéro'),
          ),
          InkWell(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                isCharging.value = true;
                // await Authentification(FirebaseAuth.instance)
                //     .loginUser(code! + number.text, context);

                isCharging.value = false;
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Suivant',
                      style: Theme.of(context).textTheme.headline6!.copyWith(
                          color: Get.isDarkMode
                              ? ThemeData.dark().textTheme.headline6!.color
                              : null)),
                  isCharging.value
                      ? Icon(Icons.navigate_next_outlined)
                      : Loading()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
