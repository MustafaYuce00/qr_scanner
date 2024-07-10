import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_scanner/const/consts.dart';
import 'package:url_launcher/url_launcher.dart';

class Resultscreen extends StatefulWidget {
  Resultscreen({super.key, required this.result});
  String? result;

  @override
  State<Resultscreen> createState() => _ResultscreenState();
}

class _ResultscreenState extends State<Resultscreen> {
  bool isuri = false;

  @override
  void initState() {
    super.initState();
    if (Uri.parse(widget.result!).isAbsolute) {
      isuri = true;
    }
  }

  @override
  void dispose() {
    Consts.controller?.resumeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Result ',
            style: TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: Colors.black,
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // qr code circle
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Center(
                        child: Image.asset(
                          'assets/qr.png',
                          width: MediaQuery.of(context).size.width * 0.5  ,
                          height: MediaQuery.of(context).size.width * 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  widget.result!,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                ),
                const SizedBox(
                  height: 20,
                ),
                // copy to clipboard
                IconButton(
                  onPressed: () {
                    Clipboard.setData(
                        ClipboardData(text: widget.result.toString()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Copied to clipboard'),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.copy,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                // visit site button
                isuri == true
                    ? ElevatedButton(
                        onPressed: () {
                          launchUrl(Uri.parse(widget.result!.toString()));
                        },
                        child: const Text('Visit Site'))
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
