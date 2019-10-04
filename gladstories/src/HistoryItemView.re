[@react.component]
let make = (~historyItem) => {
  let (text, _image) = historyItem;
  <div>
    {switch (historyItem) {
     | (_, Some(_v)) => <div> {React.string("something")} </div>
     | _ => <div />
     }}
    <TextContainer text key=text />
  </div>;
};