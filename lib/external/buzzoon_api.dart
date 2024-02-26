import 'package:flustr/controller/profile_provider/profile_provider.dart';
import 'package:nostr/nostr.dart';

class BuzzonAPI {
  static postEvent(String content){
    // TODO: need to implement BuzzonAPI::postEvent
  }

  static updateProfile(String name, String about, String picture){
    // TODO: need to implement BuzzonAPI::updateProfile
  }

  static ProfileData getProfile(String pubHex)  {
    //BigInt shortPkey
    // TODO: need to implement BuzzonAPI::getProfile
    return ProfileData(name: 'name', picture: 'picture', about: 'about', pubHex: 'pubHex');
  }

  // TEMPORAL API
  static gatherData(){
    // TODO: need to implement BuzzonAPI::gatherData
  }

  static List<Event> getEvents(int since, int until) {
    // TODO: need to implement BuzzonAPI::getEvents
    return [Event("0", "0", 0, 0, [["hoge"]], "content", "sig")];
  }
}