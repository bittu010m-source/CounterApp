import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const HorizonApp());

class HorizonApp extends StatelessWidget {
  const HorizonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Horizon Professional',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: const GalleryPage(),
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  final ImagePicker picker = ImagePicker();
  List<File> images = [];

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  Future<Directory> get dir async {
    final d = await getApplicationDocumentsDirectory();
    final folder = Directory('${d.path}/horizon');

    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    return folder;
  }

  Future<void> loadImages() async {
    final folder = await dir;
    final files = folder.listSync().whereType<File>().toList();

    setState(() {
      images = files;
    });
  }

  Future<void> pick(ImageSource source) async {
    final XFile? x =
        await picker.pickImage(
      source: source,
      imageQuality: 90,
    );

    if (x == null) return;

    final folder = await dir;

    final file = await File(x.path).copy(
      '${folder.path}/${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    images.insert(0, file);

    setState(() {});
  }

  Future<void> remove(File f) async {
    await f.delete();
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horizon Professional'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.lock),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cloud_upload),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: '1',
            onPressed: () => pick(ImageSource.camera),
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: '2',
            onPressed: () => pick(ImageSource.gallery),
            child: const Icon(Icons.photo),
          ),
        ],
      ),
      body: images.isEmpty
          ? const Center(
              child: Text(
                'No Images Uploaded • Final APK Edition Ready',
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: images.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ViewPage(file: images[i]),
                      ),
                    );
                  },
                  onLongPress: () => remove(images[i]),
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(18),
                    child: Image.file(
                      images[i],
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class ViewPage extends StatelessWidget {
  final File file;

  const ViewPage({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.file(file),
      ),
    );
  }
}
