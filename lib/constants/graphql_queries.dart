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
        surface
        attention_surface
        place_working_days {
          id
          day_of_week
          opening_time
          closing_time
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

  static String placeSnapshots = """
    query AllPlaceSnapshots(\$day: Int, \$hour: Int) {
      allPlaceSnapshots(day: \$day, hour: \$hour) {
        place_id
        day_of_week
        hour_of_day
        crowd_people_no
        queue_people_no
        covid_safety_score
        service_quality_score
      }
    }
  """;
}
