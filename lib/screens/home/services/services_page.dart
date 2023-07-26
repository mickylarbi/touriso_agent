import 'package:flutter/material.dart';
import 'package:touriso_agent/screens/home/services/site/site_list.dart';
import 'package:touriso_agent/screens/shared/page_layout.dart';
import 'package:touriso_agent/utils/colors.dart';

class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  ValueNotifier<int> pageNotifier = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      sectioned: true,
      appBarExtended: true,
      title: 'Services',
      appBarExtension: ValueListenableBuilder(
        valueListenable: pageNotifier,
        builder: (context, value, _) {
          return Row(
            children: List.generate(
              pages.length,
              (index) => GestureDetector(
                onTap: () {
                  pageNotifier.value = index;
                },
                child: Container(
                  width: 100,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                          width: 3,
                          color: value == index
                              ? primaryColor
                              : Colors.transparent),
                    ),
                  ),
                  child: Text(
                    pages[index],
                    style: index == value
                        ? const TextStyle(color: primaryColor)
                        : null,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      body: PageView(
        children: [SiteList()],
      ),
    );
  }

  @override
  void dispose() {
    pageNotifier.dispose();
    super.dispose();
  }
}

// class SitesSection extends StatelessWidget {
//   const SitesSection({
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Section(
//       titleText: 'Sites',
//       actions: [
//         TextButton.icon(
//           onPressed: () {
//             showFormDialog(context, const SiteForm());
//           },
//           icon: const Icon(Icons.add),
//           label: const Text('Add site'),
//         ),
//       ],
//       child: FutureBuilder(
//           future: sitesCollection.get(),
//           builder: (context, snapshot) {
//             if (snapshot.hasError) {
//               return const Center(child: CustomErrorWidget());
//             }

//             if (snapshot.connectionState == ConnectionState.done) {
//               List<Site> sites = snapshot.data!.docs
//                   .map((e) =>
//                       Site.fromFirebase(e.data() as Map<String, dynamic>, e.id))
//                   .toList();

//               return SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Column(
//                   children: [
//                     ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: sites.length,
//                       itemBuilder: (BuildContext context, int index) {
//                         Site site = sites[index];

//                         return Container(
//                           alignment: Alignment.centerLeft,
//                           height: 40,
//                           color: index % 2 == 0
//                               ? Colors.grey[300]
//                               : Colors.grey[100],
//                           child: RowView(
//                             texts: [
//                               site.name,
//                               site.location,
//                               site.geoLocation.toString(),
//                               site.description
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             }

//             return const Center(child: CircularProgressIndicator());
//           }),
//     );
//   }
// }

List<String> pages = ['Services', 'Hotel', 'Apartment', 'Flight', 'Bus'];

//  ConstrainedBox(
//                 constraints: const BoxConstraints(maxHeight: 500),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   scrollDirection: Axis.horizontal,
//                   itemBuilder: (context, index) => Container(
//                     color: index % 2 == 0 ? Colors.grey[300] : Colors.grey[100],
//                     child: Row(
//                       children: [
//                         SizedBox(
//                           width: 100,
//                           child: Text(sites[index].name),
//                         )
//                       ],
//                     ),
//                   ),
//                 ))

