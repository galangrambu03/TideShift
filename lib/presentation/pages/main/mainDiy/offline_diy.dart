import 'package:ecomagara/datasource/models/diyModel.dart';
import 'package:flutter/material.dart';
import 'package:ecomagara/config/colors.dart';

class OfflineDiyDetailPage extends StatelessWidget {
  final DiyModel diy;

  const OfflineDiyDetailPage({super.key, required this.diy});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'DIY For Earth',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // custom header image with gradient and title
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(diy.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(
                  color: Colors.black.withOpacity(0.5), // overlay gelap
                ),
                SafeArea(
                  child: Column(
                    children: [
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              diy.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam eu turpis molestie, dictum est a, mattis tellus.',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.surface,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // content
          Expanded(
            child: _buildTextContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          const Center(
            child: Text(
              'Tools and Materials',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // materials
          ...diy.materials.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 20),
              child: Text('• $m'),
            ),
          ),

          const SizedBox(height: 30),

          // steps
          ...diy.steps.asMap().entries.map(
            (entry) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Step ${entry.key + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 30,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryVariant, // hijau sesuai desain
                  ),
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
