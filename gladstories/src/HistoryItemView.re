[@react.component]
let make = (~historyItem) => {
  let (text, image) = historyItem;
  <div>
    {switch (image) {
     | "" => <div />

     | v =>
       <div className="slideWrapper">
         <img id="slide" className="historyImage" src=v />
       </div>
     }}
    <TextContainer text key=text />
  </div>;
};