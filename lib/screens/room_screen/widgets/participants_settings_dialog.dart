import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/room.dart';
import 'package:studie/providers/room_provider.dart';
import 'package:studie/services/db_methods.dart';
import 'package:studie/utils/show_snack_bar.dart';
import 'package:studie/widgets/form/number_input.dart';

class ParticipantsSettingsDialog extends StatelessWidget {
  ParticipantsSettingsDialog({super.key});
  final _controller = TextEditingController();

  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.3),
      barrierDismissible: true,
      builder: (context) => ParticipantsSettingsDialog(),
    );
  }

  Future<void> _onSubmit(BuildContext context, Room room,
      [bool mounted = true]) async {
    try {
      await DBMethods().updateMaxParticipants(
        context,
        room.id,
        room.curParticipants,
        room.maxParticipants,
        int.parse(_controller.text),
      );
      if (mounted) showSnackBar(context, "Thay đổi thành công");
    } catch (e) {
      showSnackBar(
        context,
        "Đã xảy ra lỗi khi điều chỉnh số người tham gia tối đa.",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 60,
          right: kDefaultPadding,
          left: kDefaultPadding,
        ),
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Consumer(
              builder: (context, ref, _) {
                final room = ref.read(roomProvider).room!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                        child: NumberInput(
                          controller: _controller,
                          hintText: "${room.maxParticipants}",
                          title: "Số người tham gia tối đa",
                        ),
                      ),
                    ),
                    const SizedBox(height: kDefaultPadding),
                    GestureDetector(
                      onTap: () => _onSubmit(context, room),
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: kPrimaryColor,
                        ),
                        child: const Text(
                          "Xác nhận",
                          style: TextStyle(
                            color: kWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
