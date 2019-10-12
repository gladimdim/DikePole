let getValue = event => ReactEvent.Form.target(event)##value;

[@react.component]
let make = (~story: GladStory.gladStory) => {
  let (s, setStory) = React.useState(_ => story);

  let handleTitleChange = newTitle => {
    setStory(old => {...old, title: newTitle});
    ();
  };
  <div>
    <FatButton title="Lol" onClickHandler={_ => ()} />
    <form>
      <label>
        {React.string("Title: ")}
        <br />
        <input
          value={s.title}
          onChange={e => e |> getValue |> handleTitleChange}
        />
      </label>
    </form>
  </div>;
};