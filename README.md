# Chat Application

This is a flutter based messaging app where users can sign in with their emails to chat with their friends, family, colleagues.

![Chat-Application](./media/app-banner.png)

### Dependencies

1. [Firebase_Core](https://pub.dev/packages/firebase_core)

1. [Firebase_Auth](https://pub.dev/packages/firebase_auth)

1. [Cloud_Firestore](https://pub.dev/packages/cloud_firestore)

1. [Google_Sign_In](https://pub.dev/packages/google_sign_in)

1. [Cached_Network_Image](https://pub.dev/packages/cached_network_image)

## Installation

##### 1. Clone the repository

```bash
git clone https://github.com/edilsonmatola/flutter_chat_application.git
```

##### 2. Move to the desired folder

```bash
cd flutter_chat_application
```

3. Create Firebase Project
   ⚠️ When registering your app make sure to insert the **Debug signing certificate SHA-1**
4. Enable Auth with Google (in Additional Providers)
5. Make Firestore Rules
6. Create Android & iOS apps

##### 7. To run the app, simply write the following commands:

```bash
flutter pub get
# flutter emulators --launch "emulator_id" (to get Android Simulator)
open -a simulator (to get iOS Simulator)
flutter run
flutter run -d chrome --web-renderer html (to see the best output)
```
