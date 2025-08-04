import 'package:ecomagara/datasource/models/diyModel.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:ecomagara/config/colors.dart';

class DiyDetailPage extends StatefulWidget {
  final DiyModel diy;

  const DiyDetailPage({super.key, required this.diy});

  @override
  State<DiyDetailPage> createState() => _DiyDetailPageState();
}

class _DiyDetailPageState extends State<DiyDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    if (widget.diy.youtube.isNotEmpty) {
      final videoId = YoutubePlayer.convertUrlToId(widget.diy.youtube);
      if (videoId != null) {
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
        );
      } else {
        _videoController = VideoPlayerController.networkUrl(
            Uri.parse(widget.diy.youtube),
          )
          ..initialize().then((_) {
            setState(() {});
          });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _videoController?.dispose();
    _youtubeController?.dispose();
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
          // Custom app bar with image background
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
                // Gradient overlay
                Container(
                  color: Colors.black.withOpacity(0.5),
                ),
                // App bar content
                SafeArea(
                  child: Column(
                    children: [
                      const Spacer(),
                      // Title and description at bottom
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

          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            decoration: const BoxDecoration(color: Colors.white),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: const Color(0xFFFF6B35), // Orange color from the design
                borderRadius: BorderRadius.zero,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600),
              unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
              tabs: const [
                Tab(text: 'Text'),
                Tab(text: 'Video'),
              ],
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

          // Materials list
          ...widget.diy.materials.map(
            (m) => Padding(
              padding: const EdgeInsets.only(bottom: 4, left: 20),
              child: Text('• $m'),
            ),
          ),

          const SizedBox(height: 30),

          // Steps
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
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: AppColors.primaryVariant, // Green color from design
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
          if (widget.diy.youtube.isEmpty)
            const Center(child: Text('No video available'))
          else if (_youtubeController != null)
            YoutubePlayer(
              controller: _youtubeController!,
              showVideoProgressIndicator: true,
              progressIndicatorColor: AppColors.primary,
            )
          else if (_videoController == null ||
              !_videoController!.value.isInitialized)
            const Center(child: CircularProgressIndicator())
          else
            AspectRatio(
              aspectRatio: _videoController!.value.aspectRatio,
              child: VideoPlayer(_videoController!),
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
