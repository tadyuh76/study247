import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/banner_colors.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/note.dart';
import 'package:studie/screens/select_folder_screen/select_folder_screen.dart';
import 'package:studie/services/db_methods.dart';
import 'package:studie/widgets/auth/auth_text_button.dart';

class NoteSettingsDialog extends StatefulWidget {
  const NoteSettingsDialog({super.key, required this.note});
  final Note note;

  static void show(BuildContext context, Note note) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (context) => NoteSettingsDialog(note: note),
    );
  }

  @override
  State<NoteSettingsDialog> createState() => _NoteSettingsDialogState();
}

class _NoteSettingsDialogState extends State<NoteSettingsDialog> {
  String color = "";
  String curFolder = "";

  @override
  void initState() {
    color = widget.note.color;
    curFolder = widget.note.folderName;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          decoration: const BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Chỉnh sửa ghi chú",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kBlack,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: kDefaultPadding),
              const SizedBox(height: kDefaultPadding),
              _renderOption(
                  curFolder == "all" ? "Chọn thư mục" : curFolder, "folder_add",
                  () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SelectFolderScreen(
                      noteId: widget.note.id,
                      onTap: (folderName) =>
                          setState(() => curFolder = folderName),
                    ),
                  ),
                );
              }),
              _renderOption("Đổi màu ghi chú", "color"),
              GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: kMediumPadding,
                  crossAxisSpacing: kMediumPadding,
                ),
                itemCount: bannerColors.length,
                itemBuilder: (context, index) {
                  final curColor = bannerColors.keys.toList()[index];

                  return GestureDetector(
                    onTap: () => setState(() => color = curColor),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(backgroundColor: bannerColors[curColor]),
                        if (color == curColor)
                          const Positioned(
                            bottom: 6,
                            right: 6,
                            child: Icon(
                              Icons.check_circle,
                              size: 12,
                              color: kDarkGrey,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: kDefaultPadding),
              CustomTextButton(
                onTap: () {
                  DBMethods().editNote(widget.note.id, color, curFolder);
                  Navigator.of(context).pop();
                },
                text: "Xác nhận",
                large: true,
                primary: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _renderOption(String text, String iconName, [VoidCallback? onTap]) {
    bool canTap = onTap != null;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: kDefaultPadding),
        child: Row(
          children: [
            SvgPicture.asset(
              "assets/icons/$iconName.svg",
              width: 32,
              height: 32,
              color: kBlack,
            ),
            const SizedBox(width: kDefaultPadding),
            Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kBlack,
              ),
            ),
            const Spacer(),
            if (canTap)
              const Icon(
                Icons.chevron_right,
                size: 24,
                color: kBlack,
              )
          ],
        ),
      ),
    );
  }
}
