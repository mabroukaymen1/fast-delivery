import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddressSelectionPage extends StatefulWidget {
  @override
  _AddressSelectionPageState createState() => _AddressSelectionPageState();
}

class _AddressSelectionPageState extends State<AddressSelectionPage> {
  String selectedCity = 'Monastir';
  String searchQuery = '';
  List<Map<String, String>> locations = [
    {'city': 'Monastir', 'country': 'Tunisia'},
    {'city': 'Sousse', 'country': 'Tunisia'},
    {'city': 'Tunis', 'country': 'Tunisia'},
    // Add more locations as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Address",
          style: GoogleFonts.lato(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFFD72F2F),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFD72F2F), Color(0xFFFF6B6B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your location',
              style: GoogleFonts.lato(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Let\'s find your unforgettable event. Choose a location below or search to get started.',
              style: GoogleFonts.lato(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Search location...',
                prefixIcon: Icon(Icons.search, color: Color(0xFFD72F2F)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Implement location detection
              },
              child: Row(
                children: [
                  Icon(Icons.my_location, color: Color(0xFFD72F2F)),
                  SizedBox(width: 8),
                  Text(
                    "Use current location",
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFD72F2F),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Select location',
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  if (searchQuery.isNotEmpty &&
                      !location['city']!
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase())) {
                    return Container(); // Skip items that don't match the search query
                  }
                  return _buildLocationTile(
                    cityName: location['city']!,
                    country: location['country']!,
                    isSelected: selectedCity == location['city'],
                    onTap: () {
                      setState(() {
                        selectedCity = location['city']!;
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Save action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD72F2F),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                'Save',
                style: GoogleFonts.lato(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationTile({
    required String cityName,
    required String country,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: SvgPicture.asset(
        'assets/image/cards/place.svg',
        height: 32,
        width: 32,
        color: isSelected ? Color(0xFFD72F2F) : Colors.grey,
      ),
      title: Text(
        cityName,
        style: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.grey.shade800,
        ),
      ),
      subtitle: Text(
        country,
        style: GoogleFonts.lato(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
      ),
      trailing: isSelected
          ? CircleAvatar(
              backgroundColor: Color(0xFFD72F2F).withOpacity(0.1),
              child: Icon(Icons.check, color: Color(0xFFD72F2F)),
            )
          : CircleAvatar(
              backgroundColor: Colors.grey[200],
              child: SvgPicture.asset(
                'assets/image/cards/place.svg',
                height: 24,
                width: 24,
                color: Colors.grey,
              ),
            ),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: isSelected ? Color(0xFFD72F2F) : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      onTap: onTap,
    );
  }
}
