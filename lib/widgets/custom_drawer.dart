import 'package:flutter/material.dart';
import '../config/theme.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String? userPhotoUrl;
  final List<DrawerItem> items;
  final VoidCallback? onLogout;

  const CustomDrawer({
    Key? key,
    required this.userName,
    required this.userEmail,
    this.userPhotoUrl,
    required this.items,
    this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppTheme.primaryColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      userPhotoUrl != null ? NetworkImage(userPhotoUrl!) : null,
                  child:
                      userPhotoUrl == null
                          ? const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.white,
                          )
                          : null,
                ),
                const SizedBox(height: 8),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  leading: Icon(item.icon),
                  title: Text(item.title),
                  onTap: item.onTap,
                );
              },
            ),
          ),
          if (onLogout != null)
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: onLogout,
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class DrawerItem {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const DrawerItem({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}
