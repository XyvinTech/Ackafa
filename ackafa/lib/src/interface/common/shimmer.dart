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



class ProfileShimmer extends StatelessWidget {
  const ProfileShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Top action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildShimmerCircle(),
                const SizedBox(width: 10),
                _buildShimmerCircle(),
              ],
            ),
            const SizedBox(height: 20),
            // Profile picture and name
            Column(
              children: [
                _buildShimmerCircle(radius: 45),
                const SizedBox(height: 10),
                _buildShimmerLine(width: 120, height: 20),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildShimmerCircle(radius: 16),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildShimmerLine(width: 100, height: 16),
                        const SizedBox(height: 5),
                        _buildShimmerLine(width: 80, height: 14),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Member info
            _buildShimmerContainer(width: double.infinity, height: 40),
            const SizedBox(height: 20),
            // Contact details
            Column(
              children: [
                Row(
                  children: [
                    _buildShimmerCircle(radius: 12),
                    const SizedBox(width: 10),
                    _buildShimmerLine(width: 150, height: 16),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildShimmerCircle(radius: 12),
                    const SizedBox(width: 10),
                    _buildShimmerLine(width: 200, height: 16),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildShimmerCircle(radius: 12),
                    const SizedBox(width: 10),
                    Expanded(child: _buildShimmerLine(height: 16)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildShimmerCircle(radius: 12),
                    const SizedBox(width: 10),
                    _buildShimmerLine(width: 150, height: 16),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildShimmerCircle(radius: 12),
                    const SizedBox(width: 10),
                    _buildShimmerLine(width: 150, height: 16),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCircle({double radius = 25}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: radius * 2,
        height: radius * 2,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildShimmerLine({double width = double.infinity, double height = 16}) {
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

  Widget _buildShimmerContainer({double width = double.infinity, double height = 16}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
