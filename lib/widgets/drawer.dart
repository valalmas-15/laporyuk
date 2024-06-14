import 'package:flutter/material.dart';
import 'package:laporyuk/pages/login.dart';
import 'package:laporyuk/pages/dashboard.dart';
import 'package:laporyuk/pages/riwayatLaporan.dart';
import 'package:laporyuk/pages/akun.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'LaporYuk!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Dashboard'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Dashboard()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Riwayat Laporan'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RiwayatLaporan()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_box),
            title: const Text('Akun'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Akun()),
              );
            },
          ),
          const SizedBox(height: 380.0),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            },
            child: ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text('Logout'),
              tileColor: const Color.fromARGB(255, 244, 112, 94),
            ),
          ),
        ],
      ),
    );
  }
}
