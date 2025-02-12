import 'package:flutter/material.dart';

class Instructions extends StatelessWidget {
  const Instructions({Key? key}) : super(key: key);

  Widget buildTile(String letter, Color color, double size) {
    return Container(
      width: size,
      height: size,
      margin: EdgeInsets.symmetric(horizontal: size * 0.1),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size * 0.15),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: size * 0.5,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color correctColor = Color(0xFF588B56);
    const Color presentColor = Color(0xFFB39D4D);
    const Color absentColor = Color(0xFF3A3A3C);

    final double tileSize = MediaQuery.of(context).size.width * 0.125;

    return Scaffold(
      backgroundColor: Colors.black54,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Упутство',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                const Text(
                  'Погодите реч у шест покушаја. '
                  'Сваки покушај мора бити валидна реч од пет слова. '
                  'Након сваког покушаја, боја поља ће показати колико сте близу били решењу:',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTile('Т', correctColor, tileSize),
                    buildTile('Е', Colors.grey, tileSize),
                    buildTile('С', Colors.grey, tileSize),
                    buildTile('Л', Colors.grey, tileSize),
                    buildTile('А', Colors.grey, tileSize),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ово значи да је слово Т на правом месту.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTile('Т', Colors.grey, tileSize),
                    buildTile('Е', presentColor, tileSize),
                    buildTile('С', Colors.grey, tileSize),
                    buildTile('Л', Colors.grey, tileSize),
                    buildTile('А', Colors.grey, tileSize),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ово значи да је слово Е у речи, али на неком другом месту.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildTile('Т', Colors.grey, tileSize),
                    buildTile('Е', Colors.grey, tileSize),
                    buildTile('С', absentColor, tileSize),
                    buildTile('Л', Colors.grey, tileSize),
                    buildTile('А', Colors.grey, tileSize),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                const Text(
                  'Ово значи да слово С није у речи.',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: const Text('У реду',
                      style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
