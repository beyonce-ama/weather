import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  final bool isLightMode;
  final ValueChanged<bool> onLightModeChanged;
  final bool isCelsius;
  final ValueChanged<bool> onTemperatureUnitChanged;
  final String location;
  final ValueChanged<String> onLocationChanged;

  const SettingsPage({
    super.key,
    required this.isLightMode,
    required this.onLightModeChanged,
    required this.isCelsius,
    required this.onTemperatureUnitChanged,
    required this.location,
    required this.onLocationChanged,
  });

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late bool _lightMode;
  late bool _isCelsius;
  late String _location;

  @override
  void initState() {
    super.initState();
    _lightMode = widget.isLightMode;
    _isCelsius = widget.isCelsius;
    _location = widget.location;
  }

  Future<bool> _checkLocationValidity(String location) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=71039c9eb96817fb861a01cee2b13766"));

    if (response.statusCode == 200) {
      return true; 
    } else {
      return false; 
    }
  }
 double convertTemperature(double tempCelsius, bool isCelsius) {
    return isCelsius ? tempCelsius : (tempCelsius * 9 / 5) + 32;
  }

  String formatTemperature(double temp, bool isCelsius) {
    return "${temp.toStringAsFixed(1)}${isCelsius ? '°C' : '°F'}";
  }

  String formatHumidity(int humidity) {
    return "$humidity%";
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Settings'),
         leading: CupertinoButton(  
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.back),
          onPressed: () async {
            bool isValid = await _checkLocationValidity(_location);
            if (isValid) {
              Navigator.pop(context, _location);
            } else {
              _showLocationErrorDialog(context);
            }
          },
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          child: Icon(CupertinoIcons.info),
          onPressed: ()  {
            _showInfoDialog(context);
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
              secondaryText: _location,
              onTap: () async {
                final newLocation = await _showLocationInputDialog(context);
                if (newLocation != null && newLocation.isNotEmpty) {
                  setState(() {
                    _location = newLocation;
                  });
                  widget.onLocationChanged(newLocation);
                }
              },
            ),
           
            _buildSwitchRow(
              icon: CupertinoIcons.thermometer,
              iconColor: CupertinoColors.systemRed,
              title: 'Use Celsius',
              value: _isCelsius,   
              onChanged: (bool value) {
                setState(() {
                  _isCelsius = value;
                });
                widget.onTemperatureUnitChanged(value);
              },
            ),
             _buildSwitchRow(
              icon: CupertinoIcons.sun_max,
              iconColor: CupertinoColors.systemYellow,
              title: 'Light Mode',
              value: _lightMode,
              onChanged: (bool value) {
                setState(() {
                  _lightMode = value;
                });
                widget.onLightModeChanged(value);
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