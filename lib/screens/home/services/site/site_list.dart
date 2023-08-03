import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/models/site/site.dart';
import 'package:touriso_agent/screens/home/services/site/site_form.dart';
import 'package:touriso_agent/screens/shared/empty_widget.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';
import 'package:touriso_agent/screens/shared/row_view.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class SiteList extends StatefulWidget {
  const SiteList({super.key});

  @override
  State<SiteList> createState() => _SiteListState();
}

class _SiteListState extends State<SiteList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: sitesCollection.where('companyId', isEqualTo: uid).get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: CustomErrorWidget());
        }

        if (snapshot.connectionState == ConnectionState.done) {
          List<Site> sites = snapshot.data!.docs
              .map((e) =>
                  Site.fromFirebase(e.data() as Map<String, dynamic>, e.id))
              .toList();

          return ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 100),
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  Text(
                    'Tourist sites',
                    style: headlineSmall(context),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () async {
                      bool? result = await showFormDialog(
                        context,
                        const SiteForm(),
                      );

                      if (result != null && result) {
                        setState(() {});
                      }
                    },
                    child: const Text('Add site'),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                height:
                    sites.isEmpty ? null : (50 * sites.length.toDouble()) + 50,
                child: Section(
                  titlePadding: const EdgeInsets.all(0),
                  bodyPadding: const EdgeInsets.all(0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      children: [
                        const RowViewText(
                          texts: [
                            'Name',
                            'Location',
                            'Geo location',
                            'Description',
                          ],
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        sites.isEmpty
                            ? const Center(
                                child: EmptyWidget(),
                              )
                            : Column(
                                children: List.generate(
                                  sites.length,
                                  (index) => InkWell(
                                    onTap: () async {
                                      await context.push(
                                          '/services/site/${sites[index].id}');

                                      setState(() {});
                                    },
                                    child: RowViewText(
                                      texts: [
                                        sites[index].name,
                                        sites[index].location,
                                        sites[index].geoLocation.toString(),
                                        sites[index].description,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
