import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/topic_controller.dart';
import '../widgets/topic_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TopicController topicController = Get.find<TopicController>();
    final FocusNode searchFocusNode = FocusNode();
        final TranslationController translationController = Get.find<TranslationController>();


    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () {
              translationController.toggleLanguage;
              // Language toggle functionality can be added here
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          // Hide suggestions when tapping outside
          topicController.hideSuggestions();
          searchFocusNode.unfocus();
        },
        child: Column(
          children: [
            // Search Bar with Suggestions
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search TextField
                  TextField(
                    focusNode: searchFocusNode,
                    decoration: InputDecoration(
                      hintText: 'search_hint'.tr,
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Obx(() => topicController.searchQuery.value.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: topicController.clearSearch,
                                )
                              : const SizedBox.shrink()),
                          IconButton(
                            icon: const Icon(Icons.keyboard_arrow_down),
                            onPressed: () {
                              topicController.showSearchSuggestions();
                              searchFocusNode.requestFocus();
                            },
                          ),
                        ],
                      ),
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: topicController.searchTopics,
                    onTap: () {
                      topicController.showSearchSuggestions();
                    },
                  ),
                  
                  // Search Suggestions Dropdown
                  Obx(() {
                    if (!topicController.showSuggestions.value ||
                        topicController.searchSuggestions.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    
                    return Container(
                      margin: const EdgeInsets.only(top: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Suggestions Header
                          if (topicController.searchQuery.value.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    topicController.recentSearches.isNotEmpty 
                                        ? 'Recent Searches' 
                                        : 'Popular Searches',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  if (topicController.recentSearches.isNotEmpty)
                                    GestureDetector(
                                      onTap: topicController.clearRecentSearches,
                                      child: const Text(
                                        'Clear All',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          
                          // Suggestions List
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: topicController.searchSuggestions.length,
                              itemBuilder: (context, index) {
                                final suggestion = topicController.searchSuggestions[index];
                                final isRecent = topicController.recentSearches.contains(suggestion);
                                
                                return ListTile(
                                  dense: true,
                                  leading: Icon(
                                    topicController.getSuggestionIcon(suggestion),
                                    size: 20,
                                    color: Colors.grey[600],
                                  ),
                                  title: Text(
                                    suggestion,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  trailing: isRecent
                                      ? GestureDetector(
                                          onTap: () => topicController.removeRecentSearch(suggestion),
                                          child: Icon(
                                            Icons.close,
                                            size: 16,
                                            color: Colors.grey[400],
                                          ),
                                        )
                                      : Icon(
                                          Icons.north_west,
                                          size: 16,
                                          color: Colors.grey[400],
                                        ),
                                  onTap: () {
                                    topicController.selectSuggestion(suggestion);
                                    searchFocusNode.unfocus();
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            
            // Category Filter
            SizedBox(
              height: 50,
              child: Obx(() => ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: topicController.categories.length,
                itemBuilder: (context, index) {
                  final category = topicController.categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Obx(() => ChoiceChip(
                      label: Text(category.tr),
                      selected: topicController.selectedCategory.value == category,
                      onSelected: (_) => topicController.selectCategory(category),
                    )),
                  );
                },
              )),
            ),
            
            const SizedBox(height: 16),
            
            // Search Results Info
            Obx(() {
              if (topicController.searchQuery.value.isNotEmpty || 
                  topicController.selectedCategory.value != 'All') {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        '${topicController.filteredTopics.length} results',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                      if (topicController.searchQuery.value.isNotEmpty)
                        Text(
                          ' for "${topicController.searchQuery.value}"',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      const Spacer(),
                      if (topicController.searchQuery.value.isNotEmpty || 
                          topicController.selectedCategory.value != 'All')
                        TextButton(
                          onPressed: () {
                            topicController.clearSearch();
                            topicController.selectCategory('All');
                          },
                          child: const Text('Clear filters'),
                        ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            
            const SizedBox(height: 8),
            
            // Topics List
            Expanded(
              child: Obx(() {
                if (topicController.isLoading.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text('loading'.tr),
                      ],
                    ),
                  );
                }
                
                if (topicController.filteredTopics.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          topicController.searchQuery.value.isNotEmpty
                              ? 'No results for "${topicController.searchQuery.value}"'
                              : 'no_results'.tr,
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try different keywords or clear filters',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            topicController.clearSearch();
                            topicController.selectCategory('All');
                          },
                          child: const Text('Show All Topics'),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: topicController.filteredTopics.length,
                  itemBuilder: (context, index) {
                    final topic = topicController.filteredTopics[index];
                    return TopicCard(topic: topic);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}