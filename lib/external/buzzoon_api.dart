import 'package:buzzoon/controller/profile_provider/profile_provider.dart';
import 'package:nostr/nostr.dart';

class BuzzonAPI {
  static postEvent(String content) async {
    // TODO: need to implement BuzzonAPI::postEvent
  }

  static updateProfile(String name, String about, String picture) async {
    // TODO: need to implement BuzzonAPI::updateProfile
  }

  static Future<ProfileData> getProfile(String pubHex) async {
    //BigInt shortPkey
    // TODO: need to implement BuzzonAPI::getProfile
    return ProfileData(name: 'name', picture: 'picture', about: 'about', pubHex: 'pubHex');
  }

  // TEMPORAL API
  static gatherData() async {
    // TODO: need to implement BuzzonAPI::gatherData
  }

  static Future<List<Event>> getEvents(int since, int until) async {
    // TODO: need to implement BuzzonAPI::getEvents
    return [Event("0", "0", 0, 0, [["hoge"]], "content", "sig")];
  }
}