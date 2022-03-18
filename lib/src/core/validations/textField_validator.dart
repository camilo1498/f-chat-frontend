// ignore_for_file: file_names

RegExp _emailRegex = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

RegExp _uppercase = RegExp(r"(?=.*[a-z])(?=.*[A-Z])\w+");

RegExp _specialChar = RegExp(r"^(.*?[$&+,\:;/=?@#|'<>.^*()_%!-]){1,}");

RegExp _number = RegExp('^(.*?[0-9]){1,}');

RegExp _onlyNumber = RegExp('^(.*?[0-9])');

/// Check if string [input] is an email
bool isEmail(String input) {
  if (input.toString().length > 254) {
    return false;
  }
  var valid = _emailRegex.hasMatch(input);
  if (!valid) {
    return false;
  }

  var parts = input.toString().split('@');
  if (parts[0].length > 64) {
    return false;
  }

  var domainParts = parts[1].split(".");
  if (domainParts.every((part) => part.length > 63)) {
    return false;
  }

  return true;
}

bool isPassword(String input) {
  var validUppercase = _uppercase.hasMatch(input);
  var validSpecialChar = _specialChar.hasMatch(input);
  var validNumber = _number.hasMatch(input);

  if (input.length < 8) {
    return false;
  } else if (!validUppercase) {
    return false;
  } else if (!validSpecialChar) {
    return false;
  } else if (!validNumber) {
    return false;
  } else {
    return true;
  }
}

bool isText(String input) {
  if (input.length < 3) {
    return false;
  } else {
    return true;
  }
}

bool isPhone(String input) {
  if (input.length < 6 && !_onlyNumber.hasMatch(input)) {
    return false;
  } else {
    return true;
  }
}
