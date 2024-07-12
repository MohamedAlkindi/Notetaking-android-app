// You need to filter the list and their data inside a stream. So you need to extend the functionality of a stream to do that work for u, manually.
// The buttom line of this is it's a filter that returns a stream of things that pass a test. That's all...
extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
