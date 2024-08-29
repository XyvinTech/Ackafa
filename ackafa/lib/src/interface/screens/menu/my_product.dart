import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/providers/user_provider.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/interface/common/cards.dart';
import 'package:kssia/src/interface/common/customModalsheets.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';

class MyProductPage extends ConsumerStatefulWidget {
  MyProductPage({super.key});

  @override
  ConsumerState<MyProductPage> createState() => _MyProductPageState();
}

class _MyProductPageState extends ConsumerState<MyProductPage> {
  String _productPriceType = 'Price per unit';
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController =
      TextEditingController();
  final TextEditingController productMoqController = TextEditingController();
  final TextEditingController productActualPriceController =
      TextEditingController();
  final TextEditingController productOfferPriceController =
      TextEditingController();
  File? _productImageFIle;

  ApiRoutes api = ApiRoutes();

  String productUrl = '';

  Future<File?> _pickFile({required String imageType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg', 'pdf'],
    );

    if (result != null) {
      if (imageType == 'product') {
        _productImageFIle = File(result.files.single.path!);
        return _productImageFIle;
      }
    }

    return null;
  }

   _addNewProduct() async {
    final createdProduct = await api.uploadProduct(
        token,
        productNameController.text,
        productActualPriceController.text,
        productDescriptionController.text,
        productMoqController.text,
        _productImageFIle!,
        id);
    if (createdProduct == null) {
      print('couldnt create new product');
    } else {
      productUrl =
          await api.createFileUrl(file: _productImageFIle!, token: token);
      final newProduct = Product(
        id: createdProduct.id,
        name: productNameController.text,
        image: productUrl,
        description: productDescriptionController.text,
        moq: int.parse(productMoqController.text),
        offerPrice: int.parse(productOfferPriceController.text),
        price: int.parse(productActualPriceController.text),
        sellerId: SellerId(id: id),
        status: true,
      );
      ref.read(userProvider.notifier).updateProduct(
          [...?ref.read(userProvider).value?.products, newProduct]);
    }
  }

  void _removeProduct(int index) async {
    await api
        .deleteFile(
            token, ref.read(userProvider).value!.products![index].image!)
        .then((value) => ref
            .read(userProvider.notifier)
            .removeProduct(ref.read(userProvider).value!.products![index]));
  }

  void _openModalSheet({required String sheet}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        if (sheet == 'product') {
          return ShowEnterProductsSheet(
              productImage: _productImageFIle,
              imageType: sheet,
              pickImage: _pickFile,
              addProductCard: _addNewProduct,
              productNameText: productNameController,
              descriptionText: productDescriptionController,
              moqText: productMoqController,
              actualPriceText: productActualPriceController,
              offerPriceText: productOfferPriceController,
              productPriceType: _productPriceType);
        } else {
          return SizedBox();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(userProvider);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'My Products',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(FontAwesomeIcons.whatsapp),
                onPressed: () {
                  // WhatsApp icon action
                },
              ),
            ],
          ),
          body: asyncUser.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) {
              return Center(
                child: Text('Error loading promotions: $error'),
              );
            },
            data: (user) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _InfoCard(
                              title: 'Products',
                              count: user.products!.length.toString(),
                            ),
                            const _InfoCard(title: 'Messages', count: '30'),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            hintText: 'Search',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.zero,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 1.0,
                              mainAxisSpacing: 2.0,
                              childAspectRatio: .89,
                            ),
                            itemCount: user.products!.length,
                            itemBuilder: (context, index) {
                              return ProductCard(
                                  product: user.products![index],
                                  onRemove: () => _removeProduct(index));
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: FloatingActionButton.extended(
                      onPressed: () {
                        _openModalSheet(sheet: 'product');
                      },
                      label: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          'Add Product',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 27,
                      ),
                      backgroundColor: const Color(0xFF004797),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String count;

  const _InfoCard({
    Key? key,
    required this.title,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final VoidCallback onPressed;
  final VoidCallback onMorePressed;

  const _ProductCard({
    required this.onPressed,
    required this.onMorePressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(8)),
                  color: Colors.grey[300], // Placeholder for image
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color:
                            Color.fromARGB(255, 0, 0, 0).withOpacity(0.00003),
                        spreadRadius: 0.002,
                        blurRadius: 0.002,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // More options action
                    },
                    iconSize: 14,
                    padding: EdgeInsets.zero, // Remove default padding
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 4),
                Text(
                  'Plastic Cartons',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '₹2000 ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      TextSpan(
                        text: '₹1224',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'MOQ: 100',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
