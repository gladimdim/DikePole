let defaultStory: GladStory.gladStory = {
  title: "Default title",
  description: "Default Description",
  authors: "Cool humans",
  root: {
    endType: None,
    next: [||],
    nodes: [||],
  },
};

[@react.component]
let make = () => {
  let url = ReasonReactRouter.useUrl();

  switch (url.path, url.hash) {
  | (["stories"], h) =>
    Js.log(h);
    <StoryViewWrapper storyName=h />;
  | (["editor"], _) => <Editor story=defaultStory />
  | _ =>
    Js.log(url);
    <Viewer />;
  };
};