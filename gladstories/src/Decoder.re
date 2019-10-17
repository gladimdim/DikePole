open GladStory;

let title = input => input |> Json.Decode.field("title", Json.Decode.string);
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

exception CouldNotParse(string);

let fromJSON = (input): gladStory => {
  switch (input) {
  | Some(value) => {
      title: title(value),
      description: description(value),
      authors: authors(value),
      root: root(value),
    }
  | None => CouldNotParse("Glad Story JSON is invalid") |> raise
  };
};