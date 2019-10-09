[@react.component]
let make = (~storyName: string) => {
  let (gladStory, setGladStory) = React.useState(_ => None);
  let handleJson = input => {
    setGladStory(_ => Some(input));
  };

  let updateModelFromJson = input => {
    GladStory.fromJSON(Some(input)) |> handleJson;
  };
  let handleFetch = s => {
    Js.Promise.(
      Fetch.fetch(s)
      |> then_(Fetch.Response.json)
      |> then_(json => updateModelFromJson(json) |> resolve)
    )
    |> ignore;
  };

  React.useEffect0(_ => {
    handleFetch("stories/" ++ storyName ++ ".json");
    Some(() => ());
  });

  switch (gladStory) {
  | Some(v) => <StoryView initialPage=v />
  | None => <div> {React.string("Story not found")} </div>
  };
};