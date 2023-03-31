class QueryMutationStrings {
  //Uso: Visualización en mapa

  String allAreas() {
    return """
      query{
        allAreas{
          id
          areaName
          coordinates{
            latitude
            longitude
          }
        }
      }
    """;
  }

  //Uso: Vista de mapa en la pantalla principal

  String allPlaces() {
    return """
      query{
        allPlaces{
          id
          placeShortName
          placeType{
            id
            placeTypeName
          }
          attentionSurface
          coordinates{
            latitude
            longitude
          }
          placeOpenHours{
            id
            dayOfWeekOpen
            openingTime
            closingTime
          }
        }
      }
    """;
  }

  String currentCrowdsDayTime() {
    return """
      query(\$day: Int, \$time: Int){
        currentCrowdsDayTime(day: \$day, time:\$time){
          placeId
          peopleNo
        }
      }
    """;
  }

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

  //Uso: Visualización en buscador

  String allPlacesNamesTypesOnly() {
    return """
      query{
        allPlaces{
          id
          placeName
          placeType{
            id
            placeTypeName
          }
        }
      }
    """;
  }

  //Uso: Filtro de lugares
  String placesByType() {
    return """
      query(\$placeTypes: [Int]){
        placesByType(placeTypes:\$placeTypes){
          id
          placeShortName
          placeType{
            id
            placeTypeName
          }
          attentionSurface
          coordinates{
            latitude
            longitude
          }
          placeOpenHours{
            id
            dayOfWeekOpen
            openingTime
            closingTime
          }       
        }
      }
    """;
  }

  //Uso: Filtro de lugares
  String placesByService() {
    return """
      query(\$placeServices: [Int]){
        placesByService(placeServices:\$placeServices){
          id
          placeShortName
          placeType{
            id
            placeTypeName
          }
          attentionSurface
          coordinates{
            latitude
            longitude
          }
          placeOpenHours{
            id
            dayOfWeekOpen
            openingTime
            closingTime
          }          
        }
      }
    """;
  }

  //Uso: Vista individual y estadísticas de un lugar

  String placeById() {
    return """
      query(\$id: ID!){
        placeById(id:\$id){
          id
          placeName
          placeShortName
          placeType{
            id
            placeTypeName
          }
          placeAddress
        	surface
    			attentionSurface          
          coordinates{
            latitude
            longitude
          }
          services{
            id
            serviceName
            serviceDescription
          }
          currentCrowds{
            id
            crowdDayOfWeek
            crowdHour
            peopleNo
          }
          currentQueues{
            id
            queueDayOfWeek
            queueHour
            peopleNo
          }
          placeOpenHours{
            id
            dayOfWeekOpen
            openingTime
            closingTime
          }
    			indicators{
            indicatorName
            indicatorType
            indicatorDescription
            indicatorValue
            opinionNo
          }          
        }
      }
    """;
  }

  String allPlacesDataByDayHour() {
    return """
      query(\$day: Int, \$hour: Int){
        allPlacesDataByDayHour(day: \$day, hour: \$hour){
          placeId
          dayOfWeek
          hourOfDay
          crowdPeopleNo
          queuePeopleNo
          covidSafetyScore
          serviceQualityScore         
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

  String getCrowdReport() {
    return """
      query(\$placeId: Int){
        crowdReport(placeId: \$placeId){
          todayCrowdReport{
            lowestTodayCrowd{
              timePeriod
              hour
              peopleNo
            }
            highestTodayCrowd{
              timePeriod
              hour
              peopleNo
            }
            leastCrowdedDaySameTime
            tomorrowSameTimePeopleNo
          }
          weekCrowdReport{
            highestAverageCrowd{
              timePeriod
              hour
              peopleNo
            }
            lowestAverageCrowd{
              timePeriod
              hour
              peopleNo
            }
            averagePeopleNo{
              timePeriod
              peopleNo
            }
          }
        }
      }
    """;
  }
}
