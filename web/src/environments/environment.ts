// The file contents for the current environment will overwrite these during build.
// The build system defaults to the dev environment which uses `environment.ts`, but if you do
// `ng build --env=prod` then `environment.prod.ts` will be used instead.
// The list of which env maps to which file can be found in `.angular-cli.json`.

export const environment = {
  production: false,
  apiURL: ' http://localhost:5000/bigmoneyshot-f4694/us-central1/apptest',
  //apiURL: 'https://us-central1-bigmoneyshot-f4694.cloudfunctions.net/apptest',
  defaultRoute: 'tournaments',
  firebase: {
    apiKey: "AIzaSyCzvfzGO5ger7NBVcv1VgLPVKv6grxER7s",
    authDomain: "bigmoneyshot-f4694.firebaseapp.com",
    databaseURL: "https://bigmoneyshot-f4694.firebaseio.com",
    projectId: "bigmoneyshot-f4694",
    storageBucket: "bigmoneyshot-f4694.appspot.com",
    messagingSenderId: "498979789059",
    appId: "1:498979789059:web:7a1b01e23a580b62"
  }
};
