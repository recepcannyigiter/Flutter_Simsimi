import 'dart:convert';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);
  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  var gelenMesaj = [];
  var gidenMesaj = [];
  bool yazildi = false;
  bool gelen = false;
  TextEditingController controller = TextEditingController();
  ScrollController scrollController = ScrollController();
  getRobot(String gelen) async {
    var govde = {
      "utext": gelen,
      "lang": "tr",
      "cf_info": [
        "qtext",
        "country",
        "atext_bad_prob",
        "atext_bad_type",
        "regist_date"
      ],
    };
    var response =
        await http.post(Uri.parse("https://wsapi.simsimi.com/190410/talk"),
            headers: {
              'content-type': 'application/json',
              'x-api-key': 'your api key'
            },
            body: jsonEncode(govde));
    var res = jsonDecode(response.body);
    print(res);
    var veri = res["atext"];
    setState(() {
      gelenMesaj.add(veri);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("İyi Dost", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            Expanded(
              flex: 10,
              child: SizedBox(
                height: MediaQuery.of(context).size.height / 1.2,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  itemCount: gidenMesaj.length,
                  itemBuilder: (context, index) {
                    return yazildi == false
                        ? Center(child: Text("Sohbete Başla"))
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(
                                child: Bubble(
                                  margin: BubbleEdges.only(top: 70),
                                  alignment: Alignment.topLeft,
                                  nip: BubbleNip.leftBottom,
                                  nipWidth: 10,
                                  shadowColor: Colors.grey[900],
                                  color: Colors.red[800],
                                  child: Text(gelenMesaj[index].toString(),
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                              Expanded(
                                  child: Bubble(
                                margin: BubbleEdges.only(
                                  top: 10,
                                ),
                                alignment: Alignment.topRight,
                                nip: BubbleNip.rightBottom,
                                nipWidth: 10,
                                color: Colors.orange[800],
                                child: Text(gidenMesaj[index].toString(),
                                    style: TextStyle(color: Colors.white)),
                              ))
                            ],
                          );
                  },
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    height: 50,
                    width: 380,
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: "    Sohbet edin!",
                      ),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        var mesaj = controller.text;
                        controller.clear();
                        setState(() {
                          getRobot(mesaj);
                          gidenMesaj.add(mesaj);
                          yazildi = true;
                        });
                      },
                      icon: const Icon(
                        Icons.send,
                        color: Colors.blue,
                        size: 40,
                      ))
                ],
              ),
            ),
          ],
        ));
  }
}
