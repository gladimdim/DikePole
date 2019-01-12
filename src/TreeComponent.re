type state = {
    current: int,
    story: option(Story.tStory),
};

type action =
    | Next(int)
    | Exit
    | LoadStories
    | StartStory(Story.tStory)
    | SetStory(int)

let component = ReasonReact.reducerComponent("Tree");

let make = (_children) => {
    ...component,
    initialState: () => { current: -1, story: None},
    reducer: (action, state) => 
    switch (action) {
        | SetStory(id) => ReasonReact.Update({...state, current: id})
        | StartStory(story) => ReasonReact.Update({current: 0, story: Some(story)})
        | Next(a) => ReasonReact.Update({...state, current: a})
        | Exit => ReasonReact.Update(state)
        | LoadStories => ReasonReact.SideEffects(
            (
                self => Fetch.fetch(
                    "/data.json"
                )
                |> Js.Promise.then_(Fetch.Response.json)
                |> Js.Promise.then_(json => {
                    json |> Story.decodeStory |> s => StartStory(s) |> self.send;
                    Js.Promise.resolve([]);
                })
                |> ignore
            )
        )
    },
    render: self => {
        switch (self.state.story) {
            | Some(s) => {
            <div>
                <div>{Story.getTextForId(self.state.current, s) |> (text => <div>{ReasonReact.string(text)}</div>)}</div>
                {
                    Story.getNextForId(self.state.current, s)
                    |> List.map((next: Story.tNextStory) =>
                        <button onClick={_event => self.send(SetStory(next.target))}>{ReasonReact.string(next.text)}</button>
                    )
                    |> Array.of_list
                    |> ReasonReact.array
                }
                
            </div>
            }
            | None => <button onClick={_event => self.send(LoadStories)}>
                {ReasonReact.string("Load Stories")}
                </button>
        }
    },
};