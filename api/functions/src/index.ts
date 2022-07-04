import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import * as express from 'express';
import * as cors from 'cors';
import { bmsStripe } from './lib/bms-stripe';
import { bmsHelpers } from './lib/bms-helpers';
import { checkinService } from './services/checkin-service';
import { tournamentService } from './services/tournament-service';
import { claimService } from './services/claim-service';
import { contestService } from './services/contest-service';
import { courseService } from './services/course-service';
import { stripeService } from './services/stripe-service';
import { confirmService } from './services/confirm-service';
import { purchaseService } from './services/purchase-service';
import { userService } from './services/user-service';
import { adminService } from './services/admin-service';
import { reportService } from './services/report-service';
import { bmsFirestore } from './lib/bms-firestore';

const claimEmailTo = 'lawrence@bigmoneyshot.com, claims@bigmoneyshot.com';
const claimEmailToTest = 'claims@bigmoneyshot.com';
const contactUsEmail = 'support@bigmoneyshot.com';

//options for cors midddleware
const options: cors.CorsOptions = {
  allowedHeaders: ['X-ACCESS_TOKEN', 'Access-Control-Allow-Origin', 'Authorization', 'Origin', 'x-requested-with', 'Content-Type', 'Content-Range', 'Content-Disposition', 'Content-Description'],
  credentials: true,
  methods: 'GET,HEAD,OPTIONS,PUT,PATCH,POST,DELETE',
  origin: ['http://localhost:4200', 'https://app.bigmoneyshot.com'],
  preflightContinue: false
};

admin.initializeApp();
const app = express();
const appTest = express();


//add cors middleware
app.use(cors(options));
appTest.use(cors(options));

//enable pre-flight, allow OPTIONS on all resources
app.options('*', cors(options));
appTest.options('*', cors(options));

// [START Middleware]
app.use(bmsHelpers.middlewareValidateToken);
appTest.use(bmsHelpers.middlewareValidateToken);
// [END Middleware]

// [START Express LIVE App]

// [START stripe webhooks]
exports.events = functions.https.onRequest(async (req, res) => {
  await stripeService.handleEvent(req, res, bmsStripe.webhooksSecretLive, bmsStripe.stripeLive);
});
// [END stripe webhooks]


// [START Firestore Event Listeners]
exports.createPurchase = functions.firestore.document('purchases/{purchaseId}').onCreate(async event => {
  const data = event.data();

  if (!data) {
    return;
  }

  if (data.userId === 'poYVLUbOYLgDF40C22q0gNCbQHg2') {
    console.log('ignoring purchase, test account oggie - member@test.com');
    return;
  } //member@mtest.com Brian Ogden

  if (data.userId === 'SMGS87a22wT4JYuyTuN5YqvDnin2') {
    console.log('ignoring purchase, test account lunch - drunk@gmail.com')
    return;
  }//drunk@gmail.com Lawrence Chapman

  const courseId = data.contest.courseId;

  await bmsFirestore.incrementPurchaseCounts(courseId, 1);
});

exports.createCheckin = functions.firestore.document('checkins/{checkinId}').onCreate(async event => {
  const data = event.data();

  if (!data) {
    return;
  }

  const courseId = data.courseId;

  await bmsFirestore.incrementCheckInCounts(courseId, 1);
});


exports.createUser = functions.firestore.document('users/{userId}').onCreate(async event => {
  const data = event.data();

  if (!data) {
    return;
  }

  const courseId = data.lastCourseId;

  await bmsFirestore.incrementUserCounts(courseId, 1);
});

exports.deleteUser = functions.firestore.document('users/{userId}').onDelete(async event => {
  const data = event.data();

  if (!data) {
    return;
  }

  const courseId = data.lastCourseId;

  await bmsFirestore.incrementUserCounts(courseId, -1);
});
// [END Firestore Event Listeners]

//***************API functions*********************** */
// [START claim]
app.post('/claim', async (req, res) => {
  await claimService.handleClaim(req, res, claimEmailTo);
});
// [END claim]

// [START user]
app.get('/user', async (req, res) => {
  await stripeService.handleGetUser(req, res, bmsStripe.stripeLive);
});

app.post('/user', async (req, res) => {
  await stripeService.handleUserPost(req, res, bmsStripe.stripeLive);
});
// [END user]

// [START ephemeralKey]
app.post('/ephemeralKey', async (req, res) => {
  await stripeService.handleEphemeralKey(req, res, bmsStripe.stripeLive);
});
// [END ephemeralKey]

// [START charge]
app.post('/charge', async (req, res) => {
  await stripeService.handleCharge(req, res, bmsStripe.stripeLive);
});
// [END charge]

// [START purchase]
app.post('/purchase', async (req, res) => {
  await stripeService.handlePurchase(req, res, bmsStripe.stripeLive);
});

app.get('/purchases', async (req, res) => {
  await stripeService.handlePurchases(req, res);
});
// [END purchases]

// [START payments]
app.get('/paymentMethods', async (req, res) => {
  await stripeService.handlePaymentMethods(req, res, bmsStripe.stripeLive);
});
// [END payments]

// [START course]
app.get('/course', async (req, res) => {
  await courseService.handleGetCourse(req, res);
});

app.get('/courses', async (req, res) => {
  await courseService.handleGetCourses(req, res);
});
// [END course]

// [START contest]
app.get('/contests', async (req, res) => {
  await contestService.handleGetContests(req, res);
});
// [END contest]

// [START tournament]
app.post('/tournament', async (req, res) => {
  await tournamentService.handleTournamentPost(req, res);
});

app.get('/tournaments', async (req, res) => {
  await tournamentService.handleTournamentsGet(req, res);
});

app.put('/tournament', async (req, res) => {
  await tournamentService.handleTournamentPut(req, res);
});

app.delete('/tournament', async (req, res) => {
  await tournamentService.handleTournamentDelete(req, res);
});
// [END tournament]

// [START checkin]
app.get('/checkin', async (req, res) => { //anonymous
  await checkinService.handleCheckinGet(req, res);
});

app.post('/checkin', async (req, res) => {
  await checkinService.handleCheckin(req, res);
});
// [END checkin]

// [START confirm]
app.post('/confirm', async (req, res) => {
  await confirmService.handleConfirm(req, res);
});
// [END confirm]

// [START users v2]
app.get('/v2/user', async (req, res) => {
  await userService.handleGetUser(req, res);
});

app.get('/v2/users', async (req, res) => {
  await userService.handleUsersGet(req, res);
});

app.delete('/v2/user', async (req, res) => {
  await userService.handleUserDelete(req, res);
});

app.post('/v2/user', async (req, res) => {
  await userService.handleCreateUser(req, res);
});

app.put('/v2/user', async (req, res) => {
  await userService.handleUserUpdate(req, res);
});
// [END users v2]

// [START purchase v2]
app.get('/v2/purchases', async (req, res) => {
  await purchaseService.handlePurchasesGet(req, res);
});

app.post('/v2/purchase', async (req, res) => {
  await purchaseService.handlePurchase(req, res);
});
// [END purchases]

// [START admin]
app.post('/contactus', async (req, res) => {
  await adminService.handleContactUs(req, res, contactUsEmail);
});
// [END admin]

// [START report]
app.get('/purchaseSummary', async (req, res) => {
  await reportService.handlePurchaseSummary(req, res);
});
// [END report]

//Expose Express API as a single Cloud Function:
exports.app = functions.https.onRequest(app);

// [END Express LIVE App]

/*
============================================================================
============================================================================
============================================================================
============================================================================
============================================================================
*/

// [START Express TEST App]

// [START stripe webhooks]
exports.eventstest = functions.https.onRequest(async (req, res) => {
  await stripeService.handleEvent(req, res, bmsStripe.webhooksSecretTest, bmsStripe.stripeTest);
});
// [END stripe webhooks]

// [START claim]
appTest.post('/claim', async (req, res) => {
  await claimService.handleClaim(req, res, claimEmailToTest, true);
});
// [END claim]


// [START user]
appTest.post('/user', async (req, res) => {
  await stripeService.handleUserPost(req, res, bmsStripe.stripeTest);
});

appTest.get('/user', async (req, res) => {
  await stripeService.handleGetUser(req, res, bmsStripe.stripeTest);
});
// [END user]

// [START ephemeralKey]
appTest.post('/ephemeralKey', async (req, res) => {
  await stripeService.handleEphemeralKey(req, res, bmsStripe.stripeTest)
});
// [END ephemeralKey]


// [START charge]
appTest.post('/charge', async (req, res) => {
  await stripeService.handleCharge(req, res, bmsStripe.stripeTest);
});
// [END charge]

// [START purchase]
appTest.post('/purchase', async (req, res) => {
  await stripeService.handlePurchase(req, res, bmsStripe.stripeTest);
});

appTest.get('/purchases', async (req, res) => {
  await stripeService.handlePurchases(req, res);
});
// [END purchases]

// [START payments]
appTest.get('/paymentMethods', async (req, res) => {
  await stripeService.handlePaymentMethods(req, res, bmsStripe.stripeTest);
});
// [END payments]

// [START course]
appTest.get('/course', async (req, res) => {
  await courseService.handleGetCourse(req, res);
});

appTest.get('/courses', async (req, res) => {
  await courseService.handleGetCourses(req, res);
});
// [END course]

// [START contests]
appTest.get('/contests', async (req, res) => {
  await contestService.handleGetContests(req, res);
});
// [END contests]

// [START tournament]
appTest.post('/tournament', async (req, res) => {
  await tournamentService.handleTournamentPost(req, res);
});

appTest.get('/tournaments', async (req, res) => {
  await tournamentService.handleTournamentsGet(req, res);
});

appTest.put('/tournament', async (req, res) => {
  await tournamentService.handleTournamentPut(req, res);
});

appTest.delete('/tournament', async (req, res) => {
  await tournamentService.handleTournamentDelete(req, res);
});
// [END tournament]

// [START checkin]
appTest.get('/checkin', async (req, res) => { //anonymous
  await checkinService.handleCheckinGet(req, res);
});

appTest.post('/checkin', async (req, res) => {
  await checkinService.handleCheckin(req, res);
});
// [END checkin]

// [START confirm]
appTest.post('/confirm', async (req, res) => {
  await confirmService.handleConfirm(req, res);
});
// [END confirm]

// [START users v2]
appTest.get('/v2/user', async (req, res) => {
  await userService.handleGetUser(req, res);
});

appTest.get('/v2/users', async (req, res) => {
  await userService.handleUsersGet(req, res);
});

appTest.delete('/v2/user', async (req, res) => {
  await userService.handleUserDelete(req, res);
});

appTest.post('/v2/user', async (req, res) => {
  await userService.handleCreateUser(req, res);
});

appTest.put('/v2/user', async (req, res) => {
  await userService.handleUserUpdate(req, res);
});

// [END users v2]

// [START purchase v2]
appTest.get('/v2/purchases', async (req, res) => {
  await purchaseService.handlePurchasesGet(req, res);
});

appTest.post('/v2/purchase', async (req, res) => {
  await purchaseService.handlePurchase(req, res);
});
// [END purchases]

// [START admin]
appTest.post('/contactus', async (req, res) => {
  await adminService.handleContactUs(req, res, contactUsEmail);
});

appTest.post('/deletePurchases', async (req, res) => {
  await adminService.handleDeletePurchases(req, res);
});
// [END admin]

// [START report]
appTest.get('/purchaseSummary', async (req, res) => {
  await reportService.handlePurchaseSummary(req, res);
});
// [END report]


//Expose Express API as a single Cloud Function:np
exports.apptest = functions.https.onRequest(appTest);

// [END Express TEST App]
