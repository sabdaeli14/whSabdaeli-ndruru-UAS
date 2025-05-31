import 'package:flutter/material.dart';
import 'package:whazlansaja/models/dosen.dart';
import 'package:whazlansaja/data_saya.dart'; 

class PesanScreen extends StatefulWidget {
  final Dosen dosen;

  const PesanScreen({super.key, required this.dosen});

  @override
  State<PesanScreen> createState() => _PesanScreenState();
}

class _PesanScreenState extends State<PesanScreen> {
  final TextEditingController _controller = TextEditingController();
  late List<Chat> pesanList;

  @override
  void initState() {
    super.initState();
    pesanList = List.from(widget.dosen.chat);
  }

  void kirimPesan() {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      pesanList.add(Chat(
        from: 1,
        isi: _controller.text.trim(),
      ));
      _controller.clear();
    });
  }

  @override
  void dispose() {
    widget.dosen.chat
      ..clear()
      ..addAll(pesanList);
    Navigator.pop(context, widget.dosen);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        widget.dosen.chat
          ..clear()
          ..addAll(pesanList);
        Navigator.pop(context, widget.dosen);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(widget.dosen.avatar),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.dosen.nama,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    '09.00',
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              )
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: pesanList.length,
                itemBuilder: (context, index) {
                  final pesan = pesanList[index];
                  final isUser = pesan.from == 1;

                  return Row(
                    mainAxisAlignment:
                        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (!isUser)
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage(widget.dosen.avatar),
                          ),
                        ),
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          constraints: BoxConstraints(
                              maxWidth: MediaQuery.of(context).size.width * 0.65),
                          decoration: BoxDecoration(
                            color: isUser ? Colors.green[400] : Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            pesan.isi,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                      if (isUser)
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CircleAvatar(
                            radius: 16,
                            backgroundImage: AssetImage(DataSaya.gambar),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Ketikkan pesan',
                        filled: true,
                        fillColor: Colors.grey[900],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: kirimPesan,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
