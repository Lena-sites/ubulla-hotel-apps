List<Filtering>filtering=[
  Filtering(button:'Recommended'),
  Filtering(button: 'Popular'),
  Filtering(button: 'Trending'),
  Filtering(button: 'New'),
  Filtering(button: 'All'),
];

//class untuk simpan tombol2 untuk filtering
class Filtering{
  String button;

  //variabel pengatur kondisi filteringnya
  bool filter;

  //constructor
  Filtering({
    required this.button,
    this.filter=false
  });
}