import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/folder.dart';
import 'package:studie/screens/document_screen/widgets/folder_widget.dart';
import 'package:studie/screens/loading_screen/loading_screen.dart';
import 'package:studie/services/db_methods.dart';
import 'package:studie/widgets/hide_scrollbar.dart';

class FolderTab extends ConsumerWidget {
  const FolderTab({super.key, this.selecting = false});
  final bool selecting;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: HideScrollbar(
        child: FutureBuilder(
          future: DBMethods().getFolders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingScreen();
            }

            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "Chưa có thư mục, tạo thư mục mới nào!",
                  ),
                );
              }

              final folders = snapshot.data!.docs
                  .map((e) => Folder.fromMap(e.data() as Map<String, dynamic>))
                  .toList();

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(kDefaultPadding),
                itemCount: folders.length,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Gần đây",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kBlack,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: kSmallPadding),
                        FolderWidget(folder: folders[0]),
                        const SizedBox(height: kDefaultPadding),
                        const Text(
                          "Tất cả",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: kBlack,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    );
                  }

                  return FolderWidget(folder: folders[index]);
                },
              );
            }
            return const Center(
              child: Text("Đã có lỗi xảy ra trong quá trình tải thư mục."),
            );
          },
        ),
      ),
    );
  }
}
