import 'package:flutter/material.dart';
import 'package:studie/constants/breakpoints.dart';
import 'package:studie/constants/colors.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = "/about";
  const AboutScreen({super.key});

  final _normal = const TextStyle(
    fontSize: 16,
    color: kBlack,
    fontFamily: "Quicksand",
    height: 1.5,
  );
  final _bold = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: kBlack,
    fontFamily: "Quicksand",
    height: 1.5,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kWhite,
        elevation: 0,
        automaticallyImplyLeading: true,
        foregroundColor: kBlack,
        // centerTitle: true,
        title: const Text(
          "Về ứng dụng",
          style: TextStyle(
            fontSize: 24,
            color: kBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          "“Study247 - Giải pháp học trực tuyến năng suất, tiện lợi”",
                      style: _bold,
                    ),
                    TextSpan(
                      text:
                          " là nghiên cứu được tiến hành để tìm ra một phương pháp tối ưu giúp học sinh có thể tận dụng tối đa những lợi ích mà internet cũng như các thiết bị di động có thể mang lại cho việc học. Hai vấn đề chính của đề tài nghiên cứu được đề cập tới là:\n",
                      style: _normal,
                    ),
                    TextSpan(
                      text: "1. Tính thúc đẩy tích cực trong học nhóm.\n",
                      style: _bold,
                    ),
                    TextSpan(
                      text:
                          "2. Phương pháp học và ghi nhớ hiệu quả dành cho học sinh.\n",
                      style: _bold,
                    ),
                    TextSpan(
                      text:
                          "Qua quá trình nghiên cứu, khảo sát hai vấn đề trên và tham khảo các nguồn tài liệu khoa học đáng tin cậy trên internet, em đã có kết quả nghiên cứu rất khả quan. Dựa vào đó, em đã phát triển thành công ứng dụng “Study247”. Ứng dụng có các công cụ tập trung tăng khả năng học tập và ghi nhớ cũng như tận dụng lợi ích của việc học nhóm để áp dụng tạo được sự liên kết cho các học sinh có cùng mục tiêu phấn đấu dù ở bất cứ đâu, giúp tăng năng suất và tránh nhàm chán khi học. Ứng dụng có khả năng giải quyết được các vấn đề đã đặt ra và vẫn tiếp tục được cải tiến để đem lại trải nghiệm hoàn thiện nhất cho người dùng.\n",
                      style: _normal,
                    ),
                    TextSpan(
                        text:
                            "\n“Study247” là một ứng dụng giúp học sinh áp dụng được các phương pháp học khoa học, hiệu quả một cách dễ dàng, tiện lợi chỉ trong một ứng dụng với các chức năng tối ưu nhất giúp cải thiện khả năng học ở học sinh. Các phương pháp, chức năng được tích hợp trong ứng dụng đều dựa trên các cơ sở khoa học rõ ràng và đều được chứng minh có hiệu quả tích cực khi áp dụng thực tế. Ứng dụng tạo cơ hội cho học sinh từ nhiều nơi khác nhau, miễn có cùng chung ý tưởng học tập đều có thể tham gia cùng nhau, giúp đỡ nhau trong quá trình học thông qua ứng dụng “Study247”.",
                        style: _normal)
                  ],
                ),
              ),
            ),
            const SizedBox(height: kDefaultPadding),
            Center(
              child: Image.asset("assets/logo.png", width: 120, height: 120),
            ),
            Text(
              "Liên hệ: tadyuh76@gmail.com",
              style: _bold,
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
