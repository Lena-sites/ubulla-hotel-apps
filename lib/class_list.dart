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

List<HotelList>hotellist=[
  HotelList(name:'Four Seasons Resort Bali at Jimbaran Bay',price:800000, location: 'Jimbaran, Bali'),
  HotelList(name:'Amanjiwo',price:800000, location: 'Desa Majaksingi, Borobudur'),
  HotelList(name:'The Ritz-Carlton Bali',price:500000, location: 'Nusa Dua, Bali'),
  HotelList(name:'Grand Hyatt Jakarta',price:600000, location: 'Jakarta Pusat'),
  HotelList(name:'JW Marriott Hotel Medan',price:500000, location: 'Medan, Sumatera Utara'),
  HotelList(name:'Aryaduta Palembang',price:700000, location: 'Palembang, Sumatera Selatan'),
];

class HotelList{
  String name;
  int price;
  String location;
  bool selected; //ini yang di search.dart
  bool save; //ini yang di main.dart

  HotelList({
    required this.name,
    required this.price,
    required this.location,
    this.selected=false,
    this.save=false,
  });
}