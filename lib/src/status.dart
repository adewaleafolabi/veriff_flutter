/// Contains the stasuses that verification session can end with.
enum Status {
  /// Verification session is done successfully.
  done,

  /// Verification session is canceled by user.
  canceled,

  /// Verification session end with an error.
  error
}
