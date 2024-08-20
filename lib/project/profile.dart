import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auth_profile.dart';
import '../models/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<void> _fetchProfileFuture;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<UserProfileProvider>(context, listen: false);
    _fetchProfileFuture = provider.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<UserProfileProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: FutureBuilder<void>(
        future: _fetchProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (provider.userProfile != null) {
            final user = provider.userProfile!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            'Profile Information',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              '${user.name.firstname} ${user.name.lastname}',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text('Name'),
                            leading: Icon(Icons.person, color: Colors.blue),
                          ),
                          Divider(),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(user.email, style: TextStyle(fontSize: 18)),
                            subtitle: Text('Email'),
                            leading: Icon(Icons.email, color: Colors.blue),
                          ),
                          Divider(),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(user.username, style: TextStyle(fontSize: 18)),
                            subtitle: Text('Username'),
                            leading: Icon(Icons.account_circle, color: Colors.blue),
                          ),
                          Divider(),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(user.phone, style: TextStyle(fontSize: 18)),
                            subtitle: Text('Phone'),
                            leading: Icon(Icons.phone, color: Colors.blue),
                          ),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Address',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            '${user.address.street}, ${user.address.number}, ${user.address.city}, ${user.address.zipcode}',
                            style: TextStyle(fontSize: 18),
                          ),
                          // SizedBox(height: 8),
                          // Text(
                          //   'Geolocation',
                          //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          // ),
                          // Text(
                          //   'Lat: ${user.address.geolocation.lat}, Long: ${user.address.geolocation.long}',
                          //   style: TextStyle(fontSize: 18),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )  ,
                          elevation: 5,
                        ),
                        onPressed: () async {
                          Provider.of<AuthService>(context, listen: false).logout();
                          Navigator.pushReplacementNamed(context, '/login');
                        },
                        child: Text('Logout')),
                  )

                ],
              ),
            );
          }
          return Center(child: Text('No data available'));
        },
      ),
    );
  }
}
