[@react.component]
let make = (~jsonString: string) => {
  let (json, setJSON) = React.useState(_ => jsonString);
  let (gladStory, setGladStory) = React.useState(_ => None);
  let handleTextChange = input => {
    setJSON(_ => input##value);
  };

  let handleJson = input => {
    setGladStory(_ => Some(input));
  };

  let updateModelFromJson = input => {
    setJSON(_ => Json.stringify(input));
    GladStory.fromJSON(Some(input)) |> handleJson;
  };

  let handleFetch = () => {
    Js.Promise.(
      Fetch.fetch("/gladstory.json")
      |> then_(Fetch.Response.json)
      |> then_(json => updateModelFromJson(json) |> resolve)
    )
    |> ignore;
  };

  <div>
    <p> {React.string("Paste the Glad Story JSON: ")} </p>
    <textarea
      value=json
      height="50"
      onChange={event => handleTextChange(ReactEvent.Form.target(event))}
    />
    <p />
    <button
      onClick={_ =>
        json
        |> Json.parse
        |> (
          json =>
            {switch (json) {
             | Some(value) => updateModelFromJson(value)
             | None => ()
             }}
        )
      }>
      {React.string("Parse")}
    </button>
    <button onClick={_ => handleFetch()}>
      {React.string("Load from backend")}
    </button>
    {switch (gladStory) {
     | Some(v) => <div> {React.string(v.title)} </div>
     | None => <div> {React.string("Not yet parsed")} </div>
     }}
  </div>;
};