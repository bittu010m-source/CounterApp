import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Counter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
  int count = 0;
  File? imageFile;
  final ImagePicker picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    final XFile? pickedFile =
        await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
    }
  }

  void increment() {
    setState(() {
      count++;
    });
  }

  void decrement() {
    setState(() {
      count--;
    });
  }

  void reset() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Counter App"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (imageFile != null)
                CircleAvatar(
                  radius: 60,
                  backgroundImage: FileImage(imageFile!),
                )
              else
                const CircleAvatar(
                  radius: 60,
                  child: Icon(Icons.person, size: 60),
                ),

              const SizedBox(height: 20),

              Text(
                "$count",
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: decrement,
                    child: const Text("-"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: increment,
                    child: const Text("+"),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: reset,
                child: const Text("Reset"),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () =>
                    pickImage(ImageSource.camera),
                child: const Text("Camera"),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: () =>
                    pickImage(ImageSource.gallery),
                child: const Text("Gallery"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
