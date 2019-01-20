type state = {
  current: Story.tPid,
  story: option(Story.tStory),
};

type action =
  | Next(Story.tPid)
  | Exit
  | LoadStories
  | StartStory(Story.tStory)
  | SetStory(Story.tPid);

let component = ReasonReact.reducerComponent("Tree");

let make = _children => {
  ...component,
  initialState: () => {current: "-1", story: None},
  reducer: (action, state) =>
    switch (action) {
    | SetStory(id) => ReasonReact.Update({...state, current: id})
    | StartStory(story) =>
      ReasonReact.Update({current: "1", story: Some(story)})
    | Next(a) => ReasonReact.Update({...state, current: a})
    | Exit => ReasonReact.Update(state)
    | LoadStories =>
      ReasonReact.SideEffects(
        self =>
          Fetch.fetch("/twinery.json")
          |> Js.Promise.then_(Fetch.Response.json)
          |> Js.Promise.then_(json => {
               json |> Story.decodeStory |> (s => StartStory(s) |> self.send);
               Js.Promise.resolve([]);
             })
          |> ignore,
      )
    },
  render: self => {
    switch (self.state.story) {
    | Some(story) =>
      <div>
        <img
          src={Story.getStoryNodeByPid(story, self.state.current).background}
          style={Background.backgroundStyleForTopImage()}
        />
        <div>
          {Story.getTextForPid(self.state.current, story.passages)
           |> (text => <div> {ReasonReact.string(text)} </div>)}
        </div>
        {switch (Story.getNextForPid(self.state.current, story.passages)) {
         | Some(n) =>
           List.map(
             (next: Story.tNextStory) =>
               <button onClick={_event => self.send(SetStory(next.pid))}>
                 {ReasonReact.string(next.name)}
               </button>,
             n,
           )
           |> Array.of_list
           |> ReasonReact.array
         | None => ReasonReact.null
         }}
      </div>
    | None =>
      <button onClick={_event => self.send(LoadStories)}>
        {ReasonReact.string("Load Stories")}
      </button>
    };
  },
};