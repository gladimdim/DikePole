import 'dart:collection';

abstract class Stockable<T> {
  Map<T, int> _map = {};

  Stockable(Map<T, int> props) {
    if (props != null) {
      _map = Map.from(props);
    }
  }

  List<T> getTypeKeys() {
    return _map.keys.toList();
  }

  operator <(Stockable<T> anotherMap) {
    if (anotherMap._map.keys.length < this._map.keys.length) {
      return false;
    }
    var queue = Queue.from(this._map.keys);
    while (queue.isNotEmpty) {
      var element = queue.removeFirst();
      var localValue = this._map[element];
      if (anotherMap._map[element] < (localValue == null ? 0 : localValue)) {
        return false;
      }
    }
    return true;
  }

  operator >(Stockable<T> anotherMap) {
    if (anotherMap._map.keys.length > this._map.keys.length) {
      return false;
    }
    var queue = Queue.from(this._map.keys);
    while (queue.isNotEmpty) {
      var element = queue.removeFirst();
      var localValue = this._map[element];
      if (anotherMap._map[element] > (localValue == null ? 0 : localValue)) {
        return false;
      }
    }
    return true;
  }

  int getByType(T type) {
    return this._map[type];
  }

  addToType(T type, int amount) {
    if (_map[type] == null) {
      _map[type] = 0;
    }
    _map[type] = _map[type] + amount;
    if (_map[type] < 0) {
      _map[type] = 0;
    }
  }

  Map<T, int> asMap() {
    return Map.from(_map);
  }

  removeFromType(T type, int amount) {
    if (_map[type] == null) {
      return;
    }
    _map[type] = _map[type] - amount;
    if (_map[type] < 0) {
      _map[type] = 0;
    }
  }

  operator +(Stockable another) {
    if (another != null) {
      this._map.forEach((key, _) {
        if (another.getByType(key) != null) {
          this.addToType(key, another.getByType(key));
        }
      });
    }
  }

  operator -(Stockable another) {
    if (another != null) {
      this._map.forEach((key, _) {
        if (another.getByType(key) != null) {
          this.removeFromType(key, another.getByType(key));
        }
      });
    }
  }
}
