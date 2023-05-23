import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/note.dart';
import 'package:studie/screens/document_screen/widgets/note_widget.dart';
import 'package:studie/screens/loading_screen/loading_screen.dart';
import 'package:studie/services/db_methods.dart';
import 'package:studie/widgets/hide_scrollbar.dart';

class NotesTab extends StatelessWidget {
  const NotesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: HideScrollbar(
        child: StreamBuilder(
            stream: DBMethods().getNotes(),
            builder: (context, snapshots) {
              if (snapshots.hasError) {
                return const Text("error");
              } else if (snapshots.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              } else if (!snapshots.hasData) {
                return const Text(
                  "Chưa có tài liệu, tạo tài liệu mới nào!",
                  style: TextStyle(color: kPrimaryColor),
                );
              }

              if (snapshots.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    "Chưa có tài liệu, tạo tài liệu mới nào!",
                  ),
                );
              }
              final notes = snapshots.data!.docs
                  .map((snap) =>
                      Note.fromJson(snap.data() as Map<String, dynamic>))
                  .toList();

              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(kDefaultPadding),
                itemCount: notes.length,
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
                        NoteWidget(note: notes[0]),
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

                  return NoteWidget(note: notes[index]);
                },
              );
            }),
      ),
    );
  }
}
