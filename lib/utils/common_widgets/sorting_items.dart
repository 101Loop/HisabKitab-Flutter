class SortingItems {
  int sortScheme;
  String name;
  SortingItems({this.sortScheme, this.name});
}

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
