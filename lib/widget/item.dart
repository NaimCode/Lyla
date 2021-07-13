import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_message/controllers/cubit/chatting_cubit.dart';
import 'package:social_message/globalVariable.dart';
import 'package:social_message/home.dart';
import 'package:social_message/model/class.dart';
import 'package:social_message/service/authentification.dart';
import 'package:provider/provider.dart';
import 'constant.dart';

class DiscussionSpecialItem extends StatefulWidget {
  DiscussionSpecialItem({
    required this.type,
    required this.description,
    required this.correspondant,
    Key? key,
  }) : super(key: key);

  final String correspondant;
  final String description;
  final String type;

  @override
  _DiscussionSpecialItemState createState() => _DiscussionSpecialItemState();
}

class _DiscussionSpecialItemState extends State<DiscussionSpecialItem> {
  @override
  Widget build(BuildContext context) {
    User? user = context.watch<User?>();
    bool isMobile = MediaQuery.of(context).size.width <= 800;
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: firestoreinstance
            .collection('Utilisateur')
            .doc(widget.correspondant)
            .get(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return Container();
          Utilisateur? utilisateur;
          if (snap.hasData) {
            utilisateur = Utilisateur.fromMap(snap.data!.data()!);
          }
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: firestoreinstance
                  .collection('Utilisateur')
                  .doc(user!.uid)
                  .collection('Correspondant')
                  .doc(widget.correspondant)
                  .collection('Discussion')
                  .where('vu', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return LoadingConversation();
                List<Message> listMessage = [];
                if (!snapshot.hasData) return LoadingConversation();
                if (snapshot.hasData) {
                  listMessage.clear();
                  for (var i in snapshot.data!.docs) {
                    if (!i.data()['vu'])
                      listMessage.add(Message.fromMap(i.data()));
                  }
                }

                return ListTile(
                  selected: utilisateur!.uid == widget.correspondant,
                  onTap: () async {
                    switch (widget.type) {
                      case 'Discussion':
                        if (!isMobile) {
                          corresGlobal = utilisateur;
                          BlocProvider.of<ChattingCubit>(context)
                              .select(utilisateur);
                        } else
                          Get.to(() =>
                              Chatting(user: user, correspondant: utilisateur));
                        break;

                      case 'New Friend':
                        DocumentReference<Map<String, dynamic>> doc =
                            firestoreinstance
                                .collection('Utilisateur')
                                .doc(user.uid)
                                .collection('Correspondant')
                                .doc(widget.correspondant);
                        await doc.get().then((value) async {
                          if (!value.exists) {
                            doc.set({
                              'email': utilisateur!.email,
                              'uid': widget.correspondant,
                            });
                            await firestoreinstance
                                .collection('Utilisateur')
                                .doc(user.uid)
                                .collection('Correspondant')
                                .doc(widget.correspondant)
                                .collection('Discussion')
                                .add({
                              'sender': widget.correspondant,
                              'response': null,
                              'vu': true,
                              'attachmentType': null,
                              'attachment': null,
                              'date': Timestamp.now(),
                              'content': 'Salut je suis ${utilisateur.nom}',
                            });
                          }
                        });

                        corresGlobal = utilisateur;
                        BlocProvider.of<ChattingCubit>(context)
                            .select(utilisateur);
                        Get.back();
                        break;
                      default:
                    }
                  },
                  dense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  trailing: Container(
                    child: listMessage.length == 0
                        ? Container(
                            width: 0,
                          )
                        : Row(
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
                                radius: 4,
                                backgroundColor: Get.isDarkMode
                                    ? Colors.blue
                                    : Theme.of(context).primaryColor,
                              )
                            ],
                          ),
                  ),
                  leading: utilisateur.image == null
                      ? CircleAvatar(
                          backgroundColor:
                              Theme.of(context).primaryColor.withOpacity(0.7),
                          child: Text(
                            utilisateur.nom![0],
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(fontSize: 20),
                          ),
                        )
                      : InkWell(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {
                            Get.to(() => ImageView(image: utilisateur!.image!));
                          },
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(utilisateur.image!),
                          ),
                        ),
                  title: Text(
                    utilisateur.nom!,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 18,
                        color: Get.isDarkMode ? Colors.white : Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    widget.description,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontSize: 15, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              });
        });
  }
}

class DiscussionItem extends StatefulWidget {
  const DiscussionItem({
    required this.correspondant,
    Key? key,
  }) : super(key: key);

  final Utilisateur correspondant;

  @override
  _DiscussionItemState createState() => _DiscussionItemState();
}

class _DiscussionItemState extends State<DiscussionItem> {
  @override
  Widget build(BuildContext context) {
    User? user = context.watch<User?>();
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: firestoreinstance
            .collection('Utilisateur')
            .doc(user!.uid)
            .collection('Correspondant')
            .doc(widget.correspondant.uid!)
            .collection('Discussion')
            .where('vu', isEqualTo: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return LoadingConversation();
          List<Message> listMessage = [];
          if (snapshot.hasData) {
            print(snapshot.data!.size);
            for (var i in snapshot.data!.docs) {
              listMessage.add(Message.fromMap(i.data()));
            }
          }

          return ListTile(
            onTap: () {
              corresGlobal = widget.correspondant;
              BlocProvider.of<ChattingCubit>(context)
                  .select(widget.correspondant);
            },
            dense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            trailing: Container(
              child: snapshot.data!.size == 0
                  ? Container(
                      width: 0,
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(snapshot.data!.size.toString(),
                            style: GoogleFonts.poppins(
                              color: Get.isDarkMode
                                  ? Colors.blue
                                  : Theme.of(context).primaryColor,
                            )),
                        CircleAvatar(
                          radius: 4,
                          backgroundColor: Get.isDarkMode
                              ? Colors.blue
                              : Theme.of(context).primaryColor,
                        )
                      ],
                    ),
            ),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(widget.correspondant.image!),
            ),
            title: Text(
              widget.correspondant.nom!,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 18,
                  color: Get.isDarkMode ? Colors.white : Colors.black),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              widget.correspondant.email!,
              style: Theme.of(context)
                  .textTheme
                  .bodyText1!
                  .copyWith(fontSize: 15, color: Colors.grey),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          );
        });
  }
}
