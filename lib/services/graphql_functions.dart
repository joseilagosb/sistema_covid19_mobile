import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:vacapp_mobile/classes/indicator.dart';
import 'package:vacapp_mobile/classes/placeReport.dart';
import 'package:vacapp_mobile/classes/travelReport.dart';
import 'package:vacapp_mobile/utils/query_mutation_strings.dart';

import 'package:vacapp_mobile/classes/place.dart';
import 'package:vacapp_mobile/classes/placeType.dart';
import 'package:vacapp_mobile/classes/service.dart';
import 'package:vacapp_mobile/classes/coordinate.dart';

class GraphQLFunctions {
  static QueryMutationStrings queryMutation = QueryMutationStrings();
  static final GraphQLClient client = GraphQLClient(
    link: HttpLink("http://10.0.2.2:3000/graphql"),
    cache: GraphQLCache(store: InMemoryStore()),
  );

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
}
