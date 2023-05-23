import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/message.dart';
import 'package:studie/providers/user_provider.dart';
import 'package:studie/widgets/avatar.dart';

class MessageBox extends ConsumerWidget {
  final Message message;
  const MessageBox({super.key, required this.message});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider).user;
    final isSender = message.senderId == user.uid;
    final screenWidth = MediaQuery.of(context).size.width;
    final messageMaxWidth = screenWidth * 0.7;

    return Padding(
      padding: const EdgeInsets.only(bottom: kSmallPadding),
      child: isSender
          ? Align(
              alignment: Alignment.centerRight,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: messageMaxWidth),
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(kMediumPadding),
                    child: Text(
                      message.text,
                      style: const TextStyle(
                        color: kWhite,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Avatar(photoURL: message.senderPhotoURL, radius: 14),
                const SizedBox(width: kMediumPadding),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: kSmallPadding,
                        bottom: 2,
                      ),
                      child: Text(
                        message.senderName,
                        style: const TextStyle(fontSize: 12, color: kDarkGrey),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: messageMaxWidth),
                      child: Container(
                        padding: const EdgeInsets.all(kMediumPadding),
                        decoration: const BoxDecoration(
                          color: kLightGrey,
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: Text(
                          message.text,
                          style: const TextStyle(
                            color: kBlack,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
    );
  }
}
