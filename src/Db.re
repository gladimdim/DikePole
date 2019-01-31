let userExists = id =>
  "SELECT COUNT(*) as count FROM users WHERE id = '" ++ id ++ "'";

let createUser = (id, token) =>
  "insert into users VALUES (" ++ id ++ " , " ++ token ++ ")";