import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SnackBarService {
  BuildContext _buildContext;

  static SnackBarService instance = SnackBarService();

  SnackBarService() {}

  set buildContext(BuildContext _context) {
    _buildContext = _context;
  }

  void showSnackBarError(String _message, BuildContext context) {
    Scaffold.of(_buildContext).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(new Radius.circular(12)),
        ),
        content: Text(
          _message,
          style: TextStyle(
              color: Theme.of(context).cardColor.withOpacity(0.85),
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void showSnackBarSuccess(String _message, BuildContext context) {
    Scaffold.of(_buildContext).showSnackBar(
      SnackBar(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.all(
            new Radius.circular(12),
          ),
        ),
        content: Text(
          _message,
          style: TextStyle(
            color: Theme.of(context).cardColor.withOpacity(0.85),
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }
}
