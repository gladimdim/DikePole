[@react.component]
let make = (~storyName=?, ()) => {
  let (json, setJSON) = React.useState(_ => "");
  let (story, setGladStory) = React.useState(_ => None);
  let handleTextChange = input => {
    setJSON(_ => input##value);
  };

  let updateModelFromJson = input => {
    setJSON(_ => Json.stringify(input));
    let s = Decoder.fromJSON(Some(input));
    setGladStory(_ => Some(s));
  };

  <div>
    {switch (story) {
     | Some(s) =>
       Js.log("lol");
       <StoryView initialPage=s />;
     | None =>
       Js.log("lol2");
       switch (storyName) {
       | Some(v) => <div> {React.string(v)} </div>
       | None =>
         <div>
           <div>
             <FatButton
               title={js|Читати Хотинську різню|js}
               onClickHandler={_ =>
                 ReasonReactRouter.push("stories#hotin_massacre")
               }
             />
             <FatButton
               title="Load After the Battle"
               onClickHandler={_ =>
                 ReasonReactRouter.push("stories#afterbattle_en_gladstory")
               }
             />
           </div>
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
           </div>
         </div>
       };
     }}
  </div>;
};