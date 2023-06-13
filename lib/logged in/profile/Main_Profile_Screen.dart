import 'package:flutter/material.dart';
import 'package:shakoosh_wk/logged in/profile/Profile_information.dart';
import 'package:shakoosh_wk/logged in/profile/Edit_Profile_Screen.dart';
import 'package:shakoosh_wk/Shakoosh_Icons.dart';
import 'package:shakoosh_wk/logged in/profile/Settings_Screen.dart';
import 'package:shakoosh_wk/logged in/profile/About_Us_Screen.dart';
import 'package:shakoosh_wk/logged in/profile/Get_Help_Screen.dart';
import 'package:shakoosh_wk/repository/User_Repository.dart';
import 'package:shakoosh_wk/Custom_Page_Route.dart';
import 'package:shakoosh_wk/logged in/profile/Manage_Schedule.dart';

class MainProfileScreen extends StatelessWidget {
  final void Function() onLogOutTap;
  final void Function(int option) onChangePhotoTap;

  const MainProfileScreen(
      {required this.onLogOutTap, required this.onChangePhotoTap, super.key});
  @override
  Widget build(context) {
    double screenHeight = (MediaQuery.of(context).size.height) -
        (MediaQuery.of(context).padding.top) -
        (MediaQuery.of(context).padding.bottom);
    return SizedBox(
      height: screenHeight * 0.93,
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileInformation(
                onChangePhotoTap: onChangePhotoTap,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 245, 196, 63),
                          shape: const StadiumBorder()),
                      onPressed: () {
                        Navigator.push(context,
                            CustomPageRoute(child: const EditProfileScreen()));
                      }, //onEditInformationTap,
                      child: Text('Edit profile',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: Colors.black))),
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: screenHeight * 0.22,
                  child: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ProfileListTile(
                            iconData: Icons.settings,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                      child: const SettingsScreen()));
                            },
                            title: 'Settings',
                          ),
                          ProfileListTile(
                            iconData: Icons.timelapse,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                      child: const ManageScheduleScreen()));
                            },
                            title: 'Manage schedule',
                          ),
                          ProfileListTile(
                            iconData: ShakooshIcons.logo_transparent_black_2,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                      child: const AboutUsScreen()));
                            },
                            title: 'About us',
                          ),
                          ProfileListTile(
                            iconData: Icons.help,
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                      child: const GetHelpScreen()));
                            },
                            title: 'Get help',
                          ),
                          ProfileListTile(
                            iconData: Icons.power_settings_new_rounded,
                            onTap: onLogOutTap,
                            title: 'Log out',
                          )
                        ]),
                  )),
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 55),
                  width: double.infinity,
                  child: Text(
                      "Joined  ${UserRepository.getCurrentUser().getCreationDate()}",
                      textAlign: TextAlign.end,
                      style: TextStyle(color: Colors.grey)))
            ]),
      ),
    );
  }
}

class ProfileListTile extends StatelessWidget {
  final IconData iconData;
  final String title;
  final void Function() onTap;
  const ProfileListTile(
      {required this.onTap,
      required this.title,
      required this.iconData,
      super.key});
  @override
  Widget build(context) {
    return ListTile(
      leading: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Theme.of(context).colorScheme.shadow),
          child: Icon(iconData, color: Theme.of(context).colorScheme.tertiary)),
      title: Text(title, style: Theme.of(context).textTheme.bodyMedium),
      trailing: IconButton(
        onPressed: () {
          onTap();
        },
        icon: const Icon(
          Icons.arrow_forward_ios_rounded,
        ),
      ),
    );
  }
}
