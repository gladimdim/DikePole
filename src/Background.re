let backgroundStyleForTopImage = () => {
  ReactDOMRe.Style.make(~width="100%", ~height="auto", ());
};

let imageForStory = (story: Story.tStoryNode): string => {
  let rand = Random.int(3);
  switch (story.background) {
  | Some(v) =>
    switch (v) {
    | "boat" => "background/boat_" ++ string_of_int(rand) ++ ".jpg"
    | "ocheret" => "background/ocheret_" ++ string_of_int(rand) ++ ".jpg"
    | _ => "background/boat_" ++ string_of_int(rand) ++ ".jpg"
    }
  | None => "background/boat_" ++ string_of_int(rand) ++ ".jpg"
  };
};