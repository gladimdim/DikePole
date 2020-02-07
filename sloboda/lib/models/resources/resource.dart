import 'package:sloboda/models/sloboda_localizations.dart';

class Resource {
  int quantity = 1;
  int name;
  RESOURCE_TYPES type;

  Resource(this.type);

  static Resource createWood() {
    return Resource(RESOURCE_TYPES.WOOD);
  }

  static Resource createFood() {
    return Resource(RESOURCE_TYPES.FOOD);
  }

  static Resource createStone() {
    return Resource(RESOURCE_TYPES.STONE);
  }

  static Resource createSulfur() {
    return Resource(RESOURCE_TYPES.POWDER);
  }

  static Resource createFur() {
    return Resource(RESOURCE_TYPES.FUR);
  }

  static Resource createFish() {
    return Resource(RESOURCE_TYPES.FISH);
  }

  static Resource createHose() {
    return Resource(RESOURCE_TYPES.HORSE);
  }
}

enum RESOURCE_TYPES {
  MONEY,
  WOOD,
  FOOD,
  STONE,
  POWDER,
  FUR,
  FISH,
  FIREARM,
  HORSE,
  IRON_ORE
}

String resourceTypesToKey(RESOURCE_TYPES type) {
  switch (type) {
    case RESOURCE_TYPES.FOOD:
      return 'resources.food';
    case RESOURCE_TYPES.MONEY:
      return 'resources.money';
    case RESOURCE_TYPES.WOOD:
      return 'resources.wood';
    case RESOURCE_TYPES.STONE:
      return 'resources.stone';
    case RESOURCE_TYPES.POWDER:
      return 'resources.powder';
    case RESOURCE_TYPES.FUR:
      return 'resources.fur';
    case RESOURCE_TYPES.FIREARM:
      return 'resources.firearm';
    case RESOURCE_TYPES.HORSE:
      return 'resources.horse';
    case RESOURCE_TYPES.IRON_ORE:
      return 'resources.ore';
    case RESOURCE_TYPES.FISH:
      return 'resources.fish';
    default:
      return 'resources.PLACEHOLDER';
  }
}

String localizedResourceByType(RESOURCE_TYPES type) {
  return SlobodaLocalizations.getForKey(resourceTypesToKey(type));
}

String resourceTypesToIconPath(RESOURCE_TYPES type) {
  switch (type) {
    case RESOURCE_TYPES.FOOD:
      return 'images/resources/food_64.png';
    case RESOURCE_TYPES.MONEY:
      return 'images/resources/money_64.png';
    case RESOURCE_TYPES.WOOD:
      return 'images/resources/wood_64.png';
    case RESOURCE_TYPES.STONE:
      return 'images/resources/stone_64.png';
    case RESOURCE_TYPES.POWDER:
      return 'images/resources/niter_64.png';
    case RESOURCE_TYPES.FUR:
      return 'images/resources/fur_64.png';
    case RESOURCE_TYPES.FIREARM:
      return 'images/resources/firearm_64.png';
    case RESOURCE_TYPES.HORSE:
      return 'images/resources/horse_64.png';
    case RESOURCE_TYPES.IRON_ORE:
      return 'images/resources/iron_ore_64.png';
    case RESOURCE_TYPES.FISH:
      return 'images/resources/fish_64.png';
    default:
      throw 'Resource $type is not recognized';
  }
}

String resourceTypesToImagePath(RESOURCE_TYPES type) {
  switch (type) {
    case RESOURCE_TYPES.FOOD:
      return 'images/resources/food.png';
    case RESOURCE_TYPES.MONEY:
      return 'images/resources/money.png';
    case RESOURCE_TYPES.WOOD:
      return 'images/resources/wood.png';
    case RESOURCE_TYPES.STONE:
      return 'images/resources/stone.png';
    case RESOURCE_TYPES.POWDER:
      return 'images/resources/niter.png';
    case RESOURCE_TYPES.FUR:
      return 'images/resources/fur.png';
    case RESOURCE_TYPES.FIREARM:
      return 'images/resources/firearm.png';
    case RESOURCE_TYPES.HORSE:
      return 'images/resources/horse.png';
    case RESOURCE_TYPES.IRON_ORE:
      return 'images/resources/iron_ore.png';
    case RESOURCE_TYPES.FISH:
      return 'images/resources/fish.png';
    default:
      throw 'Resource $type is not recognized';
  }
}
