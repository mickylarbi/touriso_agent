import 'package:flutter/material.dart';
import 'package:touriso_agent/models/site/site.dart';

class SiteCard extends StatelessWidget {
  const SiteCard({
    super.key,
    required this.site,
  });
  final Site site;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.2), blurRadius: 30)
        ],
        image: site.imageUrls.isEmpty
            ? null
            : DecorationImage(
                image: NetworkImage(site.imageUrls[0]),
                fit: BoxFit.cover,
              ),
        color: Colors.black45,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: site.imageUrls.isEmpty
              ? null
              : LinearGradient(
                  colors: [
                    Colors.black.withOpacity(.05),
                    Colors.black.withOpacity(.05),
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
              site.name,
              maxLines: 3,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              site.location,
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
