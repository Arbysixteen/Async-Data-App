import 'package:flutter/material.dart';
import '../models/data_model.dart';
import '../services/api_service.dart';
import '../widgets/data_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<DataModel>> _futureData;
  
  @override
  void initState() {
    super.initState();
    // Memanggil metode untuk mengambil data saat widget diinisialisasi
    _futureData = _fetchAndProcessData();
  }
  
  /// Mengambil dan memproses data dari API
  Future<List<DataModel>> _fetchAndProcessData() async {
    // Mengambil data dari API
    final data = await _apiService.fetchData();
    // Memproses data (mengurutkan)
    return _apiService.processData(data);
  }
  
  /// Memuat ulang data dari API
  void _refreshData() {
    setState(() {
      _futureData = _fetchAndProcessData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Async Data App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshData,
          ),
        ],
      ),
      body: FutureBuilder<List<DataModel>>(
        future: _futureData,
        builder: (context, snapshot) {
          // Menampilkan indikator loading saat mengambil data
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } 
          // Menampilkan pesan error jika terjadi kesalahan
          else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 60, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _refreshData,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          } 
          // Menampilkan data jika berhasil diambil
          else if (snapshot.hasData) {
            final data = snapshot.data!;
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return DataItem(data: data[index]);
              },
            );
          } 
          // Menampilkan pesan jika tidak ada data
          else {
            return const Center(child: Text('Tidak ada data'));
          }
        },
      ),
    );
  }
}