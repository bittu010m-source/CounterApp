import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const HorizonApp());
}

class HorizonApp extends StatelessWidget {
  const HorizonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Horizon",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final picker = ImagePicker();
  List<File> images = [];
  int navIndex = 0;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<Directory> get folder async {
    final dir = await getApplicationDocumentsDirectory();
    final f = Directory('${dir.path}/horizon');
    if (!await f.exists()) await f.create(recursive: true);
    return f;
  }

  Future<void> loadImages() async {
    final f = await folder;
    final files = f.listSync().whereType<File>().toList();
    setState(() {
      images = files.reversed.toList();
    });
  }

  Future<void> pickImage(ImageSource source) async {
    final x = await picker.pickImage(source: source, imageQuality: 90);
    if (x == null) return;

    final f = await folder;
    await File(x.path)
        .copy('${f.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');

    loadImages();
  }

  Future<void> deleteImage(File file) async {
    await file.delete();
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        elevation: 0,
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Horizon",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Your Memories, Secured",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.search),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Icon(Icons.settings),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Color(0xff2d7cff)],
            ),
          ),
        ),
      ),

      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                  padding: EdgeInsets.all(14),
                  child: Text(
                    "ALL",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(14),
                  child: Text("FAVORITES"),
                ),
                Padding(
                  padding: EdgeInsets.all(14),
                  child: Text("RECENT"),
                ),
              ],
            ),
          ),

          Expanded(
            child: images.isEmpty
                ? const Center(
                    child: Text(
                      "No Images Uploaded",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(10),
                    itemCount: images.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemBuilder: (context, index) {
                      final file = images[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewPage(file: file),
                            ),
                          );
                        },
                        onLongPress: () => deleteImage(file),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4,
                                color: Colors.black12,
                              )
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              file,
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

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: "1",
            backgroundColor: Colors.blue,
            onPressed: () => pickImage(ImageSource.camera),
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 14),
          FloatingActionButton(
            heroTag: "2",
            backgroundColor: Colors.blue,
            onPressed: () => pickImage(ImageSource.gallery),
            child: const Icon(Icons.photo),
          ),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navIndex,
        onTap: (i) {
          setState(() {
            navIndex = i;
          });
        },
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo_library),
            label: "Gallery",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lock),
            label: "Vault",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],
      ),
    );
  }
}

class ViewPage extends StatelessWidget {
  final File file;

  const ViewPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("View"),
        backgroundColor: Colors.blue,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.share),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Icon(Icons.delete),
          ),
        ],
      ),
      body: Center(
        child: Image.file(file),
      ),
    );
  }
}
