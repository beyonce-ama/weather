import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
         leading: CupertinoButton(  
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back),
          onPressed: () {
              _showInfoDialog(context);
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.info),
          onPressed: ()  {
           
          },
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: <Widget>[
            _buildSettingsRow(
              icon: CupertinoIcons.location_solid,
              iconColor: CupertinoColors.systemOrange,
              title: 'Location',
              onTap: ()  {
              
              },
            ),
           
            _buildSwitchRow(
              icon: CupertinoIcons.thermometer,
              iconColor: CupertinoColors.systemRed,
              title: 'Use Celsius',
              value: ,   
              onChanged: () {}
              },
            ),
             _buildSwitchRow(
              icon: CupertinoIcons.sun_max,
              iconColor: CupertinoColors.systemYellow,
              title: 'Light Mode',
              value: ,
              onChanged: () {
                
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showLocationInputDialog(BuildContext context) async {
    TextEditingController locationController = TextEditingController(text: _location);
    return showCupertinoDialog<String>(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Enter Location'),
        content: CupertinoTextField(
          controller: locationController,
          placeholder: 'City name',
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          CupertinoDialogAction(
            child: Text('Save'),
            onPressed: () => Navigator.of(context).pop(locationController.text),
          ),
        ],
      ),
    );
  }

  void _showLocationErrorDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Invalid Location'),
        content: Text('The entered location was not found.'),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return CupertinoListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      trailing: CupertinoSwitch(
        value: value,
        onChanged: onChanged,
        activeTrackColor: CupertinoColors.activeGreen,
      ),
    );
  }

  Widget _buildSettingsRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? secondaryText,
    VoidCallback? onTap,
  }) {
    return CupertinoListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (secondaryText != null)
            Text(
              secondaryText,
              style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context)),
            ),
          Icon(CupertinoIcons.forward, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
        ],
      ),
      onTap: onTap,
    );
  }
}

void _showInfoDialog(BuildContext context) {
  showCupertinoDialog(
    context: context,
    builder: (context) => Center( 
      child: CupertinoPopupSurface(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,  
          height: 450,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min, 
            children: [
              const Text(
                "Meet the Team", 
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildMemberTile("Beyonce Ama", "images/ama.jpg", "Lead Developer"),
                      _buildMemberTile("Jolas Arpon", "images/arpon.jpg", "Developer"),
                      _buildMemberTile("Monica Carreon", "images/carreon.jpg", "Developer"),
                      _buildMemberTile("Romel Gamboa", "images/gamboa.jpg", "Developer"),
                      _buildMemberTile("Kayle Cedric Larin", "images/larin.jpg", "Developer"),
                      _buildMemberTile("Rachelle Anne Macalino", "images/macalino.jpg", "Developer"),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              CupertinoButton(
                child: const Text(
                  "Close", 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}


  Widget _buildMemberTile(String name, String imagePath, String role) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.indigo.shade200,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              Text(role, style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey)),
            ],
          ),
        ],
      ),
    );
  }