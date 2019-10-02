[@react.component]
let make = (~initialPage: GladStory.page) => {
  let (current, setCurrent) = React.useState(_ => 0);
  let (page, setPage) = React.useState(_ => initialPage);
  let (history, setHistory) = React.useState(_ => []);
  <div>
    {List.mapi(
       (i, element) =>
         <div className="textContainer" key={string_of_int(i)}>
           {React.string(element)}
         </div>,
       history,
     )
     |> Array.of_list
     |> React.array}
    <button
      className="continueBlock"
      onClick={_ =>
        setCurrent(c =>
          c == Array.length(page.nodes) - 1
            ? 0
            : {
              setHistory(old => [page.nodes[c].text, ...old]);
              c + 1;
            }
        )
      }>
      {React.string({js|Продовжити|js})}
    </button>
  </div>;
};