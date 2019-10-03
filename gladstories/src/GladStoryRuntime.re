let getNextTextOptions = (p: GladStory.page) => {
  p.next |> Array.map((element: GladStory.pageNext) => element.text);
};

let getNodes = (p: GladStory.page) => {
  p.nodes |> Array.map((element: GladStory.node) => element.text);
};

let getNextPageBySelectedOption =
    (p: GladStory.page, selected: GladStory.pageNext) => {
  p.next->Belt_Array.getBy(element => element == selected);
};