import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

String uid = auth.currentUser!.uid;

CollectionReference companiesCollection = firestore.collection('companies');
CollectionReference sitesCollection = firestore.collection('sites');
CollectionReference activitiesCollection = firestore.collection('activities');

Reference logosRef(String companyId) => storage.ref('logos/$companyId');
Reference imagesRef(String entityId) => storage.ref(entityId);
