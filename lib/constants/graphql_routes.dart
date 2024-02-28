enum GraphQlQuery { mapViewData, placeSnapshots, getPlaceById, placeCrowdReport }

enum GraphQlMutation { login }

class GraphQlRoutes {
  static Map<GraphQlQuery, String> queries = {
    GraphQlQuery.mapViewData: """
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
    """,
    GraphQlQuery.placeSnapshots: """
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
    """,
    GraphQlQuery.getPlaceById: """
      query(\$id: ID!){
        placeById(id:\$id){
          id
          place_name
          place_short_name
          place_address
          place_type {
            id
            place_type_name
          }
          surface
          attention_surface
          coordinates {
            id
            latitude
            longitude
          }
          services {
            id
            service_name
            service_description
          }
          current_crowds {
            id
            place_id
            people_no
            crowd_day_of_week
            crowd_hour
          }
          current_queues {
            id
            place_id
            people_no
            queue_day_of_week
            queue_hour
          }
          indicators {
            indicator_name
            indicator_type
            indicator_description
            indicator_value
            opinion_no
          }
          place_working_days {
            id
            day_of_week
            opening_time
            closing_time
          }
        }
      }
    """,
    GraphQlQuery.placeCrowdReport: """
      query(\$placeId: Int) {
        crowdReport(placeId: \$placeId) {
          today_crowd_report {
            lowest_today_crowd {
              time_period
              hour
              people_no
            }
            highest_today_crowd {
              time_period
              hour
              people_no
            }
          }
          week_crowd_report {
            type
            highest_average_crowd {
              time_period
              hour
              people_no
            }
            lowest_average_crowd {
              time_period
              hour
              people_no
            }
            average_people_no {
              time_period
              people_no
            }
          }
          various {
            tomorrow_people_no_at_same_time
            least_crowded_day_same_time
          }
        }
      }
    """
  };

  static Map<GraphQlMutation, String> mutations = {
    GraphQlMutation.login: """
      mutation Login(\$username: String!, \$password: String!) {
        login(username: \$username, password: \$password) {
          token
          user {
            username
            password
          }
        }
      }
    """
  };
}
