// Generated by BUCKLESCRIPT VERSION 4.0.18, PLEASE EDIT WITH CARE
'use strict';


function userExists(id) {
  return "SELECT COUNT(*) as count FROM users WHERE id = '" + (id + "'");
}

function createUser(id, token) {
  return "insert into users VALUES (" + (id + (" , " + (token + ")")));
}

exports.userExists = userExists;
exports.createUser = createUser;
/* No side effect */