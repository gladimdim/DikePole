open Revery;
open Revery.Math;
open Revery.UI;
open Revery.UI.Components;

let animatedText = {
  let component = React.component("AnimatedText");

  (~children as _: list(React.syntheticElement), ~delay, ~textContent, ()) =>
    component(hooks => {
      let (translate, hooks) =
        Hooks.animation(
          Animated.floatValue(50.),
          Animated.options(
            ~toValue=0.,
            ~duration=Seconds(0.5),
            ~delay=Seconds(delay),
            (),
          ),
          hooks,
        );

      let (opacityVal: float, hooks) =
        Hooks.animation(
          Animated.floatValue(0.),
          Animated.options(
            ~toValue=1.0,
            ~duration=Seconds(1.),
            ~delay=Seconds(delay),
            (),
          ),
          hooks,
        );

      let textHeaderStyle =
        Style.[
          color(Colors.white),
          fontFamily("Roboto-Regular.ttf"),
          fontSize(24),
          transform([Transform.TranslateY(translate)]),
        ];

      (
        hooks,
        <Opacity opacity=opacityVal>
          <Padding padding=8>
            <Text style=textHeaderStyle text=textContent />
          </Padding>
        </Opacity>,
      );
    });
};

let s: GladStory.gladStory = {
  title: "Хотинська різня",
  description: "Під час стояння під Хотином, козацьке військо здійснило унікальний для XVII століття нічний рейд. Було зруйновано декілька гармат та вирізано їх обслугу. В цій історії у вас буде багато важливих виборів, і не всі вони будуть очевидні..",
  root: {
    nodes: [||],
    next: [||],
    endType: None,
  },
  authors: "Сава Теслюк",
};

let mainView = {
  let component = React.component("Load Story");

  (~children as _: list(React.syntheticElement), ()) =>
    component(hooks => {
      let (story, setStory, hooks) = React.Hooks.state(None, hooks);
      let loadStory = () => setStory(Some(s));

      let wrapperStyle =
        Style.[
          backgroundColor(Color.rgba(1., 1., 1., 0.1)),
          border(~width=2, ~color=Colors.white),
          margin(16),
        ];

      let textHeaderStyle =
        Style.[
          color(Colors.white),
          fontFamily("Roboto-Regular.ttf"),
          fontSize(20),
        ];

      let textContent = "Load Story";
      (
        hooks,
        <View>
          {switch (story) {
           | Some(v) =>
             <View>
               {switch (story) {
                | Some(v) => <Text style=textHeaderStyle text={v.title} />
                | None => <Text style=textHeaderStyle />
                }}
               <Image src="4.jpg" style=Style.[width(320), height(240)] />
             </View>
           | None =>
             <Clickable onClick=loadStory>
               <View style=wrapperStyle>
                 <Padding padding=4>
                   <Text style=textHeaderStyle text=textContent />
                 </Padding>
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
    ];

  let innerStyle = Style.[flexDirection(`Row), alignItems(`FlexEnd)];

  let element = <View style=containerStyle> <mainView /> </View>;

  let _ = UI.start(win, element);
  ();
};

App.start(init);