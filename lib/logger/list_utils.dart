import 'dart:collection';

/// A [CircularBuffer] with a fixed capacity supporting all [List] operations
///
/// ```dart
/// final buffer = CircularBuffer<int>(3)..add(1)..add(2);
/// print(buffer.length); // 2
/// print(buffer.first); // 1
///
/// buffer.add(3);
/// print(buffer.length); // 3
///
/// buffer.add(4);
/// print(buffer.first); // 2
/// ```
class CircularBuffer<T> {
  final List<T?> _buffer;
  int _index = 0;

  CircularBuffer(int capacity) : _buffer = List.filled(capacity, null);

  void add(T e) {
    _buffer[_index] = e;
    _index++;
    if (_index == _buffer.length) {
      _index = 0;
    }
  }

  List<T> dump() {
    // Two cases: filled or not filled
    // Not filled
    if (_buffer[_index] == null) {
      return [
        for (int i = 0; i < _index; i++) _buffer[i]!,
      ];
    }

    // Buffer is filled
    return [
      for (int i = _index; i < _buffer.length; i++) _buffer[i]!,
      for (int i = 0; i < _index; i++) _buffer[i]!,
    ];
  }
}

class AutoListMap<K, V> extends MapMixin<K, List<V>> {
  final Map<K, List<V>> _innerMap = {};

  @override
  List<V>? operator [](Object? key) {
    return _innerMap.putIfAbsent(key as K, () => []);
  }

  @override
  void operator []=(K key, List<V> value) {
    _innerMap[key] = value;
  }

  @override
  void clear() {
    _innerMap.clear();
  }

  @override
  Iterable<K> get keys => _innerMap.keys;

  @override
  List<V>? remove(Object? key) {
    return _innerMap.remove(key);
  }

  void add(K key, V value) {
    _innerMap.putIfAbsent(key, () => []).add(value);
  }
}
