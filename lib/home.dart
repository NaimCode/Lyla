import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/sockets/src/sockets_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_message/controllers/cubit/chatting_cubit.dart';
import 'package:social_message/data/internal.dart';
import 'package:social_message/model/class.dart';
import 'package:social_message/widget/constant.dart';
import 'package:social_message/widget/item.dart';
import 'package:timeago/timeago.dart' as timeago;
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
    bool isMobile = MediaQuery.of(context).size.width <= 1000;
    return Row(children: [
      Container(
          width: isMobile ? MediaQuery.of(context).size.width - 60 : 300,
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
                    Expanded(child: Container()),
                    !isMobile
                        ? Container()
                        : IconButton(
                            onPressed: () {
                              ScaffoldKey.currentState!.openEndDrawer();
                            },
                            icon: Icon(
                              Icons.menu,
                              color: Get.isDarkMode
                                  ? Colors.blue
                                  : Theme.of(context).primaryColor,
                            ))
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
                      'Développeurs',
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
                        for (var i in snap.data!.docs) {
                          if (i.id == naimUid || i.id == ranaUid) {
                          } else
                            listCorres.add(Utilisateur.fromMap(i.data()));
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
                                  listCorres.length.toString(),
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
                                    correspondant: listCorres[index].uid!,
                                    description: listCorres[index].email!);
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
      isMobile
          ? Container()
          : Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Container(
                    child: BlocBuilder<ChattingCubit, ChattingState>(
                      builder: (context, state) {
                        return AnimatedSwitcher(
                          transitionBuilder: (widget, animation) =>
                              ScaleTransition(
                            scale: animation,
                            child: widget,
                          ),
                          duration: Duration(milliseconds: 1000),
                          child: state.corres == null
                              ? IntroChatting(
                                  key: UniqueKey(),
                                )
                              : Chatting(
                                  user: user,
                                  correspondant: state.corres,
                                  key: UniqueKey(),
                                ),
                        );
                      },
                    ),
                  )),
            ),
      isMobile ? Container() : Profil(user: user),
    ]);
  }
}

class EditProfil extends StatefulWidget {
  const EditProfil({required this.user, Key? key}) : super(key: key);
  final Utilisateur? user;

  @override
  _EditProfilState createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  bool isCharging = false;
  TextEditingController nom = TextEditingController();
  var image;
  final picker = ImagePicker();
  Utilisateur? user;
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

  @override
  void initState() {
    user = widget.user;
    // TODO: implement initState
    super.initState();
  }

  var keyForm = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bool isMobile = MediaQuery.of(context).size.width < 800;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.user!.nom!,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.headline4!.copyWith(
              fontSize: isMobile ? 17 : 20,
              fontWeight: FontWeight.w200,
              color: Colors.white),
        ),
      ),
      body: Form(
        key: keyForm,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                : user!.image != null
                    ? CircleAvatar(
                        radius: 150,
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.3),
                        backgroundImage: NetworkImage(widget.user!.image!),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            FloatingActionButton(
                              backgroundColor: Colors.red,
                              tooltip: 'Supprimer la photo',
                              onPressed: () {
                                setState(() {
                                  user!.image = null;
                                });
                              },
                              child: Icon(Icons.remove,
                                  color:
                                      Get.isDarkMode ? null : Colors.black54),
                            ),
                          ],
                        ),
                      )
                    : CircleAvatar(
                        radius: 150,
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
                                  color:
                                      Get.isDarkMode ? null : Colors.black54),
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
                if (v!.length < 4) return 'Au moins 4 caractères';
                return null;
              },
              style: TextStyle(
                  color: Get.isDarkMode ? Colors.white : Colors.black),
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
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor),
                            onPressed: () async {
                              if (keyForm.currentState!.validate()) {
                                setState(() {
                                  isCharging = true;
                                });
                                // var check = await _auth.enregistrementAuth(
                                //     _email.text, _password.text, nom.text, image);
                                // switch (check) {
                                //   case 'Success':
                                //     Get.rawSnackbar(
                                //         title: 'Inscription réussie',
                                //         message: 'Content de vous voir');
                                //     break;
                                //   case 'Exist':
                                //     _index.value = 0;
                                //     break;
                                //   default:
                                //     _index.value = 0;
                                // }
                                setState(() {
                                  isCharging = false;
                                });
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Modifier',
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
      ),
    );
  }
}

class Profil extends StatelessWidget {
  Profil({
    Key? key,
    required this.user,
  }) : super(key: key);

  final User? user;
  Utilisateur? utilisateur;
  @override
  Widget build(BuildContext context) {
    return Container(
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
                                  utilisateur!.nom![0],
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
                                utilisateur!.image!,
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        utilisateur!.nom!,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        utilisateur!.email!,
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
                        onPressed: () {
                          Get.defaultDialog(
                              title: '',
                              content: EditProfilDialog(
                                user: utilisateur,
                              ));
                        },
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
        ));
  }
}

class Chatting extends StatefulWidget {
  const Chatting({
    required this.user,
    required this.correspondant,
    Key? key,
  }) : super(key: key);
  final Utilisateur? correspondant;
  final User? user;
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

  Rx<double>? progessFile = 0.0.obs;

  final picker = ImagePicker();
  pickAvatar() {
    var image;
    var uploadImage = FileUploadInputElement()..accept = '.jpg,.png,.jpeg';
    uploadImage.click();
    uploadImage.onChange.listen((event) async {
      var file = uploadImage.files!.first;

      var path = basename(file.name);
      FileReader reader = FileReader();
      reader.readAsArrayBuffer(file);

      reader.onLoad.listen((event) async {
        print(event.loaded.toString());
        var ref = FirebaseStorage.instance.ref().child('Image/$path');
        image = reader.result;
        UploadTask task = ref.putData(image);

        task.snapshotEvents.listen((event) {
          progessFile!.value = (event.bytesTransferred / file.size).toDouble();
        });
        task.whenComplete(() async {
          var url = await ref.getDownloadURL();
          isCharging.value = true;
          var message1 = {
            'sender': user!.uid,
            'response': null,
            'vu': true,
            'attachmentType': 'Image',
            'attachment': url,
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
              'attachmentType': 'Image',
              'attachment': url,
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
              progessFile!.value = 0.0;
              messageContent.clear();
            });
          } on Exception catch (e) {
            isCharging.value = false;
          }
        });
      });
    });
  }

  Widget build(BuildContext context) {
    user = widget.user;
    bool isMobile = MediaQuery.of(context).size.width <= 1000;
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
              return Center(
                child: Loading(),
              );
            }
            List<Message> listMessage = [];
            if (snapshot.hasData) {
              for (var i in snapshot.data!.docs) {
                listMessage.add(Message.fromMap(i.data()).copyWith(uid: i.id));
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  listMessage[index].getAttachment(),
                                  listMessage[index].content == ''
                                      ? Container()
                                      : Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                          padding: EdgeInsets.symmetric(
                                              vertical: 6, horizontal: 14),
                                          constraints:
                                              BoxConstraints(maxWidth: 400),
                                          decoration: BoxDecoration(
                                              color:
                                                  Theme.of(context).cardColor,
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(25),
                                                  topRight: Radius.circular(25),
                                                  bottomRight:
                                                      Radius.circular(25))),
                                          child: Text(
                                              listMessage[index].content!,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1),
                                        ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: 1,
                                        bottom: 10,
                                        right: 10,
                                        left: 10),

                                    //constraints: BoxConstraints(maxWidth: 400),

                                    child: Text(
                                        timeago.format(
                                            DateTime.fromMicrosecondsSinceEpoch(
                                                listMessage[index]
                                                    .date!
                                                    .microsecondsSinceEpoch),
                                            locale: 'fr'),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .copyWith(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                tooltip: 'Supprimer',
                                onPressed: () async {
                                  var check = await Get.defaultDialog(
                                    titleStyle:
                                        Theme.of(context).textTheme.headline4,
                                    middleTextStyle:
                                        Theme.of(context).textTheme.bodyText1,
                                    title: 'Suppression',
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
                                    onCancel: () {
                                      Get.back(result: false);
                                    },
                                    confirm: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            elevation: 0, primary: Colors.red),
                                        onPressed: () async {
                                          Get.back(result: true);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3, horizontal: 5),
                                          child: Text(
                                            'Supprimer',
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
                                  if (check) {
                                    await firestoreinstance
                                        .collection('Utilisateur')
                                        .doc(widget.correspondant!.uid)
                                        .collection('Correspondant')
                                        .doc(user!.uid)
                                        .collection('Discussion')
                                        .doc(listMessage[index].uid)
                                        .delete();
                                    await firestoreinstance
                                        .collection('Utilisateur')
                                        .doc(user!.uid)
                                        .collection('Correspondant')
                                        .doc(widget.correspondant!.uid)
                                        .collection('Discussion')
                                        .doc(listMessage[index].uid)
                                        .delete();
                                  }
                                },
                                icon: Icon(Icons.delete_forever_outlined,
                                    size: 20, color: Colors.red)),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                listMessage[index].getAttachment(),
                                listMessage[index].content == ''
                                    ? Container()
                                    : Container(
                                        margin: EdgeInsets.symmetric(
                                            vertical: 2, horizontal: 10),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 6, horizontal: 14),
                                        constraints:
                                            BoxConstraints(maxWidth: 400),
                                        decoration: BoxDecoration(
                                            color: Get.isDarkMode
                                                ? Colors.blue.withOpacity(0.6)
                                                : Theme.of(context)
                                                    .primaryColor
                                                    .withOpacity(0.6),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(25),
                                                topRight: Radius.circular(25),
                                                bottomLeft:
                                                    Radius.circular(25))),
                                        child: Text(
                                          listMessage[index].content!,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!,
                                        ),
                                      ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 1, bottom: 10, right: 10, left: 10),

                                  //constraints: BoxConstraints(maxWidth: 400),

                                  child: Text(
                                      timeago.format(
                                          DateTime.fromMicrosecondsSinceEpoch(
                                              listMessage[index]
                                                  .date!
                                                  .microsecondsSinceEpoch),
                                          locale: 'fr'),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              fontSize: 12,
                                              color: Colors.grey)),
                                ),
                              ],
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
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
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
                                    size: 22, color: Colors.black87))),
                        SizedBox(
                          width: 5,
                        ),
                        Obx(() => progessFile!.value <= 0.0
                            ? IconButton(
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                tooltip: 'Envoyer une image',
                                onPressed: pickAvatar,
                                icon: Icon(
                                  Icons.image_outlined,
                                  color: Get.isDarkMode
                                      ? Colors.blue
                                      : Theme.of(context).primaryColor,
                                ))
                            : SizedBox(
                                height: 35,
                                width: 35,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  value: progessFile!.value,
                                  color: Get.isDarkMode
                                      ? Colors.blue
                                      : Theme.of(context).primaryColor,
                                )))
                      ],
                    )),
            ],
          ),
        ),
      ),
      floatingActionButton: null,
      appBar: AppBar(
        centerTitle: true,
        title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          widget.correspondant!.image == null
              ? Container()
              : InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    Get.to(
                        () => ImageView(image: widget.correspondant!.image!));
                  },
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(widget.correspondant!.image!),
                  ),
                ),
          SizedBox(
            width: 20,
          ),
          Text(
            widget.correspondant!.nom!,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headline4!.copyWith(
                fontSize: isMobile ? 17 : 20,
                fontWeight: FontWeight.w200,
                color: Colors.white),
          ),
        ]),
      ),
    );
  }
}

class ImageView extends StatelessWidget {
  const ImageView({required this.image, Key? key}) : super(key: key);
  final String image;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: null,
      backgroundColor: Colors.black,
      appBar: AppBar(
        excludeHeaderSemantics: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: InteractiveViewer(
        child: Center(child: Image.network(image)),
      ),
    );
  }
}
