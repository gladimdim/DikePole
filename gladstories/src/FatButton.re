[@react.component]
let make = (~title: string, ~onClickHandler) => {
  <button key=title className="continueBlock" onClick=onClickHandler>
    {React.string(title)}
  </button>;
};