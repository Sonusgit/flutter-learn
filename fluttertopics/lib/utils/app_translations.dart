import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'app_title': 'Topic Explorer',
      'search_hint': 'Search topics...',
      'categories': 'Categories',
      'widgets': 'Widgets',
      'description': 'Description',
      'date': 'Date',
      'category': 'Category',
      'subcategory': 'Subcategory',
      'no_results': 'No results found',
      'loading': 'Loading...',
      'error': 'Error occurred',
      'All': 'All',
    },
    'hi_IN': {
      'app_title': 'विषय खोजकर्ता',
      'search_hint': 'विषय खोजें...',
      'categories': 'श्रेणियां',
      'widgets': 'विजेट्स',
      'description': 'विवरण',
      'date': 'दिनांक',
      'category': 'श्रेणी',
      'subcategory': 'उपश्रेणी',
      'no_results': 'कोई परिणाम नहीं मिला',
      'loading': 'लोड हो रहा है...',
      'error': 'त्रुटि हुई',
      'All': 'सभी',
    },
  };
}