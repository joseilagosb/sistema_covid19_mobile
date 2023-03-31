import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vacapp_mobile/classes/indicator.dart';
import 'package:vacapp_mobile/classes/placeReport.dart';
import 'package:vacapp_mobile/classes/travelReport.dart';
import 'package:vacapp_mobile/services/graphql_conf.dart';
import 'package:vacapp_mobile/utils/query_mutation_strings.dart';

import 'package:vacapp_mobile/classes/place.dart';
import 'package:vacapp_mobile/classes/placeType.dart';
import 'package:vacapp_mobile/classes/service.dart';
import 'package:vacapp_mobile/classes/area.dart';
import 'package:vacapp_mobile/classes/coordinate.dart';

class GraphQLFunctions {
  static QueryMutationStrings queryMutation = QueryMutationStrings();
  static GraphQLClient client = GraphQLConfiguration().clientToQuery();

  static Future<List<Area>> fillAreasList() async {
    QueryResult result = await client.query(
      QueryOptions(
        document: gql(
          queryMutation.allAreas(),
        ),
      ),
    );

    if (result.data == null) return [];

    List<Area> areas = result.data!['allAreas'].map((area) => Area.fromJSON(area));
    return areas;
  }

  static Future<List<Place>> fillPlacesList() async {
    QueryResult result = await client.query(
      QueryOptions(
        document: gql(
          queryMutation.allPlaces(),
        ),
      ),
    );

    if (result.data == null) return [];

    List<Place> places = result.data!["allPlaces"].map((place) => Place.mapViewFromJSON(place));
    return places;
  }

  static Future<List<Place>> fillPlacesSearch() async {
    QueryResult result = await client.query(
      QueryOptions(
        document: gql(
          queryMutation.allPlacesNamesTypesOnly(),
        ),
      ),
    );

    if (result.data == null) return [];

    List<Place> places = result.data!["allPlaces"].map((place) => Place.searchViewFromJSON(place));
    return places;
  }

  static Future<List<Place>> fillPlacesListByService(List<int> services) async {
    QueryResult result = await client.query(
      QueryOptions(
        document: gql(queryMutation.placesByService()),
        variables: <String, dynamic>{
          'placeServices': services,
        },
      ),
    );

    if (result.data == null) return [];

    List<Place> places =
        result.data!['placesByService'].map((place) => Place.mapViewFromJSON(place));
    return places;
  }

  static Future<List<Place>> fillPlacesListByPlaceType(List<int> placeTypes) async {
    QueryResult result = await client.query(
      QueryOptions(
        document: gql(queryMutation.placesByType()),
        variables: <String, dynamic>{
          'placeTypes': placeTypes,
        },
      ),
    );

    if (result.data == null) return [];

    List<Place> places = result.data!['placesByType'].map((place) => Place.mapViewFromJSON(place));
    return places;
  }

  static Future<Place?> fillPlace(int id) async {
    QueryResult result = await client.query(
      QueryOptions(
        document: gql(queryMutation.placeById()),
        variables: <String, dynamic>{
          'id': id,
        },
      ),
    );

    if (result.data == null) return null;
    return Place.fromJSON(result.data!['placeById']);
  }

  static Future<List<Service>> fillServicesList() async {
    QueryResult result = await client.query(
      QueryOptions(
        document: gql(
          queryMutation.allServices(),
        ),
      ),
    );

    if (result.data == null) return [];

    List<Service> services =
        result.data!['allServices'].map((service) => Service.mapFilterFromJSON(service));
    return services;
  }

  static Future<List<PlaceType>> fillPlaceTypesList() async {
    QueryResult result = await client.query(
      QueryOptions(
        document: gql(
          queryMutation.allPlaceTypes(),
        ),
      ),
    );

    if (result.data == null) return [];

    List<PlaceType> placeTypes =
        result.data!['allPlaceTypes'].map((placeType) => PlaceType.fromJSON(placeType));
    return placeTypes;
  }

  static Future<List<Indicator>> fillIndicatorsList() async {
    QueryResult result = await client.query(
      QueryOptions(
        document: gql(
          queryMutation.allIndicators(),
        ),
      ),
    );

    if (result.data == null) return [];

    List<Indicator> indicators =
        result.data!['allIndicators'].map((indicator) => Indicator.feedbackFromJSON(indicator));
    return indicators;
  }

  static Future<Map<int, Map<String, dynamic>>> fillPlaceDataByDayHour(int day, int hour) async {
    QueryResult result = await client.query(QueryOptions(
        document: gql(queryMutation.allPlacesDataByDayHour()),
        variables: <String, dynamic>{'day': day, 'hour': hour}));

    if (result.data == null) return {};

    Map<int, Map<String, dynamic>> placeDataByDayHour = {};
    for (var placeDataElement in result.data!['allPlacesDataByDayHour']) {
      placeDataByDayHour[placeDataElement['placeId']] = {
        'placeId': placeDataElement['placeId'],
        'day': day,
        'hour': hour,
        'crowdPeopleNo': placeDataElement['crowdPeopleNo'],
        'queuePeopleNo': placeDataElement['queuePeopleNo'],
        'covidSafetyScore': placeDataElement['covidSafetyScore'].toDouble(),
        'serviceQualityScore': placeDataElement['serviceQualityScore'].toDouble()
      };
    }
    return placeDataByDayHour;
  }

  static Future<TravelReport?> generateTravelReport(
      int filter,
      List parameters,
      String city,
      double startingPointLatitude,
      double startingPointLongitude,
      String exitTime,
      int exitDay,
      int indicatorCategory,
      int preference,
      int transportType) async {
    TravelReport travelReport;

    QueryResult result = await client.query(
      QueryOptions(
        document: gql(queryMutation.travelScheduler()),
        variables: <String, dynamic>{
          'filter': filter,
          'parameters': parameters,
          'city': city,
          'startingPointLatitude': startingPointLatitude,
          'startingPointLongitude': startingPointLongitude,
          'exitTime': exitTime,
          'exitDay': exitDay,
          'indicatorCategory': indicatorCategory,
          'preference': preference,
          'transportType': transportType
        },
      ),
    );

    if (result.data == null) return null;

    Map<String, dynamic> travelSchedulerObj = result.data!['travelScheduler'];
    if (travelSchedulerObj["response"] == "Failure") {
      return TravelReport(
        response: travelSchedulerObj['response'],
        reason: travelSchedulerObj['errorLog']['reason'],
        conflictingParameters: travelSchedulerObj['errorLog']['conflictingParameters'],
      );
    }

    List<PlaceReport> placeReports = [];
    for (var i = 0; i < travelSchedulerObj['places'].length; i++) {
      Map<String, dynamic> placeObj = travelSchedulerObj["places"][i];

      List<Coordinate> coordinates = placeObj['coordinates'].map(
        (coordinate) => Coordinate(coordinate["latitude"], coordinate["longitude"]),
      );
      List<Service> services = placeObj["services"].map(
        (service) => Service(
          service["id"],
          service["serviceName"],
          service["service_description"],
        ),
      );
      PlaceType placeType = PlaceType(
        int.parse(placeObj['placeType']['id']),
        placeObj['placeType']['placeTypeName'],
      );

      Place place = Place.travelRecommendation(
        int.parse(placeObj['id']),
        placeObj['placeShortName'],
        placeType,
        placeObj['placeAddress'],
        coordinates,
        services,
      );

      placeReports.add(
        PlaceReport(
          place,
          placeObj['crowdsNextHours'],
          placeObj['queuesNextHours'],
          placeObj['distanceToStart'],
        ),
      );
    }

    travelReport = TravelReport(
      placeReports: placeReports,
      response: travelSchedulerObj['response'],
      travelTime: travelSchedulerObj['travelTime'],
    );

    return travelReport;
  }

  static Future<Map<String, dynamic>> generateCrowdReport(int placeId) async {
    QueryResult result = await client.query(
      QueryOptions(
        document: gql(queryMutation.getCrowdReport()),
        variables: <String, dynamic>{
          'placeId': placeId,
        },
      ),
    );

    if (result.data == null) return {};
    return result.data!['crowdReport'];
  }
}
