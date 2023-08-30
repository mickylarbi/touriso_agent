import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:touriso_agent/screens/home/blog/article_image.dart';
import 'package:touriso_agent/utils/functions.dart';
import 'package:touriso_agent/utils/text_styles.dart';

class ArticlesImagesManager extends StatefulWidget {
  const ArticlesImagesManager({
    super.key,
    required this.imageUrlsNotifier,
    required this.newImagesNotifier,
  });
  final ValueNotifier<List<String>> imageUrlsNotifier;
  final ValueNotifier<List<XFile>> newImagesNotifier;

  @override
  State<ArticlesImagesManager> createState() => _ArticlesImagesManagerState();
}

class _ArticlesImagesManagerState extends State<ArticlesImagesManager> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.imageUrlsNotifier,
      builder: (BuildContext context, value, Widget? child) {
        if (value.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(left: 24),
            child: TextButton(
              onPressed: () async {
                pickImage();
              },
              child: const Text('Add images'),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Images', style: titleSmall(context)),
            ),
            SizedBox(
              height: 100,
              child: Row(
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: widget.imageUrlsNotifier.value.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(width: 12);
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            expandImage(
                              context,
                              widget.imageUrlsNotifier.value[index],
                              () {
                                List<XFile> tmp = [
                                  ...widget.newImagesNotifier.value
                                ];
                                tmp.removeWhere((element) =>
                                    element.path ==
                                    widget.imageUrlsNotifier.value[index]);
                                widget.newImagesNotifier.value = [...tmp];

                                List<String> temp = [
                                  ...widget.imageUrlsNotifier.value
                                ];
                                temp.remove(
                                    widget.imageUrlsNotifier.value[index]);
                                widget.imageUrlsNotifier.value = [...temp];
                                context.pop();
                              },
                            );
                          },
                          child: ArticleImage(
                              imagePath: widget.imageUrlsNotifier.value[index]),
                        );
                      },
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      pickImage();
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();

      XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        widget.newImagesNotifier.value = [
          ...widget.newImagesNotifier.value,
          pickedImage
        ];

        widget.imageUrlsNotifier.value = [
          ...widget.imageUrlsNotifier.value,
          pickedImage.path
        ];
      }
    } catch (e) {
      //
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
