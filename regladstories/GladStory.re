open Yojson.Basic;
open Yojson.Basic.Util;

type tImageType =
  | Camp
  | Steppe
  | Landing
  | Forest
  | Bulrush
  | Boat
  | River
  | Cossacks;

let imageTypeFromString = input => {
  switch (input) {
  | "forest" => Forest
  | "camp" => Camp
  | "steppe" => Camp // shadowed
  | "landing" => Landing
  | "bulrush" => Bulrush
  | "boat" => Boat
  | "river" => River
  | "cossacks" => Camp // shadowed
  | _ => Bulrush
  };
};

let imageTypeToString = input => {
  switch (input) {
  | Forest => "forest"
  | Camp => "camp"
  | Steppe => "steppe"
  | Landing => "landing"
  | Bulrush => "bulrush"
  | Boat => "boat"
  | River => "river"
  | Cossacks => "cossacks"
  };
};

type node = {
  text: string,
  imageType: option(tImageType),
};

type page = {
  endType: option(string),
  next: array(pageNext),
  nodes: array(node),
}
and pageNext = {
  text: string,
  nextPage: page,
};

type gladStory = {
  title: string,
  description: string,
  authors: string,
  root: page,
};

let node = (json): node => {
  text: json |> member("text") |> to_string,
  imageType:
    json
    |> member("imageType")
    |> to_string_option
    |> (
      value => {
        switch (value) {
        | Some(v) => Some(imageTypeFromString(v))
        | None => None
        };
      }
    ),
};

let rec page = (json): page => {
  endType: json |> member("endType") |> to_string_option,
  nodes: [||],
  next: [||],
}
and fnPageNext = (json): pageNext => {
  text: json |> member("text") |> to_string,
  nextPage: json |> member("nextPage") |> page,
};
let decodeRoot = json => {
  endType: json |> member("endType") |> to_string_option,
  nodes:
    json |> member("nodes") |> to_list |> List.map(node) |> Array.of_list,
  next:
    json
    |> member("next")
    |> to_list
    |> List.map(fnPageNext)
    |> Array.of_list,
};

let decode = json => {
  json
  |> from_string
  |> (
    json => {
      title: json |> member("title") |> to_string,
      description: json |> member("description") |> to_string,
      authors: json |> member("authors") |> to_string,
      root: json |> member("root") |> decodeRoot,
    }
  );
};

exception CouldNotParse(string);