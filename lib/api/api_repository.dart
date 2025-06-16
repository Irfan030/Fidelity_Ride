import 'api_endpoint.dart';
import 'api_provider.dart';

class APIRepository {
  static final _singleton = APIRepository();

  static APIRepository get instance => _singleton;

  Future<APIResponse> login(data) async {
    return await APIProvider.instance.post(ApiEndpoint.login, data);
  }
}
