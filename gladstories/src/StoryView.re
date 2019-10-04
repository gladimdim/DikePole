[@react.component]
let make = (~initialPage: GladStory.page) => {
  let (current, setCurrent) = React.useState(_ => 1);
  let (page, setPage) = React.useState(_ => initialPage);
  let (history, setHistory) =
    React.useState(_ =>
      [(initialPage.nodes[0].text, initialPage.nodes[0].imageType)]
    );
  <div>
    {current == Array.length(page.nodes)
       ? <OptionBlock
           next={page.next}
           onSelected={(selected: GladStory.pageNext) => {
             setPage(_ => selected.nextPage);
             setCurrent(_ => {
               setHistory(old => [(selected.text, None), ...old]);
               0;
             });
           }}
         />
       : <FatButton
           title={js|Продовжити|js}
           onClickHandler={_ =>
             setCurrent(c => {
               setHistory(old => [(page.nodes[c].text, None), ...old]);
               c + 1;
             })
           }
         />}
    {List.map(
       element => {
         let (key, _) = element;
         <HistoryItemView historyItem=element key />;
       },
       history,
     )
     |> Array.of_list
     |> React.array}
  </div>;
};