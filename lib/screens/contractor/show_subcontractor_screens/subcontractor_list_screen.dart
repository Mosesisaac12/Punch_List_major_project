import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:punch_list/crud/subcontractor_crud.dart';
import '../../../models/subcontractor_form.dart';
import '../../../providers/sub_contractor/add_subcontractor.dart';

class SubContractorScreen extends ConsumerStatefulWidget {
  SubContractorScreen({super.key});

  @override
  ConsumerState<SubContractorScreen> createState() =>
      _SubContractorScreenState();
}

class _SubContractorScreenState extends ConsumerState<SubContractorScreen> {
  GlobalKey<FormState> subcontractorFormKey = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController profileImage = TextEditingController();

  late Future<List<Subcontractor>> _subcontractorsFuture;

  @override
  void initState() {
    super.initState();
    fetchSubcontractors();
  }

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  Future<List<Subcontractor>> fetchSubcontractors() async {
    final response = await get(
        Uri.parse('http://104.236.1.97:5000/sub_contractor/'),
        headers: {'Authorization': 'token'});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final subcontractors = List.from(data).map((item) {
        return Subcontractor.fromJson(item);
      }).toList();

      return subcontractors;
    } else {
      throw Exception('Failed to fetch subcontractors');
    }
  }

  void _saveSubcontractor() async {
    final isValid = subcontractorFormKey.currentState?.validate();
    if (!isValid!) {
      return;
    } else {
      subcontractorFormKey.currentState?.save();
      final subcontractor = Subcontractor(
        name: name.text,
        email: email.text,
        phone: phone.text,
      );

      final url = Uri.parse('http://104.236.1.97:5000/sub_contractor/');
      try {
        final response = await post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
            {
              'fullname': subcontractor.name,
              'username': subcontractor.email,
              'mobile_no': subcontractor.phone
            },
          ),
        );
        final responseData = json.decode(response.body);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          Navigator.of(context).pop();

          ref
              .read(subcontractorProvider.notifier)
              .addSubcontractor(subcontractor);

          final responseMessage = responseData['message'];

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(responseMessage),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          final responseMessage = responseData['message'];

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(responseMessage),
            backgroundColor: Colors.red,
          ));
        }
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Something went wrong, please check back later'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  // Future<void> updateSubcontractor(Subcontractor subcontractor) async {
  //   final response = await put(
  //     Uri.parse('http://104.236.1.97:5000/sub_contractor/${subcontractor.id}'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode({
  //       'name': subcontractor.name,
  //     }),
  //   );

  //   if (response.statusCode != 200) {
  //     throw Exception('Failed to update subcontractor');
  //   }
  // }

  Future<void> deleteSubcontractor(String id) async {
    final response =
        await delete(Uri.parse('http://104.236.1.97:5000/sub_contractor/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete subcontractor');
    }
  }

  void _showAddSubcontractorModal() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: subcontractorFormKey,
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text(
                'Add New Subcontractor',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phone,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: profileImage,
                decoration:
                    const InputDecoration(labelText: 'Profile Image URL'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a profile image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _saveSubcontractor,
                  child: const Text('ADD'),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subcontractors'),
      ),
      body: FutureBuilder<List<Subcontractor>>(
        future: _subcontractorsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            final subcontractors = snapshot.data!;
            return ListView.builder(
              itemCount: subcontractors.length,
              itemBuilder: (context, index) {
                final subcontractor = subcontractors[index];
                return ListTile(
                  title: Text(subcontractor.name!),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteSubcontractor(subcontractor);
                    },
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text('No subcontractors found.'),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSubcontractorModal,
        child: Icon(Icons.add),
      ),
    );
  }

  // void _navigateToCreateSubcontractor() async {
  //   final newSubcontractor = await Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => CreateSubcontractorScreen()),
  //   );

  //   if (newSubcontractor != null) {
  //     setState(() {
  //       _subcontractorsFuture = _subcontractorService.fetchSubcontractors();
  //     });
  //   }
  // }

  void _deleteSubcontractor(Subcontractor subcontractor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Subcontractor'),
        content: Text('Are you sure you want to delete ${subcontractor.name}?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              deleteSubcontractor;
            },
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
