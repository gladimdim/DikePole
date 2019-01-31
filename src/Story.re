type tPid = string;
type tNextStory = {
  pid: tPid,
  name: string,
};

type tStoryNode = {
  text: string,
  pid: tPid,
  background: option(string),
  links: option(list(tNextStory)),
};

type tStory = {passages: list(tStoryNode)};

let decodeNextStory = jsonNext =>
  Json.Decode.{
    pid: jsonNext |> field("pid", string),
    name: jsonNext |> field("name", string),
  };

let decodeStep = jsonStory =>
  Json.Decode.{
    text: jsonStory |> field("text", string),
    pid: jsonStory |> field("pid", string),
    links: jsonStory |> optional(field("links", list(decodeNextStory))),
    background: jsonStory |> optional(field("background", string)),
  };

let decodeStory = (json): tStory => {
  Json.Decode.{passages: json |> field("passages", list(decodeStep))};
};

let rec getTextForPid = (pid, passages) => {
  switch (passages) {
  | [] =>
    Js.log("lol");
    "";
  | [h, ..._t] when h.pid == pid => h.text
  | [_h, ...t] => getTextForPid(pid, t)
  };
};

let rec getNextForPid = (pid, passages) => {
  Js.log();
  switch (passages) {
  | [] => None
  | [h, ..._t] when h.pid == pid => h.links
  | [_h, ...t] => getNextForPid(pid, t)
  };
};

let getStoryNodeByPid = (story, pid) => {
  Js.log(pid);
  let rec findPassage = passages => {
    switch (passages) {
    | [] => raise(Not_found)
    | [h, ...t] when h.pid == pid => h
    | [_h, ...t] => findPassage(t)
    };
  };
  findPassage(story.passages);
};