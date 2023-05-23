import 'package:flutter/material.dart';
import 'package:studie/screens/home_screen/widgets/create_room_card.dart';
import 'package:studie/screens/home_screen/widgets/rooms_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          // SizedBox(height: kMediumPadding),
          // SearchBar(height: 50, hintText: 'Tìm phòng học', color: kLightGrey),
          // SizedBox(height: kDefaultPadding),
          // ProgressTracker(),
          CreateRoomCard(),
          RoomsSection(),
        ],
      ),
    );
  }
}
