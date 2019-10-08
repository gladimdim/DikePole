[@react.component]
let make = (~jsonString: string) => {
  let (json, setJSON) = React.useState(_ => jsonString);
  let (story, setGladStory) = React.useState(_ => None);
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

  let handleFetch = s => {
    Js.Promise.(
      Fetch.fetch(s)
      |> then_(Fetch.Response.json)
      |> then_(json => updateModelFromJson(json) |> resolve)
    )
    |> ignore;
  };

  <div>
    {switch (story) {
     | Some(v) => <StoryView initialPage={v.root} />
     | None =>
       <div>
         <div>
           <p>
             {React.string(
                {js|Вставте свій текст GladStory|js},
              )}
           </p>
           <textarea
             className="textAreaStyle"
             value=json
             rows=10
             onChange={event =>
               handleTextChange(ReactEvent.Form.target(event))
             }
           />
         </div>
         <div>
           <FatButton
             title={js|Розпізнати свій текст з форми|js}
             onClickHandler={_ =>
               json
               |> Json.parse
               |> (
                 json =>
                   {switch (json) {
                    | Some(value) => updateModelFromJson(value)
                    | None => ()
                    }}
               )
             }
           />
           <FatButton
             title={js|Розпочати читати Хотинську різню|js}
             onClickHandler={_ => handleFetch("./gladstory.json")}
           />
           <FatButton
             title="Load After the Battle"
             onClickHandler={_ =>
               handleFetch("./afterbattle_en_gladstory.json")
             }
           />
         </div>
       </div>
     }}
  </div>;
};