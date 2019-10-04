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
  | "steppe" => Steppe
  | "landing" => Landing
  | "bulrush" => Bulrush
  | "boat" => Boat
  | "river" => River
  | "cossack" => Cossacks
  | _ => Bulrush
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

module Decode = {
  let title = input =>
    input |> Json.Decode.field("title", Json.Decode.string);
  let description = input =>
    input |> Json.Decode.field("description", Json.Decode.string);
  let authors = input =>
    input |> Json.Decode.field("authors", Json.Decode.string);
  let node = (input): node => {
    text: Json.Decode.field("text", Json.Decode.string, input),
    imageType:
      Json.Decode.optional(
        Json.Decode.field("imageType", Json.Decode.string),
        input,
      )
      |> (
        value => {
          switch (value) {
          | Some(v) => Some(imageTypeFromString(v))
          | None => None
          };
        }
      ),
  };

  let rec page = (input): page => {
    endType:
      Json.Decode.optional(
        Json.Decode.field("endType", Json.Decode.string),
        input,
      ),
    nodes: Json.Decode.field("nodes", Json.Decode.array(node), input),
    next: Json.Decode.field("next", Json.Decode.array(fnPageNext), input),
  }
  and fnPageNext = (input): pageNext => {
    text: Json.Decode.field("text", Json.Decode.string, input),
    nextPage: Json.Decode.field("nextPage", page, input),
  };

  let root = input => input |> Json.Decode.field("root", page);
};

exception CouldNotParse(string);

let fromJSON = (input): gladStory => {
  switch (input) {
  | Some(value) => {
      title: Decode.title(value),
      description: Decode.description(value),
      authors: Decode.authors(value),
      root: Decode.root(value),
    }
  | None => CouldNotParse("Glad Story JSON is invalid") |> raise
  };
};