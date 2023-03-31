enum PlacesInfoItem { crowds, queues, service }

class PlacesInfoItemData {
  const PlacesInfoItemData({required this.title, required this.iconPath});

  final String title;
  final String iconPath;

  static const Map<PlacesInfoItem, PlacesInfoItemData> allItems = {
    PlacesInfoItem.crowds: PlacesInfoItemData(
        title: "Aglomeraciones", iconPath: "assets/icons/places_info/crowds.png"),
    PlacesInfoItem.queues: PlacesInfoItemData(
        title: "Personas esperando", iconPath: "assets/icons/places_info/queues.png"),
    PlacesInfoItem.service: PlacesInfoItemData(
        title: "Puntaje de calidad", iconPath: "assets/icons/places_info/waiting_time.png"),
  };
}
