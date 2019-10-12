type tImageType =
  | Camp
  | Steppe
  | Landing
  | Forest
  | Bulrush
  | Boat
  | River
  | Cossacks;

let imageTypeFromString = input => {
  switch (input) {
  | "forest" => Forest
  | "camp" => Camp
  | "steppe" => Camp // shadowed
  | "landing" => Landing
  | "bulrush" => Bulrush
  | "boat" => Boat
  | "river" => River
  | "cossacks" => Camp // shadowed
  | _ => Bulrush
  };
};

let imageTypeToString = input => {
  switch (input) {
  | Forest => "forest"
  | Camp => "camp"
  | Steppe => "steppe"
  | Landing => "landing"
  | Bulrush => "bulrush"
  | Boat => "boat"
  | River => "river"
  | Cossacks => "cossacks"
  };
};

type node = {
  text: string,
  imageType: option(tImageType),
};

type page = {
  endType: option(string),
  next: array(pageNext),
  nodes: array(node),
}
and pageNext = {
  text: string,
  nextPage: page,
};

type gladStory = {
  title: string,
  description: string,
  authors: string,
  root: page,
};