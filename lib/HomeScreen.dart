import 'package:flutter/material.dart';
import 'package:sign_language_master/routes.dart';
import 'package:sign_language_master/utils/border_radius.dart';
import 'package:sign_language_master/utils/colors.dart';
import 'package:sign_language_master/utils/text_styles.dart';

import 'asl/GridItemScreen.dart';
import 'asl/more-categories.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onTranslatePressed; // Callback for Start button

  const HomeScreen({Key? key, required this.onTranslatePressed})
      : super(key: key);

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
        if (settings.name == AppRoutes.englishAlphabets) {
          page = _buildEnglishAlphabetsPage("English Alphabets");
        } else if (settings.name == AppRoutes.numberAlphabets) {
          page = _buildNumberAlphabetsPage("Numbers");
        } else if (settings.name == AppRoutes.urduAlphabets) {
          page = _buildUrduAlphabetsPage("Urdu Alphabets");
        } else if (settings.name == AppRoutes.categoryAlphabets) {
          page = _buildMoreCategoriesPage();
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
      case 'English Alphabets':
        return [
          {
            'name': 'A',
            'path': 'assets/Videos/A.mp4',
            'thumbnail': 'assets/English-Alphabets/A.png'
          },
          {
            'name': 'B',
            'path': 'assets/Videos/B.mp4',
            'thumbnail': 'assets/English-Alphabets/B.png'
          },
          {
            'name': 'C',
            'path': 'assets/Videos/C.mp4',
            'thumbnail': 'assets/English-Alphabets/C.png'
          },
          {
            'name': 'D',
            'path': 'assets/Videos/D.mp4',
            'thumbnail': 'assets/English-Alphabets/D.png'
          },
          {
            'name': 'E',
            'path': 'assets/Videos/E.mp4',
            'thumbnail': 'assets/English-Alphabets/E.png'
          },
          {
            'name': 'F',
            'path': 'assets/Videos/F.mp4',
            'thumbnail': 'assets/English-Alphabets/F.png'
          },
          {
            'name': 'G',
            'path': 'assets/Videos/G.mp4',
            'thumbnail': 'assets/English-Alphabets/G.png'
          },
          {
            'name': 'H',
            'path': 'assets/Videos/H.mp4',
            'thumbnail': 'assets/English-Alphabets/H.png'
          },
          {
            'name': 'I',
            'path': 'assets/Videos/I.mp4',
            'thumbnail': 'assets/English-Alphabets/I.png'
          },
          {
            'name': 'J',
            'path': 'assets/Videos/J.mp4',
            'thumbnail': 'assets/English-Alphabets/J.png'
          },
          {
            'name': 'K',
            'path': 'assets/Videos/K.mp4',
            'thumbnail': 'assets/English-Alphabets/K.png'
          },
          {
            'name': 'L',
            'path': 'assets/Videos/L.mp4',
            'thumbnail': 'assets/English-Alphabets/L.png'
          },
          {
            'name': 'M',
            'path': 'assets/Videos/M.mp4',
            'thumbnail': 'assets/English-Alphabets/M.png'
          },
          {
            'name': 'N',
            'path': 'assets/Videos/N.mp4',
            'thumbnail': 'assets/English-Alphabets/N.png'
          },
          {
            'name': 'O',
            'path': 'assets/Videos/O.mp4',
            'thumbnail': 'assets/English-Alphabets/O.png'
          },
          {
            'name': 'P',
            'path': 'assets/Videos/P.mp4',
            'thumbnail': 'assets/English-Alphabets/P.png'
          },
          {
            'name': 'Q',
            'path': 'assets/Videos/Q.mp4',
            'thumbnail': 'assets/English-Alphabets/Q.png'
          },
          {
            'name': 'R',
            'path': 'assets/Videos/R.mp4',
            'thumbnail': 'assets/English-Alphabets/R.png'
          },
          {
            'name': 'S',
            'path': 'assets/Videos/S.mp4',
            'thumbnail': 'assets/English-Alphabets/S.png'
          },
          {
            'name': 'T',
            'path': 'assets/Videos/T.mp4',
            'thumbnail': 'assets/English-Alphabets/T.png'
          },
          {
            'name': 'U',
            'path': 'assets/Videos/U.mp4',
            'thumbnail': 'assets/English-Alphabets/U.png'
          },
          {
            'name': 'V',
            'path': 'assets/Videos/V.mp4',
            'thumbnail': 'assets/English-Alphabets/V.png'
          },
          {
            'name': 'W',
            'path': 'assets/Videos/W.mp4',
            'thumbnail': 'assets/English-Alphabets/W.png'
          },
          {
            'name': 'X',
            'path': 'assets/Videos/X.mp4',
            'thumbnail': 'assets/English-Alphabets/X.png'
          },
          {
            'name': 'Y',
            'path': 'assets/Videos/Y.mp4',
            'thumbnail': 'assets/English-Alphabets/Y.png'
          },
          {
            'name': 'Z',
            'path': 'assets/Videos/Z.mp4',
            'thumbnail': 'assets/English-Alphabets/Z.png'
          },
          // Add more items...
        ];
      case 'Numbers':
        return [
          {
            'name': '1',
            'path': 'assets/Videos/1.mp4',
            'thumbnail': 'assets/Counting/1.png'
          },
          {
            'name': '2',
            'path': 'assets/Videos/2.mp4',
            'thumbnail': 'assets/Counting/2.png'
          },
          {
            'name': '3',
            'path': 'assets/Videos/3.mp4',
            'thumbnail': 'assets/Counting/3.png'
          },
          {
            'name': '4',
            'path': 'assets/Videos/4.mp4',
            'thumbnail': 'assets/Counting/4.png'
          },
          {
            'name': '5',
            'path': 'assets/Videos/5.mp4',
            'thumbnail': 'assets/Counting/5.png'
          },
          {
            'name': '6',
            'path': 'assets/Videos/6.mp4',
            'thumbnail': 'assets/Counting/6.png'
          },
          {
            'name': '7',
            'path': 'assets/Videos/7.mp4',
            'thumbnail': 'assets/Counting/7.png'
          },
          {
            'name': '8',
            'path': 'assets/Videos/8.mp4',
            'thumbnail': 'assets/Counting/8.png'
          },
          {
            'name': '9',
            'path': 'assets/Videos/9.mp4',
            'thumbnail': 'assets/Counting/9.png'
          },
          {
            'name': '0',
            'path': 'assets/Videos/0.mp4',
            'thumbnail': 'assets/Counting/0.png'
          },
          // Add more items...
        ];
      case 'Urdu Alphabets':
        return [
          {
            'name': 'ا',
            'path': 'assets/UrduAlphabets/ا.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ب',
            'path': 'assets/UrduAlphabets/ب.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'پ',
            'path': 'assets/UrduAlphabets/پ.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ت',
            'path': 'assets/UrduAlphabets/ت.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'ٹ',
            'path': 'assets/UrduAlphabets/ٹ.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ث',
            'path': 'assets/UrduAlphabets/ث.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'ج',
            'path': 'assets/UrduAlphabets/ج.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'چ',
            'path': 'assets/UrduAlphabets/چ.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'ح',
            'path': 'assets/UrduAlphabets/ح.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'خ',
            'path': 'assets/UrduAlphabets/خ.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'د',
            'path': 'assets/UrduAlphabets/د.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ڈ',
            'path': 'assets/UrduAlphabets/ڈ.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'ذ',
            'path': 'assets/UrduAlphabets/ذ.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ر',
            'path': 'assets/UrduAlphabets/ر.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'ڑ',
            'path': 'assets/UrduAlphabets/ڑ.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ز',
            'path': 'assets/UrduAlphabets/ز.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'ژ',
            'path': 'assets/UrduAlphabets/ژ.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'س',
            'path': 'assets/UrduAlphabets/س.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'ش',
            'path': 'assets/UrduAlphabets/ش.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ص',
            'path': 'assets/UrduAlphabets/ص.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'ض',
            'path': 'assets/UrduAlphabets/ض.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ط',
            'path': 'assets/UrduAlphabets/ط.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'ظ',
            'path': 'assets/UrduAlphabets/ظ.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ع',
            'path': 'assets/UrduAlphabets/ع.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'غ',
            'path': 'assets/UrduAlphabets/غ.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ف',
            'path': 'assets/UrduAlphabets/ف.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'ق',
            'path': 'assets/UrduAlphabets/ق.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ک',
            'path': 'assets/UrduAlphabets/ک.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'گ',
            'path': 'assets/UrduAlphabets/گ.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ل',
            'path': 'assets/UrduAlphabets/ل.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'م',
            'path': 'assets/UrduAlphabets/م.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ن',
            'path': 'assets/UrduAlphabets/ن.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'و',
            'path': 'assets/UrduAlphabets/و.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ہ',
            'path': 'assets/UrduAlphabets/ہ.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          {
            'name': 'ء',
            'path': 'assets/UrduAlphabets/ء.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ی',
            'path': 'assets/UrduAlphabets/ی.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ے',
            'path': 'assets/UrduAlphabets/ے.mp4',
            'thumbnail': 'assets/thumbs/alif.png'
          },
          {
            'name': 'ھ',
            'path': 'assets/UrduAlphabets/ھ.mp4',
            'thumbnail': 'assets/thumbs/bay.png'
          },
          // Add more items...
        ];
      default:
        return [];
    }
  }

  Widget _buildHomeContent(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
    );
  }

  Widget _buildMainBanner(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0, bottom: 0),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: AppBorderRadius.defaultRadius,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Translate Everything',
                  style: AppTextStyles.mainHeading,
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    onTranslatePressed();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: AppBorderRadius.fullRadius,
                    ),
                  ),
                  child: const Text(
                    'Start',
                    style: AppTextStyles.buttonText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 140,
            height: 140, // Increase height to allow vertical alignment.
            decoration: const BoxDecoration(
              borderRadius: AppBorderRadius.defaultRadius,
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Aligns image to the bottom.
              children: [
                ClipRRect(
                  borderRadius: AppBorderRadius.defaultRadius,
                  child: Image.asset(
                    'assets/banner_avatar.png',
                    fit: BoxFit.contain,
                    width: 140,
                    height: 140,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridOptions(BuildContext context) {
    final options = [
      {
        'title': 'English\nAlphabets',
        'route': AppRoutes.englishAlphabets,
        'rightImg': '',
        'leftImg': 'assets/numbers-img.png'
      },
      {
        'title': '\nNumbers',
        'route': AppRoutes.numberAlphabets,
        'rightImg': 'assets/english-img.png',
        'leftImg': ''
      },
      {
        'title': 'Urdu\nAlphabets',
        'route': AppRoutes.urduAlphabets,
        'rightImg': 'assets/urdu-img.png',
        'leftImg': ''
      },
      {
        'title': 'More\nCategories',
        'route': AppRoutes.categoryAlphabets,
        'rightImg': 'assets/categories-img.png',
        'leftImg': ''
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.85,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) {
        final option = options[index];
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(option['route'] as String);
          },
          child: _buildOptionCard(
              option['title'] as String,
              option['leftImg'] as String,
              option['rightImg'] as String,
              context),
        );
      },
    );
  }

  Widget _buildOptionCard(String title, String leftImageUrl,
      String rightImageUrl, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.4, // 40% of screen width
      decoration: BoxDecoration(
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
                offset:
                    const Offset(-20, 0), // Move image 20 pixels to the left
                child: ClipRRect(
                  borderRadius: AppBorderRadius.defaultRadius,
                  child: Image.asset(
                    leftImageUrl,
                    fit: BoxFit.contain,
                    width: screenWidth * 0.34, // Adjust width
                    height: screenWidth * 0.34, // Adjust height similarly
                  ),
                ),
              ),
            ),

          // Title Text
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(
                    screenWidth * 0.04), // Padding based on screen width
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
                  width: screenWidth * 0.34, // Adjust width
                  height: screenWidth * 0.34, // Adjust height similarly
                ),
              ),
            )
          else if (leftImageUrl
              .isNotEmpty) // Icon if only the left image is present
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
            const Text('Recent Translations',
                style: AppTextStyles.mediumHeading),
            TextButton(
              onPressed: () {},
              child:
                  const Text('See All', style: TextStyle(color: Colors.grey)),
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
      {
        'name': 'Colors',
        'thumbnail': 'assets/images/alphabet.png',
        'route': '/colors'
      },
      {
        'name': 'Days',
        'thumbnail': 'assets/images/numbers.png',
        'route': '/days'
      },
      {
        'name': 'Fruits',
        'thumbnail': 'assets/images/numbers.png',
        'route': '/fruits'
      },
      // Add more categories here
    ];
    return MoreCategoryScreen(categories: categoryData);
  }
}
