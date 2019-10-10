[@react.component]
let make = (~storyName=?, ()) => {
  let (json, setJSON) = React.useState(_ => "");
  let handleTextChange = input => {
    setJSON(_ => input##value);
  };

  <div>
    {switch (storyName) {
     | Some(v) => <div> {React.string(v)} </div>
     | None =>
       <div>
         <div>
           <FatButton
             title={js|Читати Хотинську різню|js}
             onClickHandler={_ =>
               ReasonReactRouter.push("stories/#hotin_massacre")
             }
           />
           <FatButton
             title="Load After the Battle"
             onClickHandler={_ =>
               ReasonReactRouter.push("stories/#afterbattle_en_gladstory")
             }
           />
         </div>
       </div>
     //  </div>
     //    />
     //      }
     //        handleTextChange(ReactEvent.Form.target(event))
     //      onChange={event =>
     //      rows=10
     //      value=json
     //      className="textAreaStyle"
     //    <textarea
     //    </p>
     //       )}
     //         {js|Вставте свій текст GladStory|js},
     //      {React.string(
     //    <p>
     //  <div>
     //  />
     //    }
     //      )
     //           }}
     //           | None => ()
     //           | Some(value) => updateModelFromJson(value)
     //          {switch (json) {
     //        json =>
     //      |> (
     //      |> Json.parse
     //      json
     //    onClickHandler={_ =>
     //    title={js|Розпізнати свій текст з форми|js}
     //  <FatButton
     }}
  </div>;
};