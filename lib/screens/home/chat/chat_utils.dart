import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';

CollectionReference chatsCollection = firestore.collection('chats');
DocumentReference chatDocument(uid) => chatsCollection.doc(uid);
