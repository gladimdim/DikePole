[@react.component]
let make = () => {
  let url = ReasonReactRouter.useUrl();

  switch (url.path, url.hash) {
  | (["stories", _], h) =>
    Js.log(h);
    <StoryViewWrapper storyName=h />;
  | _ =>
    Js.log(url);
    <Viewer />;
  };
};