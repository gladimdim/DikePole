open Cohttp;
open Cohttp_lwt_unix;
open Lwt.Infix;

module Cohttp_Response = Response;
module Response = {
  type t = {
    status: int,
    text: unit => Lwt.t(string),
  };
};

let fetch = (url: string) => {
  let%lwt (resp, body) = Client.get(Uri.of_string(url));
  body
  |> Cohttp_lwt.Body.to_string
  >|= (
    body => {
      body;
    }
  );
};