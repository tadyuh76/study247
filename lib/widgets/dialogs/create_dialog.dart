import "package:flutter/material.dart";
import "package:studie/constants/banner_colors.dart";
import "package:studie/constants/breakpoints.dart";
import "package:studie/constants/colors.dart";
import "package:studie/services/db_methods.dart";
import "package:studie/utils/show_snack_bar.dart";
import "package:studie/widgets/auth/auth_text_button.dart";
import "package:studie/widgets/dialogs/custom_dialog.dart";

class CreateDialog extends StatefulWidget {
  const CreateDialog({
    super.key,
    required this.onCreateFolder,
    required this.onCreateNote,
  });
  final VoidCallback onCreateFolder;
  final VoidCallback onCreateNote;

  static void show(BuildContext context) {
    CreateDialog.show(context);
  }

  @override
  State<CreateDialog> createState() => _CreateDialogState();
}

class _CreateDialogState extends State<CreateDialog> {
  bool creatingFolder = false;
  String color = "blue";
  final folderNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: "Tạo mới",
      child: creatingFolder ? _renderFolderContent() : _renderBaseContent(),
    );
  }

  Widget _renderFolderContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Tên thư mục",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: folderNameController,
        ),
        const SizedBox(height: kDefaultPadding),
        const Text(
          "Chọn màu thư mục",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: kMediumPadding),
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
                  CircleAvatar(
                    backgroundColor: bannerColors[curColor],
                    radius: 20,
                  ),
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
          text: "Tạo thư mục",
          onTap: () {
            if (folderNameController.text.trim().isEmpty && mounted) {
              showSnackBar(context, "Tên thư mục không được để trống !");
            }
            DBMethods().createFolder(folderNameController.text, color);
          },
          primary: true,
          large: true,
        ),
      ],
    );
  }

  Widget _renderBaseContent() {
    return Column(
      children: [
        CustomTextButton(
          text: "Tạo thư mục",
          onTap: () => setState(() {
            creatingFolder = true;
          }),
          primary: true,
        ),
        const SizedBox(height: kDefaultPadding),
        CustomTextButton(
          text: "Tạo ghi chú",
          onTap: widget.onCreateNote,
          primary: true,
        ),
      ],
    );
  }
}
