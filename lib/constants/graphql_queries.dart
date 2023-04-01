class GraphQLQueries {
  static String allPlaces = """
    query {
      allPlaces {
        id
        place_name
        place_short_name
        coordinates {
          latitude
          longitude
        }
      }
    }
  """;

  static String allAreas = """
    query {
      allAreas {
        id
        area_name
        coordinates {
          latitude
          longitude
        }
      }
    }
  """;
}
