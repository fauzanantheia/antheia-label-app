/* Firebase settings for accounts and cloud saving.
   Replace this whole object with the "firebaseConfig" from your Firebase project:
   Firebase console > Project settings (gear icon) > General > Your apps > Web app > SDK setup and configuration > Config.
   These values are not secret; your data is protected by the Firestore rules in firestore.rules.
   While the values below still say PASTE..., the app works without accounts (designs stay on the device). */
window.FIREBASE_CONFIG = {
  apiKey: "PASTE_YOUR_API_KEY",
  authDomain: "PASTE_YOUR_PROJECT_ID.firebaseapp.com",
  projectId: "PASTE_YOUR_PROJECT_ID",
  storageBucket: "PASTE_YOUR_PROJECT_ID.appspot.com",
  messagingSenderId: "PASTE_SENDER_ID",
  appId: "PASTE_APP_ID"
};
