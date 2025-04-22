import 'dart:convert';

import 'package:http/http.dart' as http;

class GooglePlaceService {
  final String apiKey = 'AIzaSyDEQuMizKGG3iBx96RZWckPjQso8lFQ6V4';

  Future<List<String>> fetchSuggestions(String input) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return List<String>.from(
          data['predictions'].map((p) => p['description']),
        );
      } else {
        print('Error fetching predictions: ${data['status']}');
      }
    }
    return [];
  }

  Future<Map<String, dynamic>?> fetchPlaceDetails(
    String placeDescription,
  ) async {
    final String autocompleteUrl =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeDescription&key=$apiKey';

    final response = await http.get(Uri.parse(autocompleteUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK' && data['predictions'].isNotEmpty) {
        final placeId = data['predictions'][0]['place_id'];
        final placeDetailsUrl =
            'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';

        final detailsResponse = await http.get(Uri.parse(placeDetailsUrl));
        if (detailsResponse.statusCode == 200) {
          final detailsData = json.decode(detailsResponse.body);
          if (detailsData['status'] == 'OK') {
            final location = detailsData['result']['geometry']['location'];
            return {
              'address': placeDescription,
              'latitude': location['lat'],
              'longitude': location['lng'],
            };
          }
        }
      }
    }

    return null;
  }
}
