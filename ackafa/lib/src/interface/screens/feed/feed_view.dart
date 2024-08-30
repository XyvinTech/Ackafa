import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kssia/src/data/services/api_routes/requirement_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/requirement_model.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/common/customModalsheets.dart';
import 'package:kssia/src/interface/common/loading.dart';

class FeedView extends StatefulWidget {
  FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final TextEditingController requirementContentController =
      TextEditingController();

  File? _requirementImage;
  ApiRoutes api = ApiRoutes();

  Future<File?> _pickFile({required String imageType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'png',
        'jpg',
        'jpeg',
      ],
    );

    if (result != null) {
      setState(() {
        _requirementImage = File(result.files.single.path!);
      });
      return _requirementImage;
    }
  }

  void _openModalSheet({required String sheet}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return ShowAddRequirementSheet(
            pickImage: _pickFile,
            context1: context,
            textController: requirementContentController,
            imageType: 'requirement',
            requirementImage: _requirementImage,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncRequirements = ref.watch(fetchRequirementsProvider(token));
        return Scaffold(
          body: asyncRequirements.when(
            loading: () => Center(child: LoadingAnimation()),
            error: (error, stackTrace) {
              // Handle error state
              return Center(
                child: Text('Error loading promotions: $error'),
              );
            },
            data: (requirements) {
              print(requirements);
              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search your requirements',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 216, 211, 211),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 216, 211, 211),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                              color: Color.fromARGB(255, 216, 211, 211),
                            ),
                          ),
                        ),
                      )),
                  SizedBox(height: 16),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: requirements.length,
                    itemBuilder: (context, index) {
                      final requirement = requirements[index];
                      if (requirement.status == 'approved') {
                        return _buildPost(
                          withImage: requirement.image != null &&
                              requirement.image!.isNotEmpty,
                          requirement: requirement,
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  ),
                  SizedBox(
                    height: 40,
                  )
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _openModalSheet(sheet: 'requirement'),
            label: const Text(
              'Add Post',
              style: TextStyle(color: Colors.white),
            ),
            icon: const Icon(
              Icons.add,
              color: Colors.white,
              size: 27,
            ),
            backgroundColor: const Color(0xFFE30613),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPost(
      {bool withImage = false, required Requirement requirement}) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(userProvider);
        return Card(
            color: Colors.white,
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 16.0),
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Color.fromARGB(255, 213, 208, 208)),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: asyncUser.when(
              loading: () => Center(child: LoadingAnimation()),
              error: (error, stackTrace) {
                // Handle error state
                return Center(
                  child: Text('Error loading promotions: $error'),
                );
              },
              data: (user) {
                print(user);
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (withImage) ...[
                        SizedBox(height: 16),
                        Container(
                          height: 200,
                          width: double.infinity,
                          child: Image.network(
                            fit: BoxFit.cover,
                            requirement.image!,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.network(
                                  fit: BoxFit.cover,
                                  'https://placehold.co/600x400');
                            },
                          ),
                        )
                      ],
                      SizedBox(height: 16),
                      Text(
                        requirement.content!,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          ClipOval(
                            child: Container(
                              width: 30,
                              height: 30,
                              color: const Color.fromARGB(255, 255, 255, 255),
                              child: Image.network(
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.person);
                                },
                                user.profilePicture!, // Replace with your image URL
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${requirement.author!.name!.firstName} ${requirement.author!.name!.middleName} ${requirement.author!.name!.lastName}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                              Text(
                                user.companyName!,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(
                            requirement.createdAt.toString(),
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ));
      },
    );
  }
}

class PostWidget extends StatelessWidget {
  final String authorName;
  final String companyName;
  final String timestamp;
  final String content;
  final String imagePath;

  PostWidget({
    required this.authorName,
    required this.companyName,
    required this.timestamp,
    required this.content,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8),
          Image(image: NetworkImage(imagePath)),
          SizedBox(height: 8),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                    'assets/images/avatar.png'), // Replace with your avatar image path
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    authorName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(companyName),
                ],
              ),
              Spacer(),
              Text(timestamp),
            ],
          ),
        ],
      ),
    );
  }
}
