import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
class TaskDrawer extends StatelessWidget {
  const TaskDrawer({super.key});
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: const Text("zagabi"),
            accountEmail: const Text("zagabi@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.asset("assets/images/zagabi.jpeg"),
              ),
            ),
          ),
          ListTile(
            onTap: () => launchUrl(Uri.parse("https://www.youtube.com/@kundol")),
            leading: const Icon(Icons.youtube_searched_for_rounded),
            title: const Text("About me"),
          ),
          ListTile(
            onTap: () => launchUrl(Uri.parse("https://www.youtube.com/@kundol")),
            leading: const Icon(Icons.mail_outline_rounded),
            title: const Text("Contact me"),
          ),
        ],
      ),
    );
  }
}
