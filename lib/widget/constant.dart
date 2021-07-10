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
  var list = [].obs;
  var listInit = [];

  getFilter(String s, List l) {
    List<Utilisateur> listFilter = [];
    if (s.isEmpty || s == "")
      return listInit;
    else {
      for (var i in l) {
        if (i!.nom!.toLowerCase().contains(s.toLowerCase()) ||
            i.email!.toLowerCase().contains(s.toLowerCase())) listFilter.add(i);
      }
      return listFilter;
    }
  }

  var keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: firestoreinstance.collection('Utilisateur').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: LoadingFullScreen(),
            );
          if (snapshot.hasData) {
            for (var i in snapshot.data!.docs) {
              listInit.add(Utilisateur.fromMap(i.data()));
              list.value = listInit;
            }
          }
          return Scaffold(
            floatingActionButton: null,
            appBar: AppBar(
              centerTitle: true,
              title: Form(
                key: keyForm,
                child: Card(
                  elevation: 5,
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 800),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      style: Theme.of(context).textTheme.bodyText1,
                      onChanged: (v) {
                        list.value = getFilter(v, listInit);
                      },
                      controller: search,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Recherche',
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: Center(
                child: Obx(
              () => Column(children: [
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 500),
                  child: list.value == listInit
                      ? Container(
                          constraints: BoxConstraints(maxWidth: 800),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'Suggestion',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        )
                      : Container(
                          constraints: BoxConstraints(maxWidth: 800),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            '(${list.length}) résultat(s) pour: ${search.text}',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ),
                ),
                Expanded(
                  child: Container(
                      constraints: BoxConstraints(maxWidth: 800),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return DiscussionSpecialItem(
                                type: 'New Friend',
                                description: list[index].email!,
                                correspondant: list[index].uid!);
                          })),
                ),
              ]),
            )),
          );
        });
  }
}

class LoadingChat extends StatelessWidget {
  const LoadingChat({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      reverse: true,
      children: [
        Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 120,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    constraints: BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: 40,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    constraints: BoxConstraints(maxWidth: 230),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                  ),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    height: 120,
                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    constraints: BoxConstraints(maxWidth: 400),
                    decoration: BoxDecoration(
                        color: Get.isDarkMode
                            ? Colors.blue.withOpacity(0.6)
                            : Theme.of(context).primaryColor.withOpacity(0.6),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25))),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
