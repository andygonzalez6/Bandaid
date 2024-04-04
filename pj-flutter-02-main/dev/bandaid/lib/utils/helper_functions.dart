import 'package:bandaid/model/message.dart';
import 'package:bandaid/model/user.dart';

List<String> convertToList(List<dynamic> l) {
  List<String> list = [];
  for (int i = 0; i < l.length; i++) {
    list = list + [l[i]["name"]];
  }
  return list;
}

List<int> convertToID(List<bool> l) {
  List<int> list = [];
  for (int i = 0; i < l.length; i++) {
    if (l[i]) {
      list.add(i + 1);
    }
  }
  return list;
}

List<String> getNames(List<dynamic> l) {
  List<String> names = []; //create an empty list to store the names
  for (Map<String, dynamic> m in l) {
    //loop through each map in the list
    if (m.containsKey("name")) {
      //check if the map has a "name" key
      names.add(
          m["name"]); //add the value of the "name" key to the list of names
    }
  }
  return names;
}