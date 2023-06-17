// import 'dart:convert';
// import 'package:flutter/widgets.dart';
// import 'package:http/http.dart';

// class LoginDataProvider with ChangeNotifier {
//   String? _token;
//   bool isAuth = false;
//   String? get token {
//     if (_token != null) {
//       return _token;
//     }
//     return null;
//   }

//   Future<Response> login(
//     String fullname,
//     String username,
//     String mobileNo,
//   ) async {
//     final body = json.encode(
//       {
//         'fullname': username,
//         'username': username,
//         'mobile_no': mobileNo,
//       },
//     );
//     print(body);

//     final url = Uri.parse('http://104.236.1.97:5000/sub_contractor/');
//     try {
//       final response = await post(url,
//           headers: {'Content-Type': 'application/json'}, body: body);
//       final responseBody = json.decode(response.body);
//       if (response.statusCode == 200) {
//         _token = responseBody['token'];
//         if (_token != null) {
//           isAuth = true;
//           notifyListeners();
//         }
//         print(_token);

//         return response;
//       } else {
//         return response;
//       }
//     } catch (error) {
//       rethrow;
//     }
//   }
// }

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:punch_list/models/subcontractor_form.dart';

class AddSubcontractorNotifier extends StateNotifier<List<Subcontractor>> {
  AddSubcontractorNotifier() : super([]);

  void addSubcontractor(Subcontractor subcontractor) {
    final newSubcontractor = Subcontractor(
      name: subcontractor.name,
      email: subcontractor.email,
      phone: subcontractor.phone,
    );
    state = [newSubcontractor, ...state];
  }
}

final subcontractorProvider =
    StateNotifierProvider<AddSubcontractorNotifier, List<Subcontractor>>((ref) {
  return AddSubcontractorNotifier();
});
