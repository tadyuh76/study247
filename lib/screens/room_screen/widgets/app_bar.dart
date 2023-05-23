import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/providers/room_provider.dart';
import 'package:studie/screens/room_screen/widgets/participants_settings_dialog.dart';
import 'package:studie/services/auth_methods.dart';
import 'package:url_launcher/url_launcher.dart';

class RoomAppBar extends StatelessWidget {
  final String roomName;
  const RoomAppBar({super.key, required this.roomName});

  Future<void> _onReport() async {
    final Uri uri = Uri.parse("https://forms.gle/R7xViLTShrEZ7qWs9");
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      print("err launching web");
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      foregroundColor: kTextColor,
      backgroundColor: kWhite,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              roomName,
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: const TextStyle(
                fontFamily: 'Quicksand',
                color: kTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: kDefaultPadding),
          GestureDetector(
            onTap: _onReport,
            child: const Icon(
              Icons.report_problem_rounded,
              color: kBlack,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          Consumer(builder: (context, ref, _) {
            final hostUid = ref.read(roomProvider).room!.hostUid;
            final userUid = AuthMethods().user!.uid;

            if (userUid == hostUid) {
              return GestureDetector(
                onTap: () => ParticipantsSettingsDialog.show(context),
                child: SvgPicture.asset(
                  "assets/icons/more.svg",
                  width: 32,
                  height: 32,
                ),
              );
            }
            return const SizedBox.shrink();
          }),
          // Container(
          //   height: 30,
          //   padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          //   decoration: BoxDecoration(
          //     color: kPrimaryColor,
          //     borderRadius: BorderRadius.circular(10),
          //   ),
          //   child: GestureDetector(
          //     onTap: () {},
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         SvgPicture.asset(
          //           'assets/icons/add_people.svg',
          //           color: kWhite,
          //         ),
          //         const SizedBox(width: kSmallPadding),
          //         const Text(
          //           'Mời',
          //           style: TextStyle(
          //             color: kWhite,
          //             fontWeight: FontWeight.bold,
          //             fontSize: 14,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
