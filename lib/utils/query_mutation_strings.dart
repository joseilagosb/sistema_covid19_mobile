class QueryMutationStrings {
  String allServices() {
    return """
      query{
        allServices{
          id
          serviceName
        }
      }
      """;
  }

  String allPlaceTypes() {
    return """
      query{
        allPlaceTypes{
          id
          placeTypeName
        }
      }
      """;
  }

  String allIndicators() {
    return """
    query{
      allIndicators{
        indicatorName
        indicatorType
        indicatorDescription
      }
    }
      """;
  }

  String travelScheduler() {
    return """
      query(\$filter: Int, \$parameters: [Int], \$city: String, 
      \$startingPointLatitude: Float, \$startingPointLongitude: Float,
      \$exitTime: String, \$exitDay: Int, \$indicatorCategory: Int, \$preference: Int, 
      \$transportType: Int){

        travelScheduler(filter: \$filter, parameters: \$parameters, city: \$city, 
          startingPointLatitude: \$startingPointLatitude, 
          startingPointLongitude: \$startingPointLongitude,
          exitTime: \$exitTime, exitDay: \$exitDay, indicatorCategory: \$indicatorCategory, 
          preference: \$preference, transportType: \$transportType){
          
          response
          errorLog{
            reason
            conflictingParameters
          }
          travelTime
          places{
            place{
              id
              placeShortName
              placeAddress
              placeType{
                id
                placeTypeName
              }
              services{
                id
                serviceName
                serviceDescription
              }
              coordinates{
                latitude
                longitude
              }
            }
            crowdsNextHours
            queuesNextHours
            distanceToStart
          }
        }

      }
    """;
  }
}
