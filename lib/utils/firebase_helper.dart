import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseStorage storage = FirebaseStorage.instance;

String uid = auth.currentUser!.uid;

CollectionReference companiesCollection = firestore.collection('companies');
CollectionReference clientsCollection = firestore.collection('clients');
CollectionReference sitesCollection = firestore.collection('sites');
CollectionReference activitiesCollection = firestore.collection('activities');
CollectionReference bookingsCollection = firestore.collection('bookings');
CollectionReference writersCollection = firestore.collection('writers');
CollectionReference articlesCollection = firestore.collection('articles');

Reference logosRef(String companyId) => storage.ref('logos/$companyId');
Reference picturesRef(String clientId) => storage.ref('pictures/$clientId');
Reference get writerPictureRef => storage.ref('writers/$uid');
Reference imagesRef(String entityId) => storage.ref(entityId);
Reference  articlesImagesRef(articleId) => storage.ref('articlesImages/$articleId');
