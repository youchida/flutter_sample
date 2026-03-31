import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart'; // ✅ pour sauvegarder le high score

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto'),
      home: const StartScreen(),
    );
  }
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});
  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  int highScore = 0;

  @override
  void initState() {
    super.initState();
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      highScore = prefs.getInt('highScore') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFff9a9e), Color(0xFFfad0c4)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.local_florist, size: 100, color: Colors.white),
              const SizedBox(height: 20),
              const Text("🍓 Jeu des Fruits 🍍",
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
              const SizedBox(height: 20),
              Text("🏆 Meilleur score : $highScore",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.yellowAccent)),
              const SizedBox(height: 50),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.pink,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                  elevation: 8,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const FruitsGame(level: 1)),
                  );
                },
                child: const Text("Commencer",
                    style: TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FruitsGame extends StatefulWidget {
  final int level;
  const FruitsGame({super.key, required this.level});
  @override
  _FruitsGameState createState() => _FruitsGameState();
}

class _FruitsGameState extends State<FruitsGame> {
  int score = 0;
  int lives = 3; // ❤️ 3 vies par niveau
  late int timeLeft;
  late Timer timer;
  late String targetFruit;
  late List<String> fruits;
  final player = AudioPlayer();

  final Map<String, String> fruitNames = {
    "Ananas.jpg": "Ananas",
    "Avocat.jpg": "Avocat",
    "Banane.jpg": "Banane",
    "Citron.jpg": "Citron",
    "Fraise.jpg": "Fraise",
    "Mangue.jpg": "Mangue",
    "Pasteque.jpg": "Pastèque",
    "Pomme.jpg": "Pomme",
    "Raisin.jpg": "Raisin",
  };

  @override
  void initState() {
    super.initState();
    if (widget.level == 1) {
      timeLeft = 30;
    } else if (widget.level == 2) {
      timeLeft = 45;
    } else {
      timeLeft = 60;
    }
    _generateGrid();
    _startTimer();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          _endGame();
        }
      });
    });
  }

  void _generateGrid() {
    final allFruits = fruitNames.keys.toList();
    targetFruit = allFruits[Random().nextInt(allFruits.length)];
    fruits = List.from(allFruits)..shuffle();
    fruits = fruits.take(9).toList();
    if (!fruits.contains(targetFruit)) {
      fruits[Random().nextInt(9)] = targetFruit;
    }
  }

  void _checkFruit(String fruit) async {
    if (fruit == targetFruit) {
      setState(() => score++);
      await player.play(AssetSource("sounds/win.mp3"));
    } else {
      setState(() => lives--);
      await player.play(AssetSource("sounds/lose.mp3"));
      if (lives <= 0) {
        timer.cancel();
        _endGame();
        return;
      }
    }
    _generateGrid();
  }

  void _endGame() async {
    final prefs = await SharedPreferences.getInstance();
    int highScore = prefs.getInt('highScore') ?? 0;
    if (score > highScore) {
      await prefs.setInt('highScore', score);
    }

    if (score >= 5 && widget.level < 3 && lives > 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (_) => FruitsGame(level: widget.level + 1)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => EndScreen(score: score)),
      );
    }
  }

  @override
  void dispose() {
    timer.cancel();
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Niveau ${widget.level}"),
        backgroundColor: Colors.pink,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Text("Score : $score",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          Text("Temps restant : $timeLeft s",
              style: const TextStyle(fontSize: 20, color: Colors.red)),
          Text("Vies restantes : $lives ❤️",
              style: const TextStyle(fontSize: 20, color: Colors.deepPurple)),
          Text("Cliquez sur : ${fruitNames[targetFruit]}",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.pink)),
          const SizedBox(height: 20),

          // ⭐ Progression visuelle par étoiles
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return Icon(
                Icons.star,
                size: 40,
                color: index < widget.level ? Colors.yellowAccent : Colors.grey,
              );
            }),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemCount: fruits.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _checkFruit(fruits[index]),
                  child: Card(
                    elevation: 10,
                    shadowColor: Colors.pinkAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/images/${fruits[index]}",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class EndScreen extends StatelessWidget {
  final int score;
  const EndScreen({super.key, required this.score});

  Future<int> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('highScore') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: _loadHighScore(),
      builder: (context, snapshot) {
        int highScore = snapshot.data ?? 0;
        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFa1c4fd), Color(0xFFc2e9fb)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events,
                      size: 100, color: Colors.amberAccent),
                  const SizedBox(height: 20),
                  const Text("🏆 Fin du Jeu 🏆",
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                  const SizedBox(height: 20),
                  Text("Votre score final : $score",
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple)),
                  const SizedBox(height: 10),
                  Text("Meilleur score : $highScore",
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellowAccent)),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 60, vertical: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)),
                      elevation: 8,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const StartScreen()),
                      );
                    },
                    child: const Text("Rejouer",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold)),
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
