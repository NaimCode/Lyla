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

class DiscussionSpecialItem extends StatelessWidget {
  const DiscussionSpecialItem({
    required this.description,
    required this.correspondant,
    Key? key,
  }) : super(key: key);

  final String correspondant;
  final String description;

  @override
  Widget build(BuildContext context) {
    User? user = context.watch<User?>();
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: firestoreinstance
            .collection('Utilisateur')
            .doc(correspondant)
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
                  .doc(utilisateur!.uid!)
                  .collection('Discussion')
                  .where('vuHe', isEqualTo: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return LoadingConversation();
                List<Message> listMessage = [];
                if (snapshot.hasData) {
                  for (var i in snapshot.data!.docs) {
                    listMessage.add(Message.fromMap(i.data()));
                  }
                }

                return ListTile(
                  onTap: () {
                    corresGlobal = utilisateur;
                    BlocProvider.of<ChattingCubit>(context).select(utilisateur);
                  },
                  dense: true,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  trailing: Container(
                    child: Row(
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
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(utilisateur!.image!),
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
                    description,
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
