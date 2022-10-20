import 'package:flutter/material.dart';
import 'package:sqlite/database_sqflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DELIVERY ORDER',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const MyHomePage(title: 'DELIVERY ORDER'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, @required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController judulController = TextEditingController();
  TextEditingController deskripsiController = TextEditingController();
  TextEditingController toppingController = TextEditingController();
  TextEditingController totalController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    refreshCatatan();
    super.initState();
  }

  //Ambil Data dari Database
  List<Map<String, dynamic>> catatan = [];
  void refreshCatatan() async {
    final data = await SQLHelper.getCatatan();
    setState(() {
      catatan = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(catatan);
    return Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.home),
          title: Text(widget.title),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0))),
        ),
        body: Container(
          color: Color.fromARGB(255, 252, 226, 188),
          child: ListView.builder(
              itemCount: catatan.length,
              itemBuilder: (context, index) => Card(
                    margin: const EdgeInsets.all(15),
                    child: ListTile(
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              catatan[index]['judul'],
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              catatan[index]['deskripsi'],
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              catatan[index]['topping'],
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              catatan[index]['total'],
                              style: TextStyle(color: Colors.black),
                            ),
                            Text(
                              catatan[index]['note'],
                              style: TextStyle(color: Colors.black),
                            ),
                          ]),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () =>
                                    modalForm(catatan[index]['id']),
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () =>
                                    hapusCatatan(catatan[index]['id']),
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      ),
                    ),
                  )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            modalForm(null);
          },
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          clipBehavior: Clip.antiAlias,
          color: Colors.blue,
          shape: CircularNotchedRectangle(),
          child: Material(
            child: SizedBox(
              width: double.infinity,
              height: 80.0,
            ),
            color: Theme.of(context).primaryColor,
          ),
        ));
  }

  //Hapus Data
  void hapusCatatan(int id) async {
    await SQLHelper.hapusCatatan(id);
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('DAFTAR PESANAN BERHASIL DIHAPUS !!!! ')));
    refreshCatatan();
  }

  //Tambah Data
  Future<void> tambahCatatan() async {
    await SQLHelper.tambahCatatan(
        judulController.text,
        deskripsiController.text,
        toppingController.text,
        totalController.text,
        noteController.text);
    refreshCatatan();
  }

  //Ubah Data
  Future<void> ubahCatatan(int id) async {
    await SQLHelper.ubahCatatan(
        id,
        judulController.text,
        deskripsiController.text,
        toppingController.text,
        totalController.text,
        noteController.text);
    refreshCatatan();
  }

  //Form Tambah Data
  void modalForm(int id) async {
    if (id != null) {
      final dataCatatan = catatan.firstWhere((element) => element['id'] == id);
      judulController.text = dataCatatan['judul'];
      deskripsiController.text = dataCatatan['deskripsi'];
      toppingController.text = dataCatatan['topping'];
      totalController.text = dataCatatan['total'];
      noteController.text = dataCatatan['note'];
    }
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (_) => Container(
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              height: 700,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextField(
                      controller: judulController,
                      decoration:
                          const InputDecoration(hintText: 'Kode Pemesanan'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: deskripsiController,
                      decoration:
                          const InputDecoration(hintText: 'Deskripsi Pesanan'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: toppingController,
                      decoration: const InputDecoration(hintText: 'Topping'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: totalController,
                      decoration:
                          const InputDecoration(hintText: 'Total Harga'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      controller: noteController,
                      decoration: const InputDecoration(hintText: 'Catatan'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              onPressed: () {
                                judulController.text = '';
                                deskripsiController.text = '';
                                toppingController.text = '';
                                totalController.text = '';
                                noteController.text = '';
                              },
                              child: Text("Clear")),
                          ElevatedButton(
                              onPressed: () async {
                                if (id == null) {
                                  await tambahCatatan();
                                } else {
                                  await ubahCatatan(id);
                                }

                                judulController.text = '';
                                deskripsiController.text = '';
                                toppingController.text = '';
                                totalController.text = '';
                                noteController.text = '';
                                Navigator.pop(context);
                              },
                              child: Text(id == null ? 'Tambah Pesanan' : 'Ubah Data Pesanan')),
                        ])
                  ],
                ),
              ),
            ));
  }
}
