import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/note.dart';
import 'package:studie/screens/document_screen/widgets/note_widget.dart';
import 'package:studie/screens/loading_screen/loading_screen.dart';
import 'package:studie/services/db_methods.dart';

class FolderNotesScreen extends StatelessWidget {
  const FolderNotesScreen({super.key, required this.folderName});
  final String folderName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          folderName,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
          ),
        ),
        centerTitle: true,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        foregroundColor: kPrimaryColor,
      ),
      body: StreamBuilder(
        stream: DBMethods().getFoldersNotes(folderName),
        builder: (context, snapshots) {
          if (snapshots.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          }
          if (snapshots.hasData) {
            final notes = snapshots.data!.docs
                .map((e) => Note.fromJson(e.data() as Map<String, dynamic>))
                .toList();

            return ListView.builder(
              itemBuilder: (context, index) {
                return NoteWidget(note: notes[index]);
              },
              padding: const EdgeInsets.all(kDefaultPadding),
              itemCount: notes.length,
            );
          }

          return const Text("Đã có lỗi xảy ra trong quá trình tải ghi chú.");
        },
      ),
    );
  }
}
