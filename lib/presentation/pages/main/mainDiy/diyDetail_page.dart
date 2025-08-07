import 'package:ecomagara/datasource/models/diyModel.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:ecomagara/config/colors.dart';

import 'package:webview_flutter/webview_flutter.dart';

class DiyDetailPage extends StatefulWidget {
  final DiyModel diy;

  const DiyDetailPage({super.key, required this.diy}); 

  @override
  State<DiyDetailPage> createState() => _DiyDetailPageState();
}

// 3. Hapus semua kode YouTube player dan ganti dengan ini:
class _DiyDetailPageState extends State<DiyDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final WebViewController webController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Setup WebView controller
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'DIY For Island',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Header with image (sama seperti sebelumnya)
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.diy.image),
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                Container(color: Colors.black.withOpacity(0.5)),
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
                              widget.diy.title,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              widget.diy.description,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.surface,
                                overflow: TextOverflow.ellipsis
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

          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: const BoxDecoration(color: Colors.white),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFFFF6B35),
                borderRadius: BorderRadius.zero,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              tabs: const [Tab(text: 'Text'), Tab(text: 'Video')],
            ),
          ),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildTextContent(), _buildVideoContent()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextContent() {
    // Sama seperti sebelumnya
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
          ...widget.diy.materials.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 20),
              child: Text('• $m'),
            ),
          ),
          const SizedBox(height: 30),
          ...widget.diy.steps.asMap().entries.map(
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
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: AppColors.primaryVariant,
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

  Widget _buildVideoContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Video dengan WebView - SOLUSI PALING SIMPEL
          if (widget.diy.youtube.isEmpty)
            const Center(child: Text('No video available'))
          else
            Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: WebViewWidget(
                  controller: webController
                    ..loadRequest(Uri.parse(widget.diy.youtube)),
                ),
              ),
            ),
          
          const SizedBox(height: 30),
          Center(
            child: Text(
              'Tools and Materials',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          const SizedBox(height: 20),
          ...widget.diy.materials.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 20),
              child: Text('• $m'),
            ),
          ),
        ],
      ),
    );
  }
}