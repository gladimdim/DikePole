type tPid = string;
type tNextStory = {
    pid: tPid,
    name: string,
};

type tStoryNode = {
    text: string,
    pid: tPid,
    links: option(list(tNextStory)),
};

type tStory = {
    passages: list(tStoryNode)
};

let decodeNextStory = jsonNext => 
    Json.Decode.{
        pid: jsonNext |> field("pid", string),
        name: jsonNext |> field("name", string),
};

let decodeStep = jsonStory =>
    Json.Decode.{
        text: jsonStory |> field("text", string),
        pid: jsonStory |> field("pid", string),
        links: jsonStory |> optional(field("links", list(decodeNextStory)))
}

let decodeStory = (json) : tStory => {
    Json.Decode.{
        passages: json |> field("passages", list(decodeStep))
        }
};

let rec getTextForPid = (pid, passages) => {
    switch passages {
        | [] => Js.log("lol"); ""
        | [h, ..._t] when (h.pid == pid) => h.text
        | [_h, ...t] => getTextForPid(pid, t)
    }
}

let rec getNextForPid = (pid, passages) => {
    switch passages {
        | [] => None 
        | [h, ..._t] when (h.pid == pid) => h.links
        | [_h, ...t] => getNextForPid(pid, t)
    }
}
