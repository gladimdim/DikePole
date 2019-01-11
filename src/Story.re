type tNextStory = {
    target: int,
    text: string,
};

type tStoryNode = {
    text: string,
    id: int,
    next: list(tNextStory),
};
type tStory = list(tStoryNode);

let decodeNextStory = jsonNext => 
    Json.Decode.{
        target: jsonNext |> field("target", int),
        text: jsonNext |> field("text", string),
};

let decodeStep = jsonStory =>
    Json.Decode.{
        text: jsonStory |> field("text", string),
        id: jsonStory |> field("id", int),
        next: jsonStory |> field("next", list(decodeNextStory))
}

let decodeStory = (json) : tStory => json |> Json.Decode.list(decodeStep)

let rec getTextForId = (id, story) => {
    switch story {
        | [] => Js.log("lol"); ""
        | [h, ..._t] when (h.id == id) => h.text
        | [_h, ...t] => getTextForId(id, t)
    }
}

let rec getNextForId = (id, story) => {
    switch story {
        | [] => Js.log("empty"); []
        | [h, ..._t] when (h.id == id) => h.next
        | [_h, ...t] => getNextForId(id, t)
    }
}