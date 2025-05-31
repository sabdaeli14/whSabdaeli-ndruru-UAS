import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:whazlansaja/models/dosen.dart';
import 'package:whazlansaja/screen/pesan_screen.dart';

class BerandaScreen extends StatefulWidget {
  const BerandaScreen({super.key});

  @override
  State<BerandaScreen> createState() => _BerandaScreenState();
}

class _BerandaScreenState extends State<BerandaScreen> {
  List<Dosen> dosenList = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadDosen();
  }

  Future<void> loadDosen() async {
    try {
      final data = await rootBundle.loadString('assets/json_data_chat_dosen/dosen_chat.json');
      final List<dynamic> jsonData = json.decode(data);
      final list = jsonData.map((e) => Dosen.fromJson(e)).toList();

      setState(() {
        dosenList = list;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Gagal memuat data dosen: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Gagal memuat data dosen.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          'WhAzlansaja',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_enhance)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 12, right: 12),
            child: SearchAnchor.bar(
              barElevation: const WidgetStatePropertyAll(2),
              barHintText: 'Cari dosen dan mulai chat',
              suggestionsBuilder: (context, controller) {
                return <Widget>[
                  const Center(child: Text('Belum ada pencarian')),
                ];
              },
            ),
          ),
        ),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : dosenList.isEmpty
                  ? const Center(child: Text('Tidak ada data dosen.'))
                  : ListView.builder(
                      itemCount: dosenList.length,
                      itemBuilder: (context, index) {
                        final dosen = dosenList[index];
                        return ListTile(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PesanScreen(dosen: dosen),
                              ),
                            );

                            if (result != null && result is Dosen) {
                              setState(() {
                                dosenList[index] = result;
                              });
                            }
                          },
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(dosen.avatar),
                          ),
                          title: Text(dosen.nama),
                          subtitle: Text(
                            dosen.chat.isNotEmpty
                                ? dosen.chat.last.isi
                                : 'Belum ada chat',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: const Text('Kemarin'),
                        );
                      },
                    ),

      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.sync), label: 'Pembaruan'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Komunitas'),
          NavigationDestination(icon: Icon(Icons.call), label: 'Panggilan'),
        ],
      ),
    );
  }
}
