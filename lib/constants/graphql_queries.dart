class GraphQlQueries {
  static String mapViewData = """
    query {
      allPlaces {
        id
        place_name
        place_short_name
        place_type {
          id
          place_type_name
        }
        services {
          id
          service_name
        }
        coordinates {
          latitude
          longitude
        }
      }
      allAreas {
        id
        area_name
        coordinates {
          latitude
          longitude
        }
      }
      allPlaceTypes{
        id
        place_type_name
      }
      allServices{
        id
        service_name
      }
    }
  """;
}
