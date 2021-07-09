import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/sockets/src/sockets_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_message/controllers/cubit/chatting_cubit.dart';
import 'package:social_message/data/internal.dart';
import 'package:social_message/model/class.dart';
import 'package:social_message/widget/constant.dart';
import 'package:social_message/widget/item.dart';

import 'globalVariable.dart';
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
          padding: EdgeInsets.symmetric(
            vertical: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Icon(FontAwesomeIcons.comments,
                          color: Get.isDarkMode
                              ? Colors.white70
                              : Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.8)),
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
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Divider(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Administrateur',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey),
                    ),
                    Text(
                      2.toString(),
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Get.isDarkMode ? Colors.white : Colors.black),
                    )
                  ],
                ),
              ),
              DiscussionSpecialItem(
                type: 'Discussion',
                correspondant: naimUid,
                description: 'Développeur Full-Stack',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Divider(
                  height: 1,
                ),
              ),
              DiscussionSpecialItem(
                type: 'Discussion',
                correspondant: ranaUid,
                description: 'Designer UX/UI',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Divider(),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: firestoreinstance
                        .collection('Utilisateur')
                        .doc(user!.uid)
                        .collection('Correspondant')
                        .snapshots(),
                    builder: (context, snap) {
                      if (snap.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      List<Utilisateur> listCorres = [];
                      if (snap.hasData) {
                        for (var i = 0; i < snap.data!.size; i++) {
                          if (snap.data!.docs[i].data()['uid'] == naimUid ||
                              snap.data!.docs[i].data()['uid'] == ranaUid) {
                          } else
                            listCorres.add(
                                Utilisateur.fromMap(snap.data!.docs[i].data()));
                        }
                      }
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Amis',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w300,
                                          color: Colors.grey),
                                ),
                                Text(
                                  (snap.data!.size - 2).toString(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Get.isDarkMode
                                              ? Colors.white
                                              : Colors.black),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: listCorres.length,
                              itemBuilder: (context, index) {
                                return DiscussionSpecialItem(
                                  type: 'Discussion',
                                  correspondant: snap.data!.docs[index].id,
                                  description:
                                      snap.data!.docs[index].data()['email'],
                                );
                              })
                        ],
                      );
                    }),
              ),
              Center(
                child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        primary: Get.isDarkMode
                            ? Colors.blue
                            : Theme.of(context).primaryColor),
                    onPressed: () async {
                      Get.to(() => Provider<User?>(
                            create: (_) => user,
                            child: AddFriend(),
                          ));
                    },
                    icon: Icon(Icons.add,
                        color: Get.isDarkMode ? Colors.white : Colors.black),
                    label: Row(
                      children: [
                        Text('Ajouter un(e) ami(e)',
                            style: Theme.of(context).textTheme.bodyText1)
                      ],
                    )),
              )
            ],
          )),
      Expanded(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Container(
              child: BlocBuilder<ChattingCubit, ChattingState>(
                builder: (context, state) {
                  return AnimatedSwitcher(
                    transitionBuilder: (widget, animation) => ScaleTransition(
                      scale: animation,
                      child: widget,
                    ),
                    duration: Duration(milliseconds: 1000),
                    child: state.corres == null
                        ? IntroChatting(
                            key: UniqueKey(),
                          )
                        : Chatting(
                            correspondant: state.corres,
                            key: UniqueKey(),
                          ),
                  );
                },
              ),
            )),
      ),
      Container(
          width: 300,
          padding: EdgeInsets.symmetric(vertical: 25, horizontal: 10),
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
                  stream: streamUser.doc(user.uid).snapshots(),
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
                        utilisateur!.image == null
                            ? CircleAvatar(
                                radius: 100,
                                backgroundColor: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.7),
                                child: Center(
                                  child: Text(
                                    utilisateur.nom![0],
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline4!
                                        .copyWith(fontSize: 50),
                                  ),
                                ),
                              )
                            : CircleAvatar(
                                radius: 100,
                                backgroundImage: NetworkImage(
                                  utilisateur.image!,
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

class Chatting extends StatefulWidget {
  const Chatting({
    required this.correspondant,
    Key? key,
  }) : super(key: key);
  final Utilisateur? correspondant;
  @override
  _ChattingState createState() => _ChattingState();
}

class _ChattingState extends State<Chatting> {
  @override
  TextEditingController messageContent = TextEditingController();
  var isCharging = false.obs;
  User? user;
  sendMessage() async {
    isCharging.value = true;
    var message1 = {
      'sender': user!.uid,
      'response': null,
      'vu': true,
      'attachmentType': null,
      'attachment': null,
      'date': Timestamp.now(),
      'content': messageContent.text,
    };
    try {
      DocumentReference<Map<String, dynamic>> doc = firestoreinstance
          .collection('Utilisateur')
          .doc(user!.uid)
          .collection('Correspondant')
          .doc(widget.correspondant!.uid);

      doc.get().then((value) {
        if (!value.exists) {
          doc.set({
            'email': widget.correspondant!.email,
            'uid': widget.correspondant!.uid,
          });
        }
      });
      await firestoreinstance
          .collection('Utilisateur')
          .doc(user!.uid)
          .collection('Correspondant')
          .doc(widget.correspondant!.uid)
          .collection('Discussion')
          .add(message1);

      doc = firestoreinstance
          .collection('Utilisateur')
          .doc(widget.correspondant!.uid)
          .collection('Correspondant')
          .doc(user!.uid);

      doc.get().then((value) {
        if (!value.exists) {
          doc.set({
            'email': user!.email,
            'uid': user!.uid,
          });
        }
      });
      message1 = {
        'sender': user!.uid,
        'response': null,
        'vu': false,
        'attachmentType': null,
        'attachment': null,
        'date': Timestamp.now(),
        'content': messageContent.text,
      };
      await firestoreinstance
          .collection('Utilisateur')
          .doc(widget.correspondant!.uid)
          .collection('Correspondant')
          .doc(user!.uid)
          .collection('Discussion')
          .add(message1);

      setState(() {
        isCharging.value = false;
        messageContent.clear();
      });
    } on Exception catch (e) {
      isCharging.value = false;
    }
  }

  setVu(String? uid) async {
    await firestoreinstance
        .collection('Utilisateur')
        .doc(user!.uid)
        .collection('Correspondant')
        .doc(widget.correspondant!.uid)
        .collection('Discussion')
        .doc(uid!)
        .update({'vu': true});
  }

  Widget build(BuildContext context) {
    user = context.watch<User?>();
    return Scaffold(
      backgroundColor: Theme.of(context).highlightColor,
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: firestoreinstance
              .collection('Utilisateur')
              .doc(user!.uid)
              .collection('Correspondant')
              .doc(widget.correspondant!.uid)
              .collection('Discussion')
              .orderBy('date', descending: true)
              .snapshots()
              .distinct(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }
            List<Message> listMessage = [];
            if (snapshot.hasData) {
              for (var i in snapshot.data!.docs) {
                listMessage.add(Message.fromMap(i.data()));
                if (!i.data()['vu']) setVu(i.id);
              }
            }
            return ListView.builder(
                reverse: true,
                itemCount: listMessage.length,
                itemBuilder: (context, index) {
                  return !listMessage[index].isMine(user!.uid)
                      ? Row(
                          children: [
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                constraints: BoxConstraints(maxWidth: 400),
                                decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                        bottomRight: Radius.circular(30))),
                                child: Text(listMessage[index].content!,
                                    style:
                                        Theme.of(context).textTheme.bodyText1),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                constraints: BoxConstraints(maxWidth: 400),
                                decoration: BoxDecoration(
                                    color: Get.isDarkMode
                                        ? Colors.blue.withOpacity(0.6)
                                        : Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.6),
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                        bottomLeft: Radius.circular(30))),
                                child: Text(
                                  listMessage[index].content!,
                                  style: Theme.of(context).textTheme.bodyText1!,
                                ),
                              ),
                            ),
                          ],
                        );
                });
          }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          // height: 60,
          color: Theme.of(context).cardColor,
          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: TextFormField(
                  controller: messageContent,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  minLines: 1,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                      color: Get.isDarkMode ? Colors.white : Colors.black),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Message',
                  ),
                ),
              ),
              Obx(() => isCharging.value
                  ? SizedBox(height: 40, child: Loading())
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 4,
                          primary: Get.isDarkMode
                              ? Colors.blue
                              : Theme.of(context).primaryColor),
                      onPressed: sendMessage,
                      child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: Icon(FontAwesomeIcons.paperPlane,
                              size: 22, color: Colors.black87)))),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.correspondant!.nom!,
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontSize: 20, fontWeight: FontWeight.w200),
              ),
            ]),
      ),
    );
  }
}
