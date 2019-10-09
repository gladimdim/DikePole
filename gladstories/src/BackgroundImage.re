let r = Random.init(20);

let imageTypeToPath =
    (~imageType: option(GladStory.tImageType), ~colored=false, ()): string => {
  switch (imageType) {
  | Some(v) =>
    let max =
      switch (v) {
      | GladStory.Boat => 18
      | GladStory.Bulrush => 11
      | GladStory.Camp => 14
      | GladStory.Steppe => 14
      | GladStory.Cossacks => 14
      | GladStory.Forest => 9
      | GladStory.Landing => 7
      | GladStory.River => 21
      };
    colored
      ? String.concat(
          "",
          ["images/", GladStory.imageTypeToString(v), "/c_", ".jpg"],
        )
      : String.concat(
          "",
          [
            "images/",
            GladStory.imageTypeToString(v),
            "/",
            Random.int(max) |> string_of_int,
            ".jpg",
          ],
        );

  | None => ""
  };
};