import 'package:flutter/material.dart';

class SpeechScreen extends StatefulWidget {
  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  final List<Map<String, String>> _letters = [
    {'path': 'assets/signlanguage.png', 'name': 'A'},
    {'path': 'assets/signlanguage.png', 'name': 'B'},
    {'path': 'assets/signlanguage.png', 'name': 'C'},
    {'path': 'assets/signlanguage.png', 'name': 'D'},
    {'path': 'assets/signlanguage.png', 'name': 'E'},
    {'path': 'assets/signlanguage.png', 'name': 'F'},
    {'path': 'assets/signlanguage.png', 'name': 'G'},
    {'path': 'assets/signlanguage.png', 'name': 'H'},
    {'path': 'assets/signlanguage.png', 'name': 'I'},
    {'path': 'assets/signlanguage.png', 'name': 'J'},
    {'path': 'assets/signlanguage.png', 'name': 'K'},
    {'path': 'assets/signlanguage.png', 'name': 'L'},
    {'path': 'assets/signlanguage.png', 'name': 'M'},
    {'path': 'assets/signlanguage.png', 'name': 'N'},
    {'path': 'assets/signlanguage.png', 'name': 'O'},
    {'path': 'assets/signlanguage.png', 'name': 'P'},
    {'path': 'assets/signlanguage.png', 'name': 'Q'},
    {'path': 'assets/signlanguage.png', 'name': 'R'},
    {'path': 'assets/signlanguage.png', 'name': 'S'},
    {'path': 'assets/signlanguage.png', 'name': 'T'},
    {'path': 'assets/signlanguage.png', 'name': 'U'},
    {'path': 'assets/signlanguage.png', 'name': 'V'},
    {'path': 'assets/signlanguage.png', 'name': 'W'},
    {'path': 'assets/signlanguage.png', 'name': 'X'},
    {'path': 'assets/signlanguage.png', 'name': 'Y'},
    {'path': 'assets/signlanguage.png', 'name': 'Z'},
  ];

  final List<Map<String, String>> _numbers = [
    {'path': 'assets/signlanguage.png', 'name': '1'},
    {'path': 'assets/signlanguage.png', 'name': '2'},
    {'path': 'assets/signlanguage.png', 'name': '3'},
    {'path': 'assets/signlanguage.png', 'name': '4'},
    {'path': 'assets/signlanguage.png', 'name': '5'},
    {'path': 'assets/signlanguage.png', 'name': '6'},
    {'path': 'assets/signlanguage.png', 'name': '7'},
    {'path': 'assets/signlanguage.png', 'name': '8'},
    {'path': 'assets/signlanguage.png', 'name': '9'},
    {'path': 'assets/signlanguage.png', 'name': '10'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildGridView(_letters, "Alphabet (A to Z)"),
            _buildGridView(_numbers, "Numbers (1 to 10)"),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(List<Map<String, String>> items, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 3.5,
            mainAxisSpacing: 4,
            childAspectRatio: 1.1,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return GestureDetector(
              onTap: () => _showItemDialog(item), // Show dialog on tap
              child: Card(
                color: Colors.indigo,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),

                        child: Image.asset(
                          item['path']!,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Text(
                        item['name']!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showItemDialog(Map<String, String> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Round dialog
          ),
          content: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Image.asset(
                      item['path']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    item['name']!,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

        );
      },
    );
  }
}
