let handleJSON = json => {
  let story = GladStory.fromJSON(json);
  story;
};

[@react.component]
let make = (~firstName) => {
  let (json, setJSON) = React.useState(_ => firstName);
  let (gladStory, setGladStory) = React.useState(_ => None);
  let handleTextChange = input => {
    setJSON(_ => input##value);
  };

  let handleJson = input => {
    setGladStory(_ => Some(input));
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
      onClick={_ => json |> Json.parse |> GladStory.fromJSON |> handleJson}>
      {React.string("Parse")}
    </button>
    {switch (gladStory) {
     | Some(v) => <div> {React.string(v.title)} </div>
     | None => <div> {React.string("Not yet parsed")} </div>
     }}
  </div>;
};