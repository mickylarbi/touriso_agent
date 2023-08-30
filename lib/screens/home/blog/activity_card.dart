import 'package:flutter/material.dart';
import 'package:touriso_agent/models/site/activity.dart';
import 'package:touriso_agent/utils/constants.dart';

class ActivityCard extends StatelessWidget {
  const ActivityCard({
    super.key,
    required this.activity,
  });
  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30)
        ],
        image: activity.imageUrls.isEmpty
            ? null
            : DecorationImage(
                image: NetworkImage(activity.imageUrls[0]),
                fit: BoxFit.cover,
              ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: activity.imageUrls.isEmpty
              ? null
              : LinearGradient(
                  colors: [
                    Colors.black.withOpacity(.05),
                    Colors.black.withOpacity(.05),
                    Colors.black.withOpacity(.8),
                    Colors.black.withOpacity(.8),
                    Colors.black.withOpacity(.8),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              activity.name,
              maxLines: 3,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              activity.duration.toString(),
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '$ghanaCedi ${activity.price}',
              maxLines: 1,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
