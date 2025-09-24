import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/topic_model.dart';
import '../services/api_service.dart';

class TopicController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  
  // Observable variables
  final RxList<TopicModel> topics = <TopicModel>[].obs;
  final RxList<TopicModel> filteredTopics = <TopicModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'All'.obs;
  final RxBool showSuggestions = false.obs;
  
  // Available categories
  final RxList<String> categories = <String>['All'].obs;
  
  // Search suggestions
  final RxList<String> searchSuggestions = <String>[].obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxList<String> popularSearches = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadTopics();
    loadPopularSearches();
  }

  Future<void> loadTopics() async {
    try {
      isLoading.value = true;
      final loadedTopics = await _apiService.loadTopicsFromAssets();
      topics.value = loadedTopics;
      filteredTopics.value = loadedTopics;
      
      // Extract unique categories
      final uniqueCategories = loadedTopics
          .map((topic) => topic.category)
          .toSet()
          .toList();
      categories.value = ['All', ...uniqueCategories];
      
      // Generate search suggestions from titles and categories
      generateSearchSuggestions();
      
    } catch (e) {
      Get.snackbar(
        'Error'.tr,
        'Failed to load topics: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void generateSearchSuggestions() {
    final Set<String> suggestions = <String>{};
    
    // Add titles
    for (final topic in topics) {
      suggestions.add(topic.title);
      
      // Add individual words from titles
      final words = topic.title.split(' ');
      for (final word in words) {
        if (word.length > 2) {
          suggestions.add(word);
        }
      }
      
      // Add categories
      suggestions.add(topic.category);
      
      // Add subcategories if available
      if (topic.subcategory != null && topic.subcategory!.isNotEmpty) {
        suggestions.add(topic.subcategory!);
      }
    }
    
    searchSuggestions.value = suggestions.toList()..sort();
  }

  void loadPopularSearches() {
    // You can load this from SharedPreferences or API
    popularSearches.value = [
      'TabBar',
      'Widget',
      'TextField',
      'ListView',
      'Material',
    ];
  }

  void searchTopics(String query) {
    searchQuery.value = query;
    
    if (query.isNotEmpty) {
      showSuggestions.value = true;
      updateSearchSuggestions(query);
    } else {
      showSuggestions.value = false;
    }
    
    filterTopics();
  }

  void updateSearchSuggestions(String query) {
    if (query.isEmpty) {
      searchSuggestions.value = [...popularSearches, ...recentSearches];
      return;
    }
    
    final filteredSuggestions = <String>[];
    final allSuggestions = <String>{};
    
    // Add exact matches first
    for (final topic in topics) {
      if (topic.title.toLowerCase().startsWith(query.toLowerCase())) {
        allSuggestions.add(topic.title);
      }
      if (topic.category.toLowerCase().startsWith(query.toLowerCase())) {
        allSuggestions.add(topic.category);
      }
    }
    
    // Add partial matches
    for (final topic in topics) {
      if (topic.title.toLowerCase().contains(query.toLowerCase()) && 
          !topic.title.toLowerCase().startsWith(query.toLowerCase())) {
        allSuggestions.add(topic.title);
      }
      if (topic.description.toLowerCase().contains(query.toLowerCase())) {
        // Add words from description that match
        final words = topic.description.split(' ');
        for (final word in words) {
          if (word.toLowerCase().contains(query.toLowerCase()) && word.length > 2) {
            allSuggestions.add(word.replaceAll(RegExp(r'[^\w\s]'), ''));
          }
        }
      }
    }
    
    filteredSuggestions.addAll(allSuggestions.take(8));
    searchSuggestions.value = filteredSuggestions;
  }

  void selectSuggestion(String suggestion) {
    searchQuery.value = suggestion;
    showSuggestions.value = false;
    
    // Add to recent searches
    if (!recentSearches.contains(suggestion)) {
      recentSearches.insert(0, suggestion);
      if (recentSearches.length > 5) {
        recentSearches.removeLast();
      }
    }
    
    filterTopics();
  }

  void selectCategory(String category) {
    selectedCategory.value = category;
    filterTopics();
  }

  void filterTopics() {
    List<TopicModel> filtered = topics;
    
    // Filter by category
    if (selectedCategory.value != 'All') {
      filtered = filtered
          .where((topic) => topic.category == selectedCategory.value)
          .toList();
    }
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((topic) {
        final query = searchQuery.value.toLowerCase();
        return topic.title.toLowerCase().contains(query) ||
               topic.description.toLowerCase().contains(query) ||
               topic.category.toLowerCase().contains(query) ||
               (topic.subcategory?.toLowerCase().contains(query) ?? false);
      }).toList();
    }
    
    filteredTopics.value = filtered;
  }

  void clearSearch() {
    searchQuery.value = '';
    showSuggestions.value = false;
    filterTopics();
  }

  void hideSuggestions() {
    showSuggestions.value = false;
  }

  void showSearchSuggestions() {
    if (searchQuery.value.isEmpty) {
      searchSuggestions.value = [...popularSearches, ...recentSearches];
    }
    showSuggestions.value = true;
  }

  // Method to get suggestion icon
  IconData getSuggestionIcon(String suggestion) {
    if (recentSearches.contains(suggestion)) {
      return Icons.history;
    } else if (popularSearches.contains(suggestion)) {
      return Icons.trending_up;
    } else {
      return Icons.search;
    }
  }

  // Method to remove recent search
  void removeRecentSearch(String search) {
    recentSearches.remove(search);
  }

  // Method to clear all recent searches
  void clearRecentSearches() {
    recentSearches.clear();
  }
}
class TranslationController extends GetxController {
  final RxString currentLanguage = 'en'.obs;

  void changeLanguage(String languageCode) {
    currentLanguage.value = languageCode;
    Get.updateLocale(Locale(languageCode));
  }

  void toggleLanguage() {
    final newLanguage = currentLanguage.value == 'en' ? 'hi' : 'en';
    changeLanguage(newLanguage);
  }
}