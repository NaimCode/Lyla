import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:social_message/widget/constant.dart';

import 'data/internal.dart';
import 'model/class.dart';

Rx<Widget?> DiscussionContent = null.obs;
Utilisateur? corresGlobal = Utilisateur(nom: 'Naim Abdelkerim', uid: naimUid);
