open Revery;
open Revery.Math;
open Revery.UI;
open Revery.UI.Components;

open Lwt.Infix;

let mainView = {
  let component = React.component("Load Story");

  (~children as _: list(React.syntheticElement), ()) =>
    component(hooks => {
      let (story, setStory, hooks) = React.Hooks.state(None, hooks);
      let loadStory = storyName => {
        let result =
          Api.fetch(
            "http://locadeserta.com/beta2/build/stories/"
            ++ storyName
            ++ ".json",
          )
          |> Lwt_main.run;
        setStory(result |> GladStory.decode |> (a => Some(a)));
      };

      let wrapperStyle =
        Style.[
          backgroundColor(Colors.white),
          border(~width=1, ~color=Colors.black),
          margin(16),
          justifyContent(`Center),
          alignItems(`Center),
        ];

      let textHeaderStyle =
        Style.[
          color(Colors.white),
          width(200),
          backgroundColor(Colors.black),
          fontFamily("Roboto-Regular.ttf"),
          fontSize(18),
        ];

      (
        hooks,
        <View>
          {switch (story) {
           | Some(v) =>
             <View>
               {switch (story) {
                | Some(v) => <MetaStoryView story=v />
                | None => <Text style=textHeaderStyle />
                }}
               <Image src="4.jpg" style=Style.[width(320), height(240)] />
             </View>
           | None =>
             <Clickable onClick={() => loadStory("hotin_massacre")}>
               <View style=wrapperStyle>
                 <Text style=textHeaderStyle text="Load Story" />
               </View>
             </Clickable>
           }}
        </View>,
      );
    });
};

let init = app => {
  let _ = Revery.Log.listen((_, msg) => print_endline("LOG: " ++ msg));

  let win = App.createWindow(app, "Welcome to GladStories runner!");

  let containerStyle =
    Style.[
      position(`Absolute),
      justifyContent(`Center),
      alignItems(`Center),
      bottom(0),
      top(0),
      left(0),
      right(0),
      // width(500),
      // height(500),
      backgroundColor(Colors.gray),
      border(~width=1, ~color=Colors.black),
    ];

  let element = <View style=containerStyle> <mainView /> </View>;

  let _ = UI.start(win, element);
  ();
};

App.start(init);