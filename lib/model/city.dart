class City {
  int? id;
  late String name;
  late double lat;
  late double lon;

  City(this.id, this.name, this.lat, this.lon);

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['id'] = id;
    map['name'] = name;
    map['lat'] = lat;
    map['lon'] = lon;
    return map;
  }

  City.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = map['name'];
    lat = map['lat'];
    lon = map['lon'];
  }
}
