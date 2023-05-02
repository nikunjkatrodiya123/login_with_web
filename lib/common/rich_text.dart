import 'package:flutter/material.dart';

class CommonRichText extends StatelessWidget {
  final String? text1;
  final String? text2;

  const CommonRichText({Key? key, this.text1, this.text2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text1 ?? " ",
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: text2 ?? "",
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w400,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
