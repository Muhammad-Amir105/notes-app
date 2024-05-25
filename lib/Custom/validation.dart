class FieldValidator {
  static String? validateEmail(String value) {
    if (value.isEmpty) {
      return 'Email is Required';
    }
    if (!RegExp(r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
        .hasMatch(value)) {
      return 'Please enter a valid Email';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password is too short";
    return null;
  }

  static String? validatePasswordMatch(String value, String pass2) {
    if (value.isEmpty) return "Confirm password is required";
    if (value != pass2) {
      return "Password doesn't match";
    }
    return null;
  }

  static String? validateName(String value) {
    if (value.isEmpty) return "First name is required";
    if (value.length <= 2) {
      return "First name is too short";
    }

    return null;
  }

  static String? addTaskName(String value) {
    if (value.isEmpty) return "Task name is required";

    return null;
  }

  static String? validateLastName(String value) {
    if (value.isEmpty) return "Last name is required";
    if (value.length <= 1) {
      return "Last name is too short";
    }

    return null;
  }

  static String? validatePinCode(String? value) {
    if (value!.isEmpty) {
      return "Incorrect PIN CODE";
    }
    return null;
  }

  static String? validatePhoneNumber(String value) {
    if (value.isEmpty) return "Phone number is required";
    Pattern pattern = r'(^(?:[+0]9)?[0-9]{9,20}$)';
    RegExp regex = RegExp(pattern.toString());
    if (!regex.hasMatch(value.trim())) {
      return "Please enter a valid phone number";
    }
    return null;
  }
}
