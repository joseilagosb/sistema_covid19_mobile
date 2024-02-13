import 'package:flutter/material.dart';

class CrowdRecommendations extends StatefulWidget {
  const CrowdRecommendations({super.key, required this.crowdReport});
  final Map<String, dynamic> crowdReport;

  @override
  State<CrowdRecommendations> createState() => _CrowdRecommendationsState();
}

class _CrowdRecommendationsState extends State<CrowdRecommendations> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
