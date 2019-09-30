[@react.component]
let make = (~firstName) => {
  let (json, setJSON) = React.useState(_ => firstName);
  let handleTextChange = input => {
    setJSON(_ => input##value);
  };
  <div>
    <p> {React.string("Paste the Glad Story JSON: ")} </p>
    <textarea
      value=json
      height="50"
      onChange={event => handleTextChange(ReactEvent.Form.target(event))}
    />
    <p />
    <button onClick={_ => json |> Json.parse |> GladStory.fromJSON |> ignore}>
      {React.string("Parse")}
    </button>
  </div>;
};