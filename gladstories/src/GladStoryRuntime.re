module type Story = {let page: GladStory.page;};
module Runtime = (S: Story) => {
  let getNextTextOptions = () => {
    S.page.next |> Array.map((element: GladStory.pageNext) => element.text);
  };
};

let getNextTextOptions = (p: GladStory.page) => {
  p.next |> Array.map((element: GladStory.pageNext) => element.text);
};

let getNodes = (p: GladStory.page) => {
  p.nodes |> Array.map((element: GladStory.node) => element.text);
};