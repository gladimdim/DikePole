[@react.component]
let make = (~next: array(GladStory.pageNext), ~onSelected) => {
  <div>
    {next
     |> Array.map((n: GladStory.pageNext) =>
          <FatButton
            key={n.text}
            title={n.text}
            onClickHandler={_ => n |> onSelected}
          />
        )
     |> React.array}
  </div>;
};