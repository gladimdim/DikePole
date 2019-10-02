[@react.component]
let make = (~initialPage: GladStory.page) => {
  let (current, setCurrent) = React.useState(_ => 0);
  let (page, setPage) = React.useState(_ => initialPage);
  <div>
    <div key={string_of_int(current)}>
      {React.string(page.nodes[current].text)}
    </div>
    // {Array.mapi(
    //    (i, node: GladStory.node) =>
    //      <div key={string_of_int(i)}> {React.string(node.text)} </div>,
    //    story.root.nodes,
    //  )
    //  |> React.array}
    <button
      onClick={_ =>
        setCurrent(c => c == Array.length(page.nodes) - 1 ? 0 : c + 1)
      }>
      {React.string("Continue")}
    </button>
  </div>;
};