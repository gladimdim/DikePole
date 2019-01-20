let backgroundStyleForTopImage = () => {
  ReactDOMRe.Style.make(~width="100%", ~height="auto", ());
};

let imageForStory = (story: Story.tStoryNode): string => {
  switch (story.background) {
  | "boat" => "background/boat.jpg"
  };
};