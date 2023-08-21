import 'package:flutter/material.dart';
import 'package:touriso_agent/screens/shared/empty_widget.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class AccommodationSpaceList extends StatelessWidget {
  const AccommodationSpaceList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // future: Future,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return const Center(child: CustomErrorWidget());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 100),
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  Text(
                    'Accommodation Spaces',
                    style: titleLarge(context),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () async {
                      // bool? result = await showFormDialog(
                      //   context,
                      //   const SiteForm(),
                      // );

                      // if (result != null && result) {
                      //   setState(() {});
                      // }
                    },
                    child: const Text('Add accommodation space'),
                  ),
                ],
              ),
            ],
          );
        }

        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      },
    );
  }
}
