import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

Widget kTextFormField({
  required TextEditingController controller,
  required String label,
  TextInputType? type,
  bool obscure = false,
  IconData? suffixIcon,
  IconData? prefixIcon,
  Function()? onTap,
  required String? Function(String?)validator,
  Function(String)? onChange,
  Function(String)? onSubmit,
  Function()? onSuffixPressed,
}) {
  return TextFormField(
    keyboardType: type,
    obscureText: obscure,
    onChanged: onChange,
    onTap: onTap,
    onFieldSubmitted: onSubmit,
    controller: controller,
    validator: validator,
    decoration: InputDecoration(
      label: Text(label),
      suffixIcon: IconButton(
        icon: Icon(suffixIcon),
        onPressed: onSuffixPressed,
      ),
      prefixIcon: Icon(prefixIcon),
      border: const OutlineInputBorder(),
    ),
  );
}

Widget kButton({
  required Function()? onPressed,
  required String text,
  double height = 50.0,
  double radius = 8.0,
  double width = double.infinity,
  Color color = Colors.blue,
}) {
  return Container(
    width: width,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(radius),
    ),
    child: MaterialButton(
      onPressed: onPressed,
      height: height,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          fontSize: 20.0,
          color: Colors.white,
        ),
      ),
    ),
  );
}

void navigateAndFinish({required BuildContext context, required Widget page}) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
      (route) => false);
}

void navigateTo({required BuildContext context, required Widget page}) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => page,
    ),
  );
}

Future showToast({required String msg, required ToastStates state}) async {
  return await Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastStates {
  SUCCESS,
  ERROR,
  WARNING,
}

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

AppBar kAppBar(
    {required BuildContext context, String? title, List<Widget>? actions}) {
  return AppBar(
    title: Text(title??''),
    titleSpacing:4.0,
    leading: IconButton(
      icon: const Icon(IconBroken.Arrow___Left_2),
      onPressed: () {
        Navigator.pop(context);
      },
    ),
    actions: actions,
  );
}
