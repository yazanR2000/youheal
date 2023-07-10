class CurrentUser {
  static final CurrentUser _currentUser = CurrentUser();
  Map<String,dynamic>? userData;
  static CurrentUser? get currentUser => _currentUser;
  static void setUserData(Map<String,dynamic> userData) {
    _currentUser.userData = userData;
  }
}