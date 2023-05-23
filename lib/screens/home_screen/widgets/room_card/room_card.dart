import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';
import 'package:studie/models/room.dart';
import 'package:studie/screens/home_screen/widgets/room_card/enter_button.dart';
import 'package:studie/screens/home_screen/widgets/room_card/number_of_people.dart';
import 'package:studie/screens/home_screen/widgets/room_card/room_tags.dart';
import 'package:studie/widgets/avatar.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  const RoomCard({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kMediumPadding,
      ),
      decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(blurRadius: 4, color: kShadow)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              renderCardCover(),
              renderUserAvatar(),
              NumberOfPeopleInRoom(
                curParticipants: room.curParticipants,
                maxParticipants: room.maxParticipants,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: kMediumPadding),
                RoomTags(tags: room.tags),
                const SizedBox(height: kMediumPadding),
                Text(
                  room.description,
                  maxLines: 3,
                  style: const TextStyle(color: kTextColor, fontSize: 14),
                ),
                const SizedBox(height: kMediumPadding),
                EnterButton(room: room),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget renderUserAvatar() {
    return Positioned(
      bottom: -20,
      left: 20,
      child: Avatar(radius: 20, photoURL: room.hostPhotoUrl),
    );
  }

  Widget renderCardCover() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 80,
          width: double.infinity,
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(kDefaultPadding),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            color: room.color,
          ),
          child: Text(
            room.name,
            maxLines: 2,
            textScaleFactor: 1,
            style: const TextStyle(
              color: kWhite,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
