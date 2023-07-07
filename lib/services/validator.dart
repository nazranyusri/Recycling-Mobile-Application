class Validator {
  String? validateFields({
    required String fullName,
    required String email,
    required String contactNo,
    required String location,
    required String username,
    required String password,
  }) {
    if (fullName.isEmpty ||
        email.isEmpty ||
        contactNo.isEmpty ||
        location.isEmpty ||
        username.isEmpty ||
        password.isEmpty) {
      return 'Please fill in all the fields.';
    }

    if (!isEmailValid(email)) {
      return 'Your email is not in the correct format.';
    }

    if (password.length < 6) {
      return 'Password should be 6 characters or more.';
    }

    return null; // Return null if all fields are valid
  }

  bool isEmailValid(String email) {
    final emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(email);
  }
}