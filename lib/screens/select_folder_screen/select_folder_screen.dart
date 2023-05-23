import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/folder.dart';
import 'package:studie/screens/document_screen/widgets/folder_widget.dart';
import 'package:studie/screens/loading_screen/loading_screen.dart';
import 'package:studie/services/db_methods.dart';

class SelectFolderScreen extends StatelessWidget {
  const SelectFolderScreen({
    super.key,
    required this.noteId,
    required this.onTap,
  });
  final String noteId;
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
        centerTitle: true,
        title: const Text(
          "Chọn thư mục",
          style: TextStyle(fontWeight: FontWeight.bold, color: kPrimaryColor),
        ),
      ),
      body: FutureBuilder(
        future: DBMethods().getFolders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }

          if (snapshot.hasData) {
            final folders = snapshot.data!.docs
                .map((e) => Folder.fromMap(e.data() as Map<String, dynamic>))
                .toList();

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(kDefaultPadding),
              itemCount: folders.length,
              itemBuilder: (context, index) {
                return FolderWidget(
                  folder: folders[index],
                  selecting: () {
                    onTap(folders[index].name);
                    Navigator.of(context).pop();
                  },
                );
              },
            );
          }
          return const Center(
            child: Text("Đã có lỗi xảy ra trong quá trình tải thư mục."),
          );
        },
      ),
    );
  }
}
