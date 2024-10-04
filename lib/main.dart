
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
    return ChangeNotifierProvider(create: 
    (context)=>MyAppState(),
    child: MaterialApp(
      title: 'Flutter App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
    ),
    );
     
  }
}

class MyAppState extends ChangeNotifier{
  var current =WordPair.random();

  void getNext(){
    current = WordPair.random();
    notifyListeners();
  }
  var favorite = <WordPair>[];
  void toggleFevorite(){
    if(favorite.contains(current)){
      favorite.remove(current);
    }
    else{
      favorite.add(current);
    }
    notifyListeners();
  }
}

// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;
  @override
  Widget build(BuildContext context) {
    Widget page ;
    switch(selectedIndex){
      case 0:
      page = GeneratorPage();
      case 1:
      page = FavoritesPage();
      default: throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(
      builder: (context , constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(child: NavigationRail(
                extended: constraints.maxWidth>=600,
                selectedIndex: selectedIndex,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home), 
                    label:Text("Home")
                    ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite), 
                    label:Text("Favorites")
                    ),
                ],
                onDestinationSelected: (value){
                  setState(() {
                    selectedIndex=value;
                  });
                  print(value);
                },
              )),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    
    if (appState.favorite.isEmpty)
    {
      return Center(
        child: Text("favorite is       empty" ,),
      );
    }
    return ListView(
      children: [
         
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('You have ${appState.favorite.length} favorites'),
        ),
         for(var fav in appState.favorite)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(fav.asCamelCase),
          ),
       
        
       
      ],
    );
  }
}
class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if(appState.favorite.contains(appState.current)){
      icon = Icons.favorite;
    }else{
      icon=Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFevorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
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

// ...

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;
  

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
      return Card(
        
        color: theme.colorScheme.primary,
        child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asPascalCase , style: style,
        semanticsLabel: "${pair.first} ${pair.second}", ),
      ));
   
  }
}