import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MenuPageShimmer extends StatelessWidget {
  const MenuPageShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile and Edit Section
              Row(
                children: [
                  // Profile Picture
                  _buildShimmerBox(height: 70, width: 75, borderRadius: 9),
                  const SizedBox(width: 16),
                  // Name and Phone
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerLine(width: 150, height: 20),
                        const SizedBox(height: 8),
                        _buildShimmerLine(width: 100, height: 16),
                      ],
                    ),
                  ),
                  // Edit Button
                  _buildShimmerLine(width: 50, height: 20),
                ],
              ),
              const SizedBox(height: 20),
              // Account Section Label
              _buildShimmerBox(height: 50, width: double.infinity),
              const SizedBox(height: 13),
              // Menu Items
              _buildShimmerMenuItem(),
              _buildShimmerDivider(),
              _buildShimmerMenuItem(),
              _buildShimmerDivider(),
              _buildShimmerMenuItem(),
              _buildShimmerDivider(),
              _buildShimmerMenuItem(),
              _buildShimmerDivider(),
              _buildShimmerMenuItem(),

              _buildShimmerDivider(),
              _buildShimmerMenuItem(),
              _buildShimmerDivider(),
              _buildShimmerMenuItem(),
              _buildShimmerDivider(),
              _buildShimmerMenuItem(),
              _buildShimmerDivider(),
              _buildShimmerMenuItem(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerBox(
      {double height = 50,
      double width = double.infinity,
      double borderRadius = 0}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _buildShimmerLine(
      {double width = double.infinity, double height = 16}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        color: Colors.grey.shade300,
      ),
    );
  }

  Widget _buildShimmerMenuItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          // Icon
          _buildShimmerBox(height: 24, width: 24, borderRadius: 4),
          const SizedBox(width: 16),
          // Menu Text
          _buildShimmerLine(width: 120, height: 16),
        ],
      ),
    );
  }

  Widget _buildShimmerDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: _buildShimmerLine(width: double.infinity, height: 1),
    );
  }
}
