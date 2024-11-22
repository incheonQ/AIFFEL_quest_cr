import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

class ImageUtils {
  static Future<File> resizeImage(File originalImage) async {
    // 이미지 파일을 바이트로 읽기
    final bytes = await originalImage.readAsBytes();
    final image = img.decodeImage(bytes);

    if (image == null) throw Exception('이미지를 디코딩할 수 없습니다.');

    // 이미지 리사이징 (긴 쪽을 300픽셀로 맞추기)
    final aspectRatio = image.width / image.height;
    late img.Image resized;
    
    if (aspectRatio > 1) {
      resized = img.copyResize(image, width: 300);
    } else {
      resized = img.copyResize(image, height: 300);
    }

    // 임시 디렉토리에 리사이징된 이미지 저장
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final resizedImage = File('$tempPath/resized_image.jpg')
      ..writeAsBytesSync(img.encodeJpg(resized, quality: 85));

    return resizedImage;
  }
}