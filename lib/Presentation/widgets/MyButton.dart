import 'package:flutter/material.dart';
import 'package:nasooh/app/constants.dart';

class MyButton extends StatelessWidget {
  final onPressedHandler;
  final String? txt;
  final Color? btnColor;
  final Color? txtColor;
  final double? txtSize;
  final bool? isBold;
  final Widget? prefixWidget;
  const MyButton(
      {super.key, this.onPressedHandler,
      this.txt,
      this.btnColor,
      this.txtColor,
      this.txtSize,
      this.isBold,
      this.prefixWidget});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8))),
        textStyle: const TextStyle(fontWeight: FontWeight.normal),
        elevation: 0,
        backgroundColor: btnColor ?? Constants.primaryAppColor,
      ),
      onPressed: onPressedHandler ?? () {},
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prefixWidget ?? const SizedBox(),
            Container(
              margin: const EdgeInsets.all(3),
              child: Text(
                txt ?? "button",
                style: TextStyle(
                    fontWeight:
                        isBold == true ? FontWeight.bold : FontWeight.normal,
                    fontFamily: Constants.mainFont,
                    fontSize: txtSize ?? 14,
                    color: txtColor ?? Constants.whiteAppColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class MyButtonOutlined extends StatelessWidget {
  final void Function()? onPressedHandler;
  final String? txt;
  final Color? btnColor;
  final Color? txtColor;
  final double? txtSize;
  final bool? isBold;
  final Widget? prefixWidget;
  const MyButtonOutlined(
      {super.key, this.onPressedHandler,
        this.txt,
        this.btnColor,
        this.txtColor,
        this.txtSize,
        this.isBold,
        this.prefixWidget});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          textStyle: const TextStyle(fontWeight: FontWeight.normal),
          side: const BorderSide(color: Constants.primaryAppColor)),
      onPressed: onPressedHandler,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            prefixWidget ?? const SizedBox(),
            Container(
              margin: const EdgeInsets.all(3),
              child: Text(
                '$txt',
                style: TextStyle(
                    fontWeight:
                    isBold == true ? FontWeight.bold : FontWeight.normal,
                    fontFamily: Constants.mainFont,
                    fontSize: txtSize ?? 14,
                    color: txtColor ?? Constants.primaryAppColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
