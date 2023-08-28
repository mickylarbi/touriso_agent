import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Article extends Equatable {
  final String? id;
  final DateTime dateTime;
  final String title;
  final String content;
  final List<String> imageUrls;
  final List<String> siteIds;
  final List<String> activityIds;

  const Article({
    this.id,
    required this.dateTime,
    required this.title,
    required this.content,
    this.imageUrls = const [],
    this.siteIds = const [],
    this.activityIds = const [],
  });

  Article.fromFirebase(Map<String, dynamic> map, String articleId)
      : id = articleId,
        dateTime = DateTime.fromMillisecondsSinceEpoch(
            (map['dateTime'] as Timestamp).millisecondsSinceEpoch),
        title = map['title'],
        content = map['map'],
        imageUrls =
            (map['imageUrls'] as List).map((e) => e.toString()).toList(),
        siteIds = (map['siteIds'] as List).map((e) => e.toString()).toList(),
        activityIds =
            (map['activityIds'] as List).map((e) => e.toString()).toList();

  Map<String, dynamic> toMap() => {
        'dateTime': dateTime,
        'title': title,
        'content': content,
        'imageUrls': imageUrls,
        'siteIds': siteIds,
        'activityIds': activityIds
      };

  @override
  List<Object?> get props => [];
}
