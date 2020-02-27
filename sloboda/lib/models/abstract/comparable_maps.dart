import 'dart:collection';

abstract class ComparableMaps<T> {
  Map<T, int> map = {};

  ComparableMaps([Map<T, int> props]) {
    if (props != null) {
      map = Map.from(props);
    }
  }

  List<T> getTypeKeys() {
    return map.keys.toList();
  }

  operator <(ComparableMaps<T> anotherMap) {
    if (anotherMap.map.keys.length > this.map.keys.length) {
      return false;
    }
    var queue = Queue.from(this.map.keys);
    while (queue.isNotEmpty) {
      var element = queue.removeFirst();
      if (anotherMap.map[element] > this.map[element]) {
        return false;
      }
    }
    return true;
  }

  operator >(ComparableMaps<T> anotherMap) {
    if (anotherMap.map.keys.length > this.map.keys.length) {
      return false;
    }
    var queue = Queue.from(this.map.keys);
    while (queue.isNotEmpty) {
      var element = queue.removeFirst();
      if (anotherMap.map[element] < this.map[element]) {
        return false;
      }
    }
    return true;
  }

  getByType(T type) {
    return this.map[type];
  }

  addToType(T type, int amount) {
    map[type] = map[type] + amount;
    if (map[type] < 0) {
      map[type] = 0;
    }
  }

  Map<T, int> asMap() {
    return Map.from(map);
  }

  removeFromType(T type, int amount) {
    map[type] = map[type] - amount;
    if (map[type] < 0) {
      map[type] = 0;
    }
  }

  operator +(ComparableMaps another) {
    if (another != null) {
      this.map.forEach((key, _) {
        if (another.getByType(key) != null) {
          this.addToType(key, another.getByType(key));
        }
      });
    }
  }

  operator -(ComparableMaps another) {
    if (another != null) {
      this.map.forEach((key, _) {
        if (another.getByType(key) != null) {
          this.removeFromType(key, another.getByType(key));
        }
      });
    }
  }
}
