[@react.component]
let make = (~title: string, ~onClickHandler) => {
  <div key=title className="continueBlock" onClick=onClickHandler>
    {React.string(title)}
  </div>;
};