import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/message.dart';
import 'package:studie/providers/room_provider.dart';
import 'package:studie/screens/loading_screen/loading_screen.dart';
import 'package:studie/services/db_methods.dart';
import 'package:studie/widgets/hide_scrollbar.dart';
import 'package:studie/widgets/message_box.dart';
import 'package:studie/widgets/note_shared.dart';

class ChatsPage extends ConsumerStatefulWidget {
  const ChatsPage({super.key});

  @override
  ConsumerState<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends ConsumerState<ChatsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final _messageController = TextEditingController();

  void sendMessage(String roomId) {
    if (_messageController.text.trim().isEmpty) return;

    DBMethods().sendMessage(_messageController.text.trim(), roomId);
    _messageController.clear();
  }

  Widget _renderEmpty() {
    return const Expanded(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(kDefaultPadding),
            child: Text(
              "Trò chuyện, trao đổi về bài học tại đây !",
              textAlign: TextAlign.center,
              style: TextStyle(color: kBlack, fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final roomId = ref.read(roomProvider).room!.id;

    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return StreamBuilder(
            stream: DBMethods().getMessages(roomId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LoadingScreen();
              }
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isEmpty) return _renderEmpty();

                final messages = snapshot.data!.docs
                    .map((doc) =>
                        Message.fromJson(doc.data() as Map<String, dynamic>))
                    .toList();

                return HideScrollbar(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                    child: ListView.builder(
                      addRepaintBoundaries: false,
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: messages.length,
                      shrinkWrap: true,
                      padding:
                          const EdgeInsets.symmetric(vertical: kDefaultPadding),
                      itemBuilder: (context, index) {
                        final curMsg = messages[index];
                        return curMsg.type == "message"
                            ? MessageBox(message: curMsg)
                            : NoteSharedWidget(messageWithNote: curMsg);
                      },
                    ),
                  ),
                );
              }
              return const Text('Đã có lỗi xảy ra.');
            });
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(
          vertical: kMediumPadding,
          horizontal: kDefaultPadding,
        ).copyWith(bottom: kDefaultPadding),
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _messageController,
                  onSubmitted: (_) => sendMessage(roomId),
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    hintText: 'Tin nhắn...',
                    hintStyle: const TextStyle(fontSize: 14, color: kDarkGrey),
                    filled: true,
                    fillColor: kLightGrey,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(width: 0, style: BorderStyle.none),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: kMediumPadding),
            Consumer(builder: (context, ref, _) {
              return Material(
                color: kPrimaryColor,
                clipBehavior: Clip.hardEdge,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: InkWell(
                  onTap: () => sendMessage(roomId),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/send.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ),
              );
            })
          ],
        ),
      ),
    );
  }
}
