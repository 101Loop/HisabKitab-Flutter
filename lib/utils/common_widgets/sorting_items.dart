class SortingItems {
  int sortScheme;
  String name;
  SortingItems({this.sortScheme, this.name});
}

final List<SortingItems> sortingItems = [
  SortingItems(
    sortScheme: 0,
    name: 'A => Z',
  ),
  SortingItems(
    sortScheme: 1,
    name: 'Z => A',
  ),
  SortingItems(
    sortScheme: 2,
    name: 'Price (Higher => Lower)',
  ),
  SortingItems(
    sortScheme: 3,
    name: 'Price (Lower => Higher)',
  ),
];
