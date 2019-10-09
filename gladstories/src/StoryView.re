[@react.component]
let make = (~initialPage: GladStory.gladStory) => {
  let (current, setCurrent) = React.useState(_ => 1);
  let (page, setPage) = React.useState(_ => initialPage.root);
  let (history, setHistory) =
    React.useState(_ =>
      [
        (
          initialPage.root.nodes[0].text,
          BackgroundImage.imageTypeToPath(
            ~imageType=initialPage.root.nodes[0].imageType,
            (),
          ),
        ),
      ]
    );
  <div>
    {current == Array.length(page.nodes)
       ? <OptionBlock
           next={page.next}
           onSelected={(selected: GladStory.pageNext) => {
             setPage(_ => selected.nextPage);
             setCurrent(_ => {
               setHistory(old =>
                 [
                   (
                     selected.text,
                     BackgroundImage.imageTypeToPath(~imageType=None, ()),
                   ),
                   ...old,
                 ]
               );
               0;
             });
           }}
         />
       : <FatButton
           title={js|Продовжити|js}
           onClickHandler={_ =>
             setCurrent(c => {
               setHistory(old =>
                 [
                   (
                     page.nodes[c].text,
                     BackgroundImage.imageTypeToPath(
                       ~imageType=page.nodes[c].imageType,
                       (),
                     ),
                   ),
                   ...old,
                 ]
               );
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