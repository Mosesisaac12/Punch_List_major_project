import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SubcontractorDropdown extends StatefulWidget {
  @override
  _SubcontractorDropdownState createState() => _SubcontractorDropdownState();
}

class _SubcontractorDropdownState extends State<SubcontractorDropdown> {
  List<String> subcontractors =
      <String>[]; // List to store subcontractors' names
  String? selectedSubcontractor; // Currently selected subcontractor

  @override
  void initState() {
    super.initState();
    retrieveSubcontractors();
  }

  void retrieveSubcontractors() async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('users')
        .doc('Category of Users')
        .collection('Contractor')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Subcontractor List')
        .get();

    setState(() {
      subcontractors =
          snapshot.docs.map((doc) => doc.data()['name'] as String).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: selectedSubcontractor,
      hint: Text('Select a subcontractor'),
      onChanged: (newValue) {
        setState(() {
          selectedSubcontractor = newValue;
        });
      },
      items: subcontractors.map((subcontractor) {
        return DropdownMenuItem<String>(
          value: subcontractor,
          child: Text(subcontractor),
        );
      }).toList(),
    );
  }
}
