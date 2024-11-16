import 'package:flutter/material.dart';
import 'package:sign_language_master/utils/border_radius.dart';
import 'package:sign_language_master/utils/colors.dart';
import 'package:sign_language_master/utils/text_styles.dart';

import '../routes.dart';
import 'GridItemScreen.dart';

class MoreCategoryScreen extends StatelessWidget {
  final List<Map<String, String>> categories; // List of categories

  const MoreCategoryScreen({Key? key, required this.categories}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Set the card width relative to the screen width
    double cardWidth = screenWidth * 0.4; // 40% of screen width

    return Navigator(
      onGenerateRoute: (settings) {
        Widget page = _buildHomeContent(context); // Default page content

        // Switch case for routing
        if (settings.name == AppRoutes.colors) {
          page = _buildEnglishAlphabetsPage("Colors Category");
        } else if (settings.name == AppRoutes.fruits) {
          page = _buildNumberAlphabetsPage("Fruits Category");
        } else if (settings.name == AppRoutes.days) {
          page = _buildUrduAlphabetsPage("Days Category");
        }

        return PageRouteBuilder(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(opacity: anim, child: child);
          },
        );
      },
    );
  }
  List<Map<String, String>> _getItemsForOption(String title) {
    switch (title) {
      case 'Colors Category':
        return [
          {'name': 'Black', 'path': 'assets/Color/Black.mp4', 'thumbnail': 'assets/English-Alphabets/A.png'},
          {'name': 'Gold', 'path': 'assets/Color/Gold.mp4', 'thumbnail': 'assets/English-Alphabets/B.png'},
          {'name': 'Green', 'path': 'assets/Color/Green.mp4', 'thumbnail': 'assets/English-Alphabets/C.png'},
          {'name': 'Pink', 'path': 'assets/Color/Pink.mp4', 'thumbnail': 'assets/English-Alphabets/D.png'},
          {'name': 'Red', 'path': 'assets/Color/Red.mp4', 'thumbnail': 'assets/English-Alphabets/E.png'},
          {'name': 'White', 'path': 'assets/Color/White.mp4', 'thumbnail': 'assets/English-Alphabets/F.png'},

          // Add more items...
        ];
      case 'Days Category':
        return [
          {'name': 'Monday', 'path': 'assets/Day/Monday.mp4', 'thumbnail': 'assets/Days/Monday.png'},
          {'name': 'Tuesday', 'path': 'assets/Day/Tuesday.mp4', 'thumbnail': 'assets/Days/Tuesday.png'},
          {'name': 'Wednesday', 'path': 'assets/Day/Wednesday.mp4', 'thumbnail': 'assets/Days/Wednesday.png'},
          {'name': 'Thursday', 'path': 'assets/Day/Thursday.mp4', 'thumbnail': 'assets/Days/Thursday.png'},
          {'name': 'Friday', 'path': 'assets/Day/Friday.mp4', 'thumbnail': 'assets/Days/Friday.png'},
          {'name': 'Saturday', 'path': 'assets/Day/Saturday.mp4', 'thumbnail': 'assets/Days/Saturday.png'},
          {'name': 'Sunday', 'path': 'assets/Day/Sunday.mp4', 'thumbnail': 'assets/Days/Sunday.png'},

          // Add more items...
        ];
      case 'Fruits Category':
        return [
          {'name': 'Plum', 'path': 'assets/Fruit/Plum.mp4', 'thumbnail': 'assets/thumbs/alif.png'},
          {'name': 'Apple', 'path': 'assets/Fruit/Apple.mp4', 'thumbnail': 'assets/thumbs/bay.png'},
          {'name': 'Banana', 'path': 'assets/Fruit/Banana.mp4', 'thumbnail': 'assets/thumbs/alif.png'},
          {'name': 'Grapes', 'path': 'assets/Fruit/Grapes.mp4', 'thumbnail': 'assets/thumbs/bay.png'},
          {'name': 'Orange', 'path': 'assets/Fruit/Orange.mp4', 'thumbnail': 'assets/thumbs/alif.png'},
          {'name': 'Strawberry', 'path': 'assets/Fruit/Strawberry.mp4', 'thumbnail': 'assets/thumbs/bay.png'},

          // Add more items...
        ];
      default:
        return [];
    }
  }

  Widget _buildHomeContent(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMainBanner(context),
                  const SizedBox(height: 20),
                  _buildGridOptions(context),
                ],
              ),
            ),

          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () => Navigator.pop(context), // Go back on tap
              child: const Icon(Icons.arrow_back),
              backgroundColor: AppColors.primaryColor, // Customize color if needed
            ),
          ),
        ],
      )

    );
  }

  Widget _buildMainBanner(BuildContext context) {
    return const Center(
      child: Text(
          'Categories',
          textAlign: TextAlign.center,
          style: AppTextStyles.mainHeading,

      ),
    );
  }

  Widget _buildGridOptions(BuildContext context) {
    final options = [
      {'title': '\nColors', 'thumbnail': 'assets/images/alphabet.png', 'route': AppRoutes.colors,'rightImg': '', 'leftImg': 'assets/numbers-img.png'},
      {'title': '\nDays', 'thumbnail': 'assets/images/numbers.png', 'route': AppRoutes.days,'rightImg': 'assets/english-img.png', 'leftImg': ''},
      {'title': '\nFruits', 'thumbnail': 'assets/images/numbers.png', 'route': AppRoutes.fruits,'rightImg': 'assets/urdu-img.png', 'leftImg': ''},
      // Add more categories here
    ];

    // final options = [
    //   {'title': 'English\nAlphabets', 'route': AppRoutes.englishAlphabets, 'rightImg': '', 'leftImg': 'assets/numbers-img.png'},
    //   {'title': '\nNumbers', 'route': AppRoutes.numberAlphabets, 'rightImg': 'assets/english-img.png', 'leftImg': ''},
    //   {'title': 'Urdu\nAlphabets', 'route': AppRoutes.urduAlphabets, 'rightImg': 'assets/urdu-img.png', 'leftImg': ''},
    //   {'title': 'More\nCategories', 'route': AppRoutes.categoryAlphabets, 'rightImg': 'assets/categories-img.png', 'leftImg': ''},
    // ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 1.1,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(option['route'] as String);
          },
          child: _buildOptionCard(option['title'] as String, option['leftImg'] as String, option['rightImg'] as String, context),
        );
      },
    );
  }

  Widget _buildOptionCard(
      String title, String leftImageUrl, String rightImageUrl, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.4, // 40% of screen width
      decoration: const BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: AppBorderRadius.defaultRadius,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter, // Center the content vertically
        children: [
          // Left Image (if provided)
          if (leftImageUrl.isNotEmpty)
            Align(
              alignment: Alignment.bottomLeft, // Align to bottom left
              child: Transform.translate(
                offset: const Offset(-20, 0), // Move image 20 pixels to the left
                child: ClipRRect(
                  borderRadius: AppBorderRadius.defaultRadius,
                  child: Image.asset(
                    leftImageUrl,
                    fit: BoxFit.contain,
                    width: screenWidth * 0.26, // Adjust width
                    height: screenWidth * 0.26, // Adjust height similarly
                  ),
                ),
              ),
            ),

          // Title Text
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(screenWidth * 0.04), // Padding based on screen width
                child: Text(
                  title,
                  style: AppTextStyles.mediumHeading,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8), // Add spacing between title and images
            ],
          ),

          // Right Image (if provided) or Left Icon
          if (rightImageUrl.isNotEmpty)
            Positioned(
              bottom: 0,
              right: -20,
              child: ClipRRect(
                borderRadius: AppBorderRadius.defaultRadius,
                child: Image.asset(
                  rightImageUrl,
                  fit: BoxFit.contain,
                  width: screenWidth * 0.26, // Adjust width
                  height: screenWidth * 0.26, // Adjust height similarly
                ),
              ),
            )
          else if (leftImageUrl.isNotEmpty) // Icon if only the left image is present
            Positioned(
              bottom: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.play_circle_fill,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  // Handle icon button press here
                },
              ),
            ),

          // Left Icon if only right image is present
          if (leftImageUrl.isEmpty && rightImageUrl.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              child: IconButton(
                icon: const Icon(
                  Icons.play_circle_fill,
                  color: Colors.black,
                  size: 35,
                ),
                onPressed: () {
                  // Handle icon button press here
                },
              ),
            ),
        ],
      ),
    );
  }



  Widget _buildRecentTranslations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Translations', style: AppTextStyles.mediumHeading),
            TextButton(
              onPressed: () {},
              child: const Text('See All', style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _buildEnglishAlphabetsPage(String title) {
    return GridItemScreen(title: title, items: _getItemsForOption(title));
  }
  Widget _buildNumberAlphabetsPage(String title) {
    return GridItemScreen(title: title, items: _getItemsForOption(title));
  }
  Widget _buildUrduAlphabetsPage(String title) {
    return GridItemScreen(title: title, items: _getItemsForOption(title));
  }

  Widget _buildMoreCategoriesPage() {
    // Sample category data
    final List<Map<String, String>> categoryData = [
      {'name': 'Colors', 'thumbnail': 'assets/images/alphabet.png', 'route': '/colors'},
      {'name': 'Days', 'thumbnail': 'assets/images/numbers.png', 'route': '/days'},
      {'name': 'Fruits', 'thumbnail': 'assets/images/numbers.png', 'route': '/fruits'},
      // Add more categories here
    ];
    return MoreCategoryScreen(categories: categoryData);
  }
}
