import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() {
  runApp(const MyApp()); // Uygulamayı başlatır
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const RatingApp(),
      theme: ThemeData(
        brightness: Brightness.light, // Varsayılan tema: açık mod
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark, // Karanlık mod teması
      ),
      themeMode: ThemeMode.system, // Sistem temasına izin ver
    );
  }
}

class RatingApp extends StatefulWidget {
  const RatingApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RatingAppState createState() => _RatingAppState();
}

class _RatingAppState extends State<RatingApp> {
  double _averageRating = 0.0; // Ortalama derecelendirme
  final Map<String, double> ratings =
      {}; // Kitapların derecelendirmelerini saklar
  bool isDarkMode = false; // Karanlık mod durumu

  final List<String> items = [
    "Interstellar",
    "Iron Man",
    "Schindler's List",
  ]; // Kitap listesi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Derecelendirme Uygulaması"), // Başlık
        backgroundColor: const Color.fromARGB(255, 159, 11, 204),
        actions: [
          IconButton(
            icon: const Icon(Icons.add), // Yeni film eklemek için buton
            color: const Color.fromARGB(255, 0, 0, 0),
            onPressed: () {
              _showAddMovieDialog(); // Yeni film eklemek için diyalog penceresini gösterir
            },
          ),
          IconButton(
            icon: const Icon(
                Icons.refresh), // Derecelendirmeleri sıfırlamak için buton
            color: const Color.fromARGB(255, 0, 0, 0),
            onPressed: () {
              _resetRatings(); // Derecelendirmeleri sıfırlar
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]), // Kitap adı
            subtitle: RatingBar.builder(
              initialRating: ratings[items[index]] ?? 0.0, // Başlangıç derecesi
              minRating: 1, // Minimum derece
              direction: Axis.horizontal, // Yatay derece
              allowHalfRating: true, // Yarı puanlama
              itemCount: 5, // Toplam yıldız sayısı
              itemSize: 40.0, // Yıldız boyutu
              itemPadding: const EdgeInsets.symmetric(
                  horizontal: 4.0), // Yıldızlar arası boşluk
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ), // Yıldız simgesi
              onRatingUpdate: (rating) {
                setState(() {
                  ratings[items[index]] = rating; // Derecelendirmeyi günceller
                  _updateAverageRating(); // Ortalama derecelendirmeyi günceller
                });
              },
            ),
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Ortalama Derecelendirme: ${_averageRating.toStringAsFixed(2)} yıldız"), // Ortalama derecelendirme metni
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Kullanıcının karanlık mod butonuna tıkladığında tetiklenir
          setState(() {
            isDarkMode = !isDarkMode;
          });
          // Temayı değiştirmek için kullanıcının mevcut tercihleri alınır.
          final Brightness currentBrightness =
              Theme.of(context).brightness; // şuanki parlaklık seviyesi
          final ThemeMode newThemeMode = currentBrightness == Brightness.light
              ? ThemeMode.dark // eğer parlaklık açıksa karanlık tema
              : ThemeMode.light; // eğer parlaklık karanlıksa, açık tema

          // MaterialApp örneğini oluşturulur ve tema güncellenir
          final MaterialApp app = MaterialApp(
            themeMode: newThemeMode,
            home: const RatingApp(),
            theme: ThemeData(
              brightness: Brightness.light, // Varsayılan tema: açık mod
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark, // Karanlık mod teması
            ),
          );

          // Uygulama Güncellenir
          runApp(app);
        },
        backgroundColor: const Color.fromARGB(255, 159, 11, 204),
        child: Icon(
          isDarkMode ? Icons.nightlight_round : Icons.light_mode_sharp,
          color:
              isDarkMode ? Colors.yellow : const Color.fromARGB(255, 0, 0, 0),
        ),
      ),
    );
  }

  void _updateAverageRating() {
    double totalRating = 0.0; // Toplam derecelendirme
    int itemCount = 0; // Öğe sayısı

    ratings.forEach((key, value) {
      totalRating += value; // Derecelendirmeleri toplar
      itemCount++; // Öğe sayısını artırır
    });

    if (itemCount > 0) {
      _averageRating =
          totalRating / itemCount; // Ortalama derecelendirmeyi hesaplar
    } else {
      _averageRating = 0.0; // Eğer öğe yoksa ortalama sıfır olur
    }
  }

  void _showAddMovieDialog() {
    String newMovie = ""; // Yeni film adı

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Yeni Film Ekle"), // Diyalog penceresi başlığı
          content: TextField(
            onChanged: (value) {
              newMovie = value; // Yeni film adını saklar
            },
            decoration: const InputDecoration(
              hintText: "Film Adı",
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Diyalog penceresini kapatır
              },
              child: const Text("İptal"), // İptal düğmesi
            ),
            TextButton(
              onPressed: () {
                if (newMovie.isNotEmpty) {
                  setState(() {
                    items.add(newMovie); // Yeni filmi listeye ekler
                    ratings[newMovie] =
                        0.0; // Varsayılan derecelendirmeyi ekler
                  });
                  _updateAverageRating(); // Ortalama derecelendirmeyi günceller
                }
                Navigator.of(context).pop(); // Diyalog penceresini kapatır
              },
              child: const Text("Ekle"), // Ekle butonu
            ),
          ],
        );
      },
    );
  }

  void _resetRatings() {
    setState(() {
      ratings.clear(); // Derecelendirmeleri temizler
      _averageRating = 0.0; // Ortalama derecelendirmeyi sıfırlar
    });
  }
}
