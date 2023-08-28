import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:touriso_agent/models/article.dart';
import 'package:touriso_agent/screens/home/blog/article_details.dart';
import 'package:touriso_agent/screens/home/blog/articles_side_bar.dart';
import 'package:touriso_agent/utils/colors.dart';
import 'package:touriso_agent/utils/dialogs.dart';
import 'package:touriso_agent/utils/firebase_helper.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class BlogDash extends StatefulWidget {
  const BlogDash({super.key});

  @override
  State<BlogDash> createState() => _BlogDashState();
}

class _BlogDashState extends State<BlogDash> {
  final GlobalKey<PopupMenuButtonState> _menuKey =
      GlobalKey<PopupMenuButtonState>();

  final ValueNotifier<Article?> selectedArticleNotifier =
      ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: borderColor)),
              color: Colors.grey[50],
            ),
            child: Row(
              children: [
                Image.asset('assets/images/TOURISO 2.png', height: 40),
                const Spacer(),
                PopupMenuButton(
                  key: _menuKey,
                  itemBuilder: (context) => <PopupMenuEntry>[
                    const PopupMenuItem(
                      value: 'Log out',
                      child: Row(
                        children: [
                          Icon(Icons.logout),
                          SizedBox(width: 20),
                          Text('Log out'),
                        ],
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    showConfirmationDialog(
                      context,
                      message: 'Log out?',
                      confirmFunction: () async {
                        await auth.signOut();
                        context.go('/login');
                      },
                    );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: FutureBuilder(
                    future: writersCollection.doc(uid).get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text(snapshot.error.toString());
                      }

                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic> writerMap =
                            snapshot.data!.data() as Map<String, dynamic>;

                        return InkWell(
                          onTap: () {
                            _menuKey.currentState!.showButtonMenu();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              border:
                                  Border(left: BorderSide(color: borderColor)),
                              color: Colors.grey[50],
                            ),
                            child: Row(
                              children: [
                                if (writerMap['pictureUrl'] != null)
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(writerMap['pictureUrl']),
                                    backgroundColor: Colors.grey[200],
                                  ),
                                if (writerMap['pictureUrl'] != null)
                                  const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(writerMap['name']),
                                    Text(
                                      writerMap['email'],
                                      style: bodySmall(context),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 20),
                                const Icon(Icons.arrow_drop_down),
                              ],
                            ),
                          ),
                        );
                      }

                      return Container();
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 300,
                  padding: const EdgeInsets.all(24),
                  child: ArticlesSideBar(
                      selectedArticleNotifier: selectedArticleNotifier),
                ),
                const VerticalDivider(width: 0),
                Expanded(
                  child: ValueListenableBuilder(
                    valueListenable: selectedArticleNotifier,
                    builder: (context, value, child) {
                      return ArticleDetailsPage(article: value);
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    selectedArticleNotifier.dispose();
    super.dispose();
  }
}
