/// Model class for [SortingItems]
class SortingItems {
  /// Scheme used to sort the items
  int sortScheme;

  /// Name of the sorting scheme
  String name;
  SortingItems({this.sortScheme, this.name});
}

/// List of [SortingItems]
final List<SortingItems> sortingItems = [
  SortingItems(
    sortScheme: 0,
    name: 'aToZ',
  ),
  SortingItems(
    sortScheme: 1,
    name: 'zToA',
  ),
  SortingItems(
    sortScheme: 2,
    name: 'priceHighToLow',
  ),
  SortingItems(
    sortScheme: 3,
    name: 'priceLowToHigh',
  ),
];
