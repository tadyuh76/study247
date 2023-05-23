import "package:flutter/material.dart";
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/banner_colors.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/note.dart';
import 'package:studie/screens/note_edit_screen/note_edit_screen.dart';
import 'package:studie/widgets/dialogs/note_settings_dialog.dart';

class NoteWidget extends ConsumerWidget {
  final Note note;
  const NoteWidget({super.key, required this.note});

  bool get hasFolderName => note.folderName != "all";

  void onNoteTab(BuildContext context, WidgetRef ref) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteEditScreen(note: note),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: kMediumPadding),
      child: Material(
        color: bannerColors[note.color],
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: () => onNoteTab(context, ref),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kDefaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        note.title,
                        style: const TextStyle(
                          color: kWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => NoteSettingsDialog.show(context, note),
                      child: SvgPicture.asset(
                        "assets/icons/more.svg",
                        width: 24,
                        height: 24,
                        color: kWhite,
                      ),
                    )
                  ],
                ),
                if (hasFolderName)
                  Text(
                    note.folderName,
                    style: const TextStyle(fontSize: 14, color: kWhite),
                  ),
                const SizedBox(height: kDefaultPadding),
                Text(
                  note.text,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: kWhite, fontSize: 14),
                ),
                const SizedBox(height: kDefaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
