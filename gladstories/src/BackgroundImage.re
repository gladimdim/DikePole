let r = Random.init(20);

let imageTypeToPath = (input: GladStory.tImageType) => {
  let max =
    switch (input) {
    | GladStory.Boat => 18
    | GladStory.Bulrush => 11
    | GladStory.Camp => 14
    | GladStory.Steppe => 14
    | GladStory.Cossacks => 14
    | GladStory.Forest => 9
    | GladStory.Landing => 7
    | GladStory.River => 21
    };
  String.concat(
    "",
    [
      "./images/",
      GladStory.imageTypeToString(input),
      "/",
      string_of_int(Random.int(max)),
      ".jpg",
    ],
  );
};