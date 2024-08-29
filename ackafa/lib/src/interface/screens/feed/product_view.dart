import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:kssia/src/data/models/chat_model.dart';
import 'package:kssia/src/data/services/api_routes/chat_api.dart';
import 'package:kssia/src/data/services/api_routes/products_api.dart';
import 'package:kssia/src/data/services/api_routes/user_api.dart';
import 'package:kssia/src/data/globals.dart';
import 'package:kssia/src/data/models/product_model.dart';
import 'package:kssia/src/data/models/user_model.dart';
import 'package:kssia/src/data/services/getRatings.dart';
import 'package:kssia/src/interface/common/cards.dart';
import 'package:kssia/src/interface/common/custom_button.dart';
import 'package:kssia/src/interface/common/loading.dart';
import 'package:kssia/src/interface/screens/people/chat/chatscreen.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

class ProductView extends StatelessWidget {
  const ProductView({super.key});
  void _showProductDetails({required BuildContext context, required product}) {
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) => ProductDetailsModal(
        product: product,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final searchQuery = ref.watch(searchQueryProvider);
      final productsAsyncValue = ref.watch(fetchProductsProvider(token));

      return Scaffold(
        body: productsAsyncValue.when(
          data: (products) {
            final filteredProducts = products.where((product) {
              return product.name!
                  .toLowerCase()
                  .contains(searchQuery.toLowerCase());
            }).toList();
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        onChanged: (query) {
                          ref.read(searchQueryProvider.notifier).state = query;
                        },
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Search your Products',
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
                  if (filteredProducts.isNotEmpty)
                    GridView.builder(
                      shrinkWrap:
                          true, // Let GridView take up only as much space as it needs
                      physics:
                          NeverScrollableScrollPhysics(), // Disable GridView's internal scrolling
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 1.0,
                        mainAxisSpacing: 2.0,
                        childAspectRatio: .89,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _showProductDetails(
                              context: context, product: products[index]),
                          child: ProductCard(
                            product: filteredProducts[index],
                            onRemove: null,
                          ),
                        );
                      },
                    )
                  else
                    Column(
                      children: [
                        SizedBox(height: 100),
                        SvgPicture.asset(
                          'assets/icons/feed_productBag.svg',
                          height: 120,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Search for Products',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'that you need',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      );
    });
  }
}

class ProductDetailsModal extends StatefulWidget {
  final Product product;

  const ProductDetailsModal({super.key, required this.product});

  @override
  _ProductDetailsModalState createState() => _ProductDetailsModalState();
}

class _ProductDetailsModalState extends State<ProductDetailsModal> {
  TextEditingController _quantityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _quantityController.text = '0'; // Initial value
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _incrementQuantity() {
    setState(() {
      int currentValue = int.tryParse(_quantityController.text) ?? 0;
      _quantityController.text = (currentValue + 1).toString();
    });
  }

  void _decrementQuantity() {
    setState(() {
      int currentValue = int.tryParse(_quantityController.text) ?? 0;
      if (currentValue > 0) {
        _quantityController.text = (currentValue - 1).toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final asyncUser = ref.watch(
            fetchUserDetailsProvider(token, widget.product.sellerId!.id!));

        ChatModel sourcChat = ChatModel(
            name: '',
            icon: '',
            time: '',
            currentMessage: '',
            id: id,
            unreadMessages: 0);
        ChatModel receiverChat = ChatModel(
            name:
                '${widget.product.sellerId!.name!.firstName!} ${widget.product.sellerId!.name!.middleName!} ${widget.product.sellerId!.name!.lastName!}',
            icon: '',
            time: '',
            currentMessage: '',
            id: widget.product.sellerId!.id!,
            unreadMessages: 0);
        return Material(
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                SizedBox(height: 16),
                Container(
                  width: 60,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Image.network(
                          widget.product.image!, // Replace with your image URL
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.network(
                              'https://placehold.co/600x400/png',
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        Text(
                          widget.product.name!,
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        widget.product.offerPrice != null
                            ? Text(
                                'INR ${widget.product.offerPrice} / piece',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              )
                            : Text(
                                'INR ${widget.product.price} / piece',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue),
                              ),
                        Text(
                          'MOQ : ${widget.product.moq}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        Text(
                          widget.product.description!,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        asyncUser.when(
                          data: (user) {
                            return Row(
                              children: [
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: ClipOval(
                                    child: Image.network(
                                      widget.product.sellerId!.id ??
                                          'https://placehold.co/600x400/png', // Fallback URL if sellerId is null
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Image.network(
                                          'https://placehold.co/600x400/png',
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        '${user!.name!.firstName} ${user.name!.middleName} ${user.name!.lastName}'),
                                    Text('${user.companyName}'),
                                  ],
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.orange),
                                    Text('4.5'),
                                    Text('(24 Reviews)'),
                                  ],
                                )
                              ],
                            );
                          },
                          loading: () =>
                              Center(child: CircularProgressIndicator()),
                          error: (error, stackTrace) {
                            return Center(
                              child: Text('Error loading user details: $error'),
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: _decrementQuantity,
                            ),
                            SizedBox(width: 16),
                            SizedBox(
                              height: 40,
                              width:
                                  250, // Increase this value to expand the horizontal width
                              child: TextField(
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 235, 229, 229),
                                      width: 2.0, // Border width
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 235, 229, 229),
                                      width: 1.0, // Border width when focused
                                    ),
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 8.0),
                                ),
                                onChanged: (value) {
                                  if (int.tryParse(value) == null) {
                                    _quantityController.text = '0';
                                  }
                                },
                              ),
                            ),
                            SizedBox(width: 16),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: _incrementQuantity,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),

                        // final chat = chats.firstWhere((chat) =>
                        //     chat.id == widget.product.sellerId!.id!);

                        customButton(
                            label: 'Get Qoute',
                            onPressed: () async {
                              await sendChatMessage(
                                  userId: widget.product.sellerId!.id!,
                                  from: id,
                                  content:
                                      '''I need ${_quantityController.text} of ${widget.product.name} \nLet\'s Connect!''');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => IndividualPage(
                                        chatModel: receiverChat,
                                        sourchat: sourcChat,
                                      )));
                            },
                            fontSize: 16)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
