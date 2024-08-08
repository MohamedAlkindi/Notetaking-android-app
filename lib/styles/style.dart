import 'package:flutter/material.dart';

// if it returns a widget then put it in a method, otherwise use variables for styles.
class AppStyle {
  static Container mainTextContainer(
      String containerText, double lM, double tM, double rM, double bM) {
    return Container(
      margin: EdgeInsets.fromLTRB(lM, tM, rM, bM),
      child: Text(
        '$containerText!',
        style: const TextStyle(
          fontSize: 26,
          fontFamily: 'Georgia',
          color: Color.fromARGB(255, 73, 70, 70),
        ),
      ),
    );
  }

  static Text secondButtonTextAndStyle(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        color: Color.fromARGB(255, 73, 70, 70),
      ),
    );
  }

  static const backgroundImg = BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/bg.png'),
      fit: BoxFit.cover,
    ),
  );

  static Container emailContainer({
    required BuildContext context,
    required FocusNode? focuseNode,
    required TextEditingController email,
  }) {
    return Container(
      width: 450,
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 15),
      child: TextField(
        style: const TextStyle(
          color: Color.fromARGB(255, 73, 70, 70),
          fontSize: 18,
        ),
        autofocus: true,
        keyboardType: TextInputType.emailAddress,
        enableSuggestions: false,
        autocorrect: false,
        controller: email,
        decoration: AppStyle.emailInputDecoration,
        textInputAction: TextInputAction.next,
        onSubmitted: (term) {
          FocusScope.of(context).requestFocus(focuseNode);
        },
      ),
    );
  }

  static const emailInputDecoration = InputDecoration(
    hintText: 'Enter Email ',
    hintStyle: TextStyle(
      color: Color.fromARGB(255, 100, 99, 99),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
      borderSide: BorderSide(
        color: Color.fromARGB(255, 131, 58, 66),
        width: 0.7,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Color.fromARGB(255, 131, 58, 66),
        width: 0.5,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
    ),
    suffixIcon: Icon(
      Icons.email,
      color: Color.fromARGB(255, 73, 70, 70),
    ),
  );

  // cant use the same as the email because i have a variable and setState()

  static Container passwordContainer({
    required BuildContext context,
    required String textFieldText,
    required bool isObsecureText,
    required TextEditingController passwordController,
    required FocusNode thisFocusNode,
    required FocusNode? nextFocusNode,
    required TextInputAction textInputActionValue,
    required VoidCallback togglePasswordVisibility,
  }) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 15),
      width: 450,
      child: TextField(
        style: const TextStyle(
          color: Color.fromARGB(255, 73, 70, 70),
          fontSize: 18,
        ),
        obscureText: isObsecureText,
        enableSuggestions: false,
        autocorrect: false,
        controller: passwordController,
        decoration: InputDecoration(
          hintText: textFieldText,
          hintStyle: const TextStyle(
            color: Color.fromARGB(255, 100, 99, 99),
          ),
          enabledBorder: AppStyle.passwordEnabledBorder,
          focusedBorder: AppStyle.passwordFocusedBorder,
          suffixIcon: IconButton(
            color: const Color.fromARGB(255, 73, 70, 70),
            onPressed: togglePasswordVisibility,
            icon: const Icon(
              Icons.remove_red_eye,
            ),
          ),
        ),
        focusNode: thisFocusNode,
        textInputAction: textInputActionValue,
        onSubmitted: (term) {
          FocusScope.of(context).requestFocus(nextFocusNode);
        },
      ),
    );
  }

  static const passwordEnabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
    borderSide: BorderSide(
      color: Color.fromARGB(255, 131, 58, 66),
      width: 0.7,
    ),
  );

  static const passwordFocusedBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Color.fromARGB(255, 131, 58, 66),
      width: 0.5,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  );
}
