import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/sockets/src/sockets_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_message/data/internal.dart';
import 'package:social_message/model/class.dart';

import 'service/authentification.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

var streamUser = FirebaseFirestore.instance.collection('Utilisateur');

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    User? user = context.watch<User?>();
    return Row(children: [
      Container(
          width: 300,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Icon(FontAwesomeIcons.comments,
                        color: Get.isDarkMode
                            ? Colors.white70
                            : Theme.of(context).primaryColor.withOpacity(0.8)),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Discussion',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              Divider(),
              Text(
                'Contacts spéciaux',
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: firestoreinstance
                      .collection('Utilisateur')
                      .doc(naimUid)
                      .get(),
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting)
                      return Container();
                    Utilisateur? utilisateur;
                    if (snap.hasData) {
                      utilisateur = Utilisateur.fromMap(snap.data!.data()!);
                    }
                    return ListTile(
                      trailing: Container(
                        child: StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                            stream: firestoreinstance
                                .collection('Utilisateur')
                                .doc(user!.uid)
                                .collection('Correspondant')
                                .doc(utilisateur!.uid)
                                .collection('Discussion')
                                .where('vuHe', isEqualTo: false)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) return Container();
                              List<Message> listMessage = [];
                              if (snapshot.hasData) {
                                for (var i in snapshot.data!.docs) {
                                  listMessage.add(Message.fromMap(i.data()));
                                }
                              }

                              return Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(listMessage.length.toString(),
                                      style: GoogleFonts.poppins(
                                        color: Get.isDarkMode
                                            ? Colors.blue
                                            : Theme.of(context).primaryColor,
                                      )),
                                  CircleAvatar(
                                    radius: 7,
                                    backgroundColor: Get.isDarkMode
                                        ? Colors.blue
                                        : Theme.of(context).primaryColor,
                                  )
                                ],
                              );
                            }),
                      ),
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(utilisateur.image!),
                      ),
                      title: Text(
                        utilisateur.nom!,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 18,
                            color:
                                Get.isDarkMode ? Colors.white : Colors.black),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        'Développeur Full-Stack',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1!
                            .copyWith(fontSize: 15, color: Colors.grey),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  })
            ],
          )),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Container(
            decoration: BoxDecoration(color: Theme.of(context).highlightColor),
          ),
        ),
      ),
      Container(
          width: 300,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Icon(FontAwesomeIcons.userCircle,
                        color: Get.isDarkMode
                            ? Colors.white70
                            : Theme.of(context).primaryColor.withOpacity(0.8)),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'Profil',
                    style: Theme.of(context)
                        .textTheme
                        .headline4!
                        .copyWith(fontSize: 20, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
              Divider(),
              StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: streamUser.doc(user!.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting)
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircleAvatar(
                            radius: 100,
                            backgroundColor:
                                Theme.of(context).primaryColor.withOpacity(0.3),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 17,
                            width: 170,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Container(
                            height: 13,
                            width: 200,
                            decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.3),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          )
                        ],
                      );
                    Utilisateur? utilisateur;
                    if (snapshot.hasData) {
                      utilisateur = Utilisateur.fromMap(snapshot.data!.data()!);
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 100,
                          backgroundImage: NetworkImage(
                            utilisateur!.image!,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          utilisateur.nom!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          utilisateur.email!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(fontSize: 17, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    );
                  }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 17),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              primary: Theme.of(context).primaryColor),
                          onPressed: () {},
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(FontAwesomeIcons.userEdit,
                                    color: Get.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                    size: 18),
                                Text('Modifier',
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                          onPressed: () {
                            Get.defaultDialog(
                              titleStyle: Theme.of(context).textTheme.headline4,
                              middleTextStyle:
                                  Theme.of(context).textTheme.bodyText1,
                              title: 'Déconnexion',
                              middleText: 'Confirmez votre décision',
                              textCancel: 'retour',
                              cancel: OutlinedButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 5),
                                    child: Text(
                                      'retour',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              color: Get.isDarkMode
                                                  ? Colors.white70
                                                  : Colors.black87),
                                    ),
                                  )),
                              confirm: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      elevation: 0, primary: Colors.red),
                                  onPressed: () async {
                                    var _auth =
                                        Authentification(FirebaseAuth.instance);
                                    await _auth.deconnection();
                                    Get.back();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 3, horizontal: 5),
                                    child: Text(
                                      'se déconnecter',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              color: Get.isDarkMode
                                                  ? Colors.white70
                                                  : Colors.black87),
                                    ),
                                  )),
                              // textConfirm: 'se déconnecter'
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Déconnexion',
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Get.isDarkMode
                                            ? Colors.white
                                            : Colors.black)),
                                Icon(
                                  FontAwesomeIcons.signOutAlt,
                                  color: Get.isDarkMode
                                      ? Colors.white
                                      : Colors.black,
                                  size: 18,
                                )
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              ),

              // Text(
              //   'Liste D\'amis',
              //   style: Theme.of(context)
              //       .textTheme
              //       .headline4!
              //       .copyWith(fontSize: 25, fontWeight: FontWeight.w300),
              // ),
              Divider(),
            ],
          )),
    ]);
  }
}
