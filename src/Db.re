let userExists = id =>
  "SELECT COUNT(*) as count FROM users WHERE id = '" ++ id ++ "'";