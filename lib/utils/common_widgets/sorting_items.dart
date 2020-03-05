class SortingItems {
  String name;
  SortingItems({this.name});
}

final List<SortingItems> sortingItems = [
  SortingItems(
    name: 'A => Z',
  ),
  SortingItems(
    name: 'Z => A',
  ),
  SortingItems(
    name: 'Price (Higher => Lower)',
  ),
  SortingItems(
    name: 'Price (Lower => Higher)',
  ),
];
