import 'dart:io';
import 'dart:math';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:plantify_pnp/features/plant/constants/plant_constants.dart';

/// Kontrak antarmuka untuk layanan penyimpanan gambar lokal.
abstract class IPlantStorageService {
  /// Menyalin file sementara [tempFile] ke Support Directory permanen aplikasi.
  Future<String> saveImage(File tempFile);

  /// Menghapus file gambar fisik pada [path]. Wajib mengabaikan asset bawaan.
  /// Mengembalikan [true] jika berhasil atau asset/kosong, [false] jika gagal.
  Future<bool> deleteImage(String path);

  /// Memeriksa keberadaan file pada [path].
  Future<bool> exists(String path);

  /// Membersihkan file sementara [tempFile] dari cache OS.
  ///
  /// Catatan Arsitektur (Hardening 4):
  /// Metode ini disediakan sebagai utilitas manual. Namun, tidak dipanggil secara otomatis
  /// setelah operasi saveImage berhasil karena file cache sementara dari package `image_picker`
  /// dikelola langsung oleh daur ulang sistem operasi (OS Cache Lifecycle).
  /// Penambahan garbage collector manual di aplikasi berpotensi menimbulkan race condition
  /// dan kompleksitas yang tidak perlu.
  Future<void> cleanupTempFile(File tempFile);
}

/// Implementasi resmi layanan penyimpanan gambar lokal (Phase 6C Hardening).
///
/// Menyimpan gambar di [getApplicationSupportDirectory] dalam subfolder [PlantConstants.plantImagesFolder].
class PlantStorageService implements IPlantStorageService {
  @override
  Future<String> saveImage(File tempFile) async {
    final supportDir = await getApplicationSupportDirectory();
    final targetDir = Directory(p.join(supportDir.path, PlantConstants.plantImagesFolder));
    if (!await targetDir.exists()) {
      await targetDir.create(recursive: true);
    }

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomStr = _generateRandomString(4);
    final fileName = 'plant_${timestamp}_$randomStr.jpg';
    final destinationPath = p.join(targetDir.path, fileName);

    final copiedFile = await tempFile.copy(destinationPath);
    return copiedFile.path;
  }

  @override
  Future<bool> deleteImage(String path) async {
    // Guard mutlak: JANGAN pernah menghapus file berawalan assets/
    if (path.isEmpty || path.startsWith('assets/')) return true;

    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
      return true;
    } catch (_) {
      // Mengembalikan false jika gagal I/O agar provider dapat mencatat warning (Hardening 3)
      return false;
    }
  }

  @override
  Future<bool> exists(String path) async {
    if (path.isEmpty) return false;
    if (path.startsWith('assets/')) return true;
    final file = File(path);
    return await file.exists();
  }

  @override
  Future<void> cleanupTempFile(File tempFile) async {
    try {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
    } catch (_) {
      // Abaikan kegagalan pembersihan temp file
    }
  }

  String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rnd = Random();
    return String.fromCharCodes(
      Iterable.generate(length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))),
    );
  }
}
