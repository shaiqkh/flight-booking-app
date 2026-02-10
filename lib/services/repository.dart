import '../models/airport_model.dart';
import '../models/flight_model.dart';
import '../models/flight_detail_model.dart';
import '../models/search_request_model.dart';
import 'api_service.dart';

class FlightRepository {
  final ApiService api;

  FlightRepository(this.api);

  // GET /airports
  Future<List<AirportModel>> fetchAirports() {
    return api.getAirports();
  }

  // POST /flights/search
  Future<List<FlightModel>> searchFlights(SearchRequest request) {
    return api.searchFlights(request);
  }

  // GET /flights/:id
  Future<FlightDetailModel> fetchDetails(String id) {
    return api.getFlightDetails(id);
  }
}
