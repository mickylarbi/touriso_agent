
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:touriso_agent/models/site/site.dart';
import 'package:touriso_agent/screens/shared/buttons.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));


     Future<T?> expandImage<T>(context, imagePath, onDelete) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        clipBehavior: Clip.none,
        contentPadding: EdgeInsets.zero,
        content: Image.network(
          imagePath,
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
              child,
          loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress == null
                  ? child
                  : const Center(child: CircularProgressIndicator.adaptive()),
        ),
        actions: [
          IconTextButton(
            onPressed: onDelete,
            color: Colors.red,
            icon: Icons.delete_outline_rounded,
          ),
        ],
      ),
    );
  }

  Future<Site> getSiteFromId(siteId) async {
    DocumentSnapshot siteSnapshot = await sitesCollection.doc(siteId).get();

    return Site.fromFirebase(
        siteSnapshot.data() as Map<String, dynamic>, siteSnapshot.id);
  }