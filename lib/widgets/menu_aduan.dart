import 'package:flutter/material.dart';
import 'package:laporyuk/pages/menuAduan/fasilitasUmum.dart';
import 'package:laporyuk/pages/menuAduan/pelayananKebersihan.dart';
import 'package:laporyuk/pages/menuAduan/pelayananKesehatan.dart';
import 'package:laporyuk/pages/menuAduan/pelayananPublik.dart';

class MenuAduan extends StatelessWidget {
  const MenuAduan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<MenuAduanData> menuAduanList = [
      MenuAduanData(
        icon: Icons.house_siding_rounded,
        title: 'Fasilitas Umum',
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FasilitasUmum()));
        },
      ),
      MenuAduanData(
        icon: Icons.cleaning_services_rounded,
        title: 'Pelayanan Kebersihan',
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PelayananKebersihan()));
        },
      ),
      MenuAduanData(
        icon: Icons.public,
        title: 'Pelayanan Publik',
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PelayananPublik()));
        },
      ),
      MenuAduanData(
        icon: Icons.health_and_safety_rounded,
        title: 'Pelayanan Kesehatan',
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => PelayananKesehatan()));
        },
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(20),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      children: menuAduanList.map((menu) => MenuAduanItem(menuData: menu)).toList(),
    );
  }
}

class MenuAduanItem extends StatelessWidget {
  final MenuAduanData menuData;

  const MenuAduanItem({Key? key, required this.menuData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: menuData.onTap,
      child: Card(
        color: const Color.fromRGBO(57, 167, 255, 1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(menuData.icon, size: 100.0, color: Colors.white),
            const SizedBox(height: 10.0),
            Text(
              menuData.title,
              style: const TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class MenuAduanData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  MenuAduanData({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
