import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController _searchController;
  late SearchProvider _searchProvider;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchProvider = Provider.of<SearchProvider>(context, listen: false);
  }

  void _search(String query) {
    _searchProvider.search(query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD72F2F),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          controller: _searchController,
          onChanged: _search,
          decoration: InputDecoration(
            hintText: 'Search for food or places...',
            hintStyle: GoogleFonts.lato(
              color: Colors.white70,
              fontSize: 18,
            ),
            border: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _searchController.clear();
                _search('');
              },
            ),
          ),
          style: GoogleFonts.lato(color: Colors.white, fontSize: 18),
        ),
      ),
      body: Consumer<SearchProvider>(
        builder: (context, searchProvider, child) {
          if (searchProvider.isLoading) {
            return Center(
                child: CircularProgressIndicator(color: Color(0xFFD72F2F)));
          } else if (searchProvider.hasError) {
            return Center(
              child: Text(
                'An error occurred. Please try again.',
                style: GoogleFonts.lato(color: Colors.grey, fontSize: 18),
              ),
            );
          } else {
            return _buildSearchResults(searchProvider.searchResults);
          }
        },
      ),
    );
  }

  Widget _buildSearchResults(List<String> searchResults) {
    return searchResults.isEmpty
        ? Center(
            child: Text(
              'No results found',
              style: GoogleFonts.lato(color: Colors.grey, fontSize: 18),
            ),
          )
        : ListView.builder(
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  searchResults[index],
                  style: GoogleFonts.lato(color: Colors.black87, fontSize: 18),
                ),
                onTap: () {
                  // Handle search result tap
                },
              );
            },
          );
  }
}

class SearchProvider with ChangeNotifier {
  bool _isLoading = false;
  List<String> _searchResults = [];
  bool _hasError = false;

  bool get isLoading => _isLoading;
  List<String> get searchResults => _searchResults;
  bool get hasError => _hasError;

  void search(String query) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Replace this with your actual search logic
      await Future.delayed(const Duration(seconds: 1));
      _searchResults = query.isEmpty
          ? []
          : List.generate(10, (index) => 'Result $index for "$query"');
    } catch (error) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// You'll need to implement the RestaurantDetailScreen
class RestaurantDetailScreen extends StatelessWidget {
  final String title;
  final String imagePath;

  const RestaurantDetailScreen({
    Key? key,
    required this.title,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath),
            SizedBox(height: 20),
            Text('Details for $title'),
          ],
        ),
      ),
    );
  }
}
