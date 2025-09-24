import 'package:flutter/material.dart';
import 'package:fluttertopics/demo_screen_map.dart';
import 'package:get/get.dart';
import '../models/topic_model.dart';

class TopicDetailScreen extends StatelessWidget {
  final TopicModel topic;

  const TopicDetailScreen({super.key, required this.topic});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(topic.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.category, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          topic.category,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(width: 16),
                        Icon(
                          Icons.date_range,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          topic.date,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Description Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'description'.tr,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      topic.description,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),

            // Subcategory Card (if available)
            if (topic.subcategory != null) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'subcategory'.tr,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        topic.subcategory!,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Add to favorites functionality
                    Get.snackbar(
                      'Success',
                      'Added to favorites!',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: const Icon(Icons.favorite),
                  label: const Text('Add to Favorites'),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    // Share functionality
                    Get.snackbar(
                      'Share',
                      'Sharing: ${topic.title}',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                if (topic.demoScreen != null &&
                    demoScreens.containsKey(topic.demoScreen)) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: demoScreens[topic.demoScreen]!),
                  );
                } else {
                  Get.snackbar(
                    'Demo Not Available',
                    'No demo screen found for this topic.',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                }
              },
              icon: const Icon(Icons.play_circle_fill),
              label: const Text('Open Demo'),
            ),
          ],
        ),
      ),
    );
  }
}
