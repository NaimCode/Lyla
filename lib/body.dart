import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:social_message/globalVariable.dart';
import 'package:social_message/home.dart';
import 'package:social_message/login.dart';
import 'package:social_message/widget/constant.dart';

import 'controllers/cubit/chatting_cubit.dart';
import 'controllers/cubit/settings_cubit.dart';
import 'data/internal.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ScaffoldKey,
      endDrawer: Drawer(
        child: Profil(user: context.watch<User?>()),
      ),
      body: Row(
        children: [MenuSection(), Expanded(child: Home())],
      ),
    );
  }
}

class BodyLog extends StatelessWidget {
  const BodyLog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [MenuSection(), Expanded(child: Login())],
      ),
    );
  }
}

class MenuSection extends StatefulWidget {
  const MenuSection({
    Key? key,
  }) : super(key: key);

  @override
  _MenuSectionState createState() => _MenuSectionState();
}

class _MenuSectionState extends State<MenuSection> {
  @override
  Widget build(BuildContext context) {
    final settings = BlocProvider.of<SettingsCubit>(context);
    var isMobile = MediaQuery.of(context).size.width < 1000;
    return Container(
      color: Theme.of(context).primaryColor,
      width: 60,
      padding: EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              if (isMobile) {
                //Get.to(() => IntroChatting());
              } else {
                corresGlobal = null;
                BlocProvider.of<ChattingCubit>(context).select(null);
              }
            },
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
            focusColor: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Image.asset('icons/logo.png'),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
          )),
          ...ColorTheme.map((e) => Visibility(
                visible: Get.isDarkMode ? false : true,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: FloatingActionButton(
                    //  padding: EdgeInsets.all(2),
                    onPressed: () {
                      settings.changecoloTheme(e['title']);
                    },
                    hoverColor: Colors.transparent,
                    // highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    backgroundColor: e['color']!,
                  ),
                ),
              )).toList(),
          SizedBox(
            height: 8,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
                padding: EdgeInsets.all(2),
                onPressed: () {
                  settings.changeDarkMode(!settings.state.setDarkMode!);
                },
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                icon: Icon(FontAwesomeIcons.adjust)),
          ),
        ],
      ),
    );
  }
}
