import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:image/image.dart' as img;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _originalImage; // 원본 이미지
  Uint8List? _editedImage; // 편집된 이미지
  final TextEditingController _resizeController =
      TextEditingController(); // 리사이즈 입력 컨트롤러

  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var request = http.MultipartRequest('POST',
          Uri.parse('https://601b-222-239-25-12.ngrok-free.app/upload/'));
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        _originalImage = await response.stream.toBytes();
        setState(() {}); // 상태 업데이트
      } else {
        String responseBody = await response.stream.bytesToString();
        print('Failed to upload image: ${response.statusCode} - $responseBody');
      }
    }
  }

  Future<void> _saveImage(Uint8List imageBytes) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/edited_image.png';
    File(filePath).writeAsBytesSync(imageBytes);
    print('Image saved at $filePath');
  }

  void _applyEdit(String editType) {
    if (_originalImage != null) {
      img.Image original = img.decodeImage(_originalImage!)!;
      img.Image edited;

      switch (editType) {
        case 'rotate':
          edited = img.copyRotate(original, 90);
          break;
        case 'blur':
          edited = img.gaussianBlur(original, 5);
          break;
        case 'resize':
          // 사용자가 입력한 크기를 파싱
          String input = _resizeController.text;
          List<String> dimensions = input.split(',');
          if (dimensions.length == 2) {
            int width = int.tryParse(dimensions[0].trim()) ?? original.width;
            int height = int.tryParse(dimensions[1].trim()) ?? original.height;
            edited = img.copyResize(original, width: width, height: height);
          } else {
            edited = original; // 잘못된 입력일 경우 원본 이미지 사용
          }
          break;
        default:
          edited = original;
      }

      setState(() {
        _editedImage = Uint8List.fromList(img.encodePng(edited));
      });
    }
  }

  Future<void> _applyModelEdit() async {
    if (_originalImage != null) {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://601b-222-239-25-12.ngrok-free.app/pred/')); // FastAPI 서버 URL

      // 원본 이미지를 사용하여 모델 편집 요청
      request.files.add(http.MultipartFile.fromBytes('file', _originalImage!,
          filename: 'original_image.jpg'));

      var response = await request.send();

      if (response.statusCode == 200) {
        // 변환된 이미지 수신
        Uint8List transformedImage = await response.stream.toBytes();
        setState(() {
          _editedImage = transformedImage; // 변환된 이미지로 업데이트
        });
      } else {
        String responseBody = await response.stream.bytesToString();
        print(
            'Failed to apply model edit: ${response.statusCode} - $responseBody');
      }
    } else {
      print('원본 이미지가 없습니다.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Image Edit Example'),
        ),
        body: Center(
          child: SingleChildScrollView(
            // 스크롤 가능하게 설정
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _uploadImage,
                  child: Text('Upload Image'),
                ),
                SizedBox(height: 20),
                if (_originalImage != null || _editedImage != null) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (_originalImage != null) ...[
                        Column(
                          children: [
                            Text('Original Image:'),
                            Container(
                              width: 300, // 고정된 너비
                              height: 300, // 고정된 높이
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Image.memory(
                                _originalImage!,
                                fit: BoxFit.cover, // 이미지 비율 유지
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 20), // 이미지 사이의 간격
                      ],
                      if (_editedImage != null) ...[
                        Column(
                          children: [
                            Text('Edited Image:'),
                            Container(
                              width: 300, // 고정된 너비
                              height: 300, // 고정된 높이
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: Image.memory(
                                _editedImage!,
                                fit: BoxFit.cover, // 이미지 비율 유지
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ],
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => _applyEdit('rotate'),
                      child: Text('Rotate 90°'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _applyEdit('blur'),
                      child: Text('Blur'),
                    ),
                    SizedBox(width: 10),
                    // 리사이즈 입력 필드 추가
                    Container(
                      width: 100,
                      child: TextField(
                        controller: _resizeController,
                        decoration: InputDecoration(
                          hintText: 'Width, Height',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _applyEdit('resize'),
                      child: Text('Resize'),
                    ),
                    SizedBox(width: 10),
                    // 모델 변환 버튼 추가
                    ElevatedButton(
                      onPressed: _applyModelEdit,
                      child: Text('Apply Model Edit'),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                if (_editedImage != null)
                  ElevatedButton(
                    onPressed: () => _saveImage(_editedImage!),
                    child: Text('Save Edited Image'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}
