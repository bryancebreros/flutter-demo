import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {

  runApp(MyApp());
}


  
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Rayansitos',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 8, 103, 255)),
        ),
        home: MyHomePage(),
      ),
    );
  }
  
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
  

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      print('added ->  $current');
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // ← Add this property.

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = ArrayLooper();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return Scaffold(
      body: Row(
        children: [
          SafeArea(
            child: NavigationRail(
              extended: false,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.home),
                  label: Text('Home'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.favorite),
                  label: Text('Favorites'),
                ),
              ],
              selectedIndex: selectedIndex, // ← Change to this.
              onDestinationSelected: (value) {
                setState(() {
                  selectedIndex = value;
                });
              },
            ),
          ),
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: ArrayLooper(),
            ),
          ),
        ],
      ),
    );
  }
}
class ArrayLooper extends StatefulWidget {
  @override
  _ArrayLooperState createState() => _ArrayLooperState();
}

class _ArrayLooperState extends State<ArrayLooper>  {
  List<String> images = ['https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-SKnz-PDDNTn_AAjhZGQUx0olOlL_osccLQ&s', 'https://i.pinimg.com/originals/7f/49/ca/7f49ca1189f8053427ed183e7ab68a39.gif','https://i.mydramalist.com/WPJ12W_5c.jpg','https://i.pinimg.com/736x/c4/96/9a/c4969aaedbc096c09b35e31abd11e2ec.jpg', ];
  int currentIndex = 0;
  void nextItem() {
    setState(() {
      currentIndex = (currentIndex + 1) % images.length; // Reiniciar cuando llegue al final
    });
  }
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Image.network(
          images[currentIndex],
          width: 250,
          height: 250,
          fit: BoxFit.cover,
          loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                      : null,
                ),
              );
            }
          },
          errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
            return Text('Failed to load image');
          },
        ),
      ),
    ),
          
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  nextItem();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

