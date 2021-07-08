import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:social_message/model/class.dart';
import 'package:social_message/service/authentification.dart';
import 'package:social_message/widget/item.dart';

class Loading extends StatelessWidget {
  const Loading({this.color, Key? key}) : super(key: key);
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return SpinKitThreeBounce(
      color: color ?? Theme.of(context).primaryColor,
      size: 25.0,
    );
  }
}

class LoadingFullScreen extends StatelessWidget {
  const LoadingFullScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitThreeBounce(
          color: Get.isDarkMode ? Colors.white : Theme.of(context).primaryColor,
          size: 50.0,
        ),
      ),
    );
  }
}

class ErrorFullScreen extends StatelessWidget {
  const ErrorFullScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Une erreur est survenue',
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.red),
        ),
      ),
    );
  }
}

class LoadingConversation extends StatelessWidget {
  const LoadingConversation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      contentPadding: EdgeInsets.symmetric(horizontal: 0),
      trailing: Container(
        child: CircleAvatar(
          radius: 9,
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.3),
      ),
      title: Container(
        height: 17,
        width: 170,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
      subtitle: Container(
        height: 13,
        width: 170,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.3),
            borderRadius: BorderRadius.all(Radius.circular(10))),
      ),
    );
  }
}

//
class IntroChatting extends StatelessWidget {
  const IntroChatting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Bienvenue sur LYLA',
          style: Get.isDarkMode
              ? ThemeData.dark().textTheme.headline4
              : ThemeData.light().textTheme.headline4,
        ),
      ),
    );
  }
}

class AddFriend extends StatefulWidget {
  const AddFriend({Key? key}) : super(key: key);

  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend> {
  TextEditingController search = TextEditingController();
  var searchText = ''.obs;
  List<Utilisateur> list = [];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: firestoreinstance.collection('Utilisateur').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: Loading(),
            );
          if (snapshot.hasData) {
            for (var i in snapshot.data!.docs) {
              list.add(Utilisateur.fromMap(i.data()));
            }
          }
          return Column(children: [
            Material(
              elevation: 4,
              child: TextFormField(
                controller: search,
                onChanged: (v) {
                  searchText.value = v;
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Recherche',
                  filled: true,
                  suffixIcon: IconButton(
                      onPressed: () {}, icon: Icon(FontAwesomeIcons.search)),
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return DiscussionSpecialItem(
                      description: list[index].email!,
                      correspondant: list[index].uid!);
                })
          ]);
        });
  }
}
