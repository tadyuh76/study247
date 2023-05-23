import "package:flutter/material.dart";
import "package:studie/constants/colors.dart";

class SettingsScreen extends StatelessWidget {
  static const routeName = "/settings";
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        automaticallyImplyLeading: true,
        foregroundColor: kBlack,
        title: const Text(
          "Cài đặt",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: kBlack,
            fontSize: 24,
          ),
        ),
      ),
      body: const Center(
        child: Text(
          "Đang phát triển...",
          style: TextStyle(),
        ),
      ),
    );
  }
}
