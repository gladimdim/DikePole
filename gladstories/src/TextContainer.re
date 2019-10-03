[@react.component]
let make = (~text: string) => {
  <div className="textContainer"> {React.string(text)} </div>;
};