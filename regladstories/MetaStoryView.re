open Revery;
open Revery.Math;
open Revery.UI;
open Revery.UI.Components;

let component = React.component("MetaStoryView");

type tStory = GladStory.gladStory;
let createElement =
    (~story: tStory, ~children as _: list(React.syntheticElement), ()) =>
  component(hooks => {
    let wrapperStyle =
      Style.[
        width(300),
        // flexGrow(1),
        alignItems(`Center),
        justifyContent(`Center),
        border(~width=1, ~color=Colors.black),
      ];

    let textHeaderStyle =
      Style.[
        color(Colors.black),
        fontFamily("Roboto-Regular.ttf"),
        fontSize(20),
        marginTop(20),
      ];

    (
      hooks,
      <Clickable>
        <View style=wrapperStyle>
          <Padding padding=8>
            <Text style=textHeaderStyle text={story.title} />
            <Text style=textHeaderStyle text={story.description} />
            <Text style=textHeaderStyle text={story.authors} />
          </Padding>
        </View>
      </Clickable>,
    );
  });