[@react.component]
let make = (~historyItem) => {
  let (text, image) = historyItem;
  <div>
    {switch (image) {
     | Some(v) =>
       <img
         className="historyImage"
         src={BackgroundImage.imageTypeToPath(v)}
       />
     | None => <div />
     }}
    <TextContainer text key=text />
  </div>;
};