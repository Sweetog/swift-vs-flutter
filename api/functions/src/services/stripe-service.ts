import * as express from 'express';
import * as Stripe from 'stripe';
import { bmsStripe } from '../lib/bms-stripe';
import { bmsFirestore } from '../lib/bms-firestore';
import { bmsHelpers } from '../lib/bms-helpers';
import * as admin from 'firebase-admin';

type PaymentMethod = { id: string, brand: string, tokenizationMethod: string, last4: string, isDefault: boolean };
type Purchase = { id: string, userId: string, contest: any, course: any, timestamp: any };

class StripeService {
    handleCharge = async (req: express.Request, res: express.Response, stripe: Stripe) => {
        const userId = req.userId;
        const stripeCustomerId = req.stripeCustomerId;
        const amount = req.body.amount;
        const source = req.body.source;
        const currency = req.body.currency;

        if (!userId) {
            res.status(400).end();
            return;
        }

        //validation
        if (!stripeCustomerId) {
            console.debug('======== /charge  no stripeCustomerId =======');
            res.status(400).end();
            return;
        }

        if (!amount) {
            console.debug('======== /charge no amount =======');
            res.status(400).end();
            return;
        }

        if (!source) {
            console.debug('========  /charge no source =======');
            res.status(400).end();
            return;
        }

        if (!currency) {
            console.debug('======== /charge no currency =======');
            res.status(400).end();
            return;
        }

        try {
            console.debug('charging stripe card - amount:', amount);
            const chargeRes = await stripe.charges.create({
                amount: amount,
                currency: currency,
                customer: stripeCustomerId,
                source: source,
                description: 'Charge for ' + req.email
            });

            const credit = (-1 * amount);  //credits are negative ledgers
            console.debug('adding credit to accountBalance:', credit);

            const customer = await bmsStripe.getCustomerStripe(stripeCustomerId, stripe);

            const newBalance = bmsHelpers.calculateCustomerBalance(credit, customer.account_balance);

            console.debug('new balance to update:', newBalance);
            await bmsStripe.updateBalanceStripe(stripeCustomerId, newBalance, stripe);

            console.debug('writing charge to firestore');
            await admin.firestore().collection('charges').doc(userId).set(chargeRes);

            res.status(204).json({}); //iOS App Library alamofire does not deal with empty responses well, give it something
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleEvent = async (req: any, res: any, webhooksSecret: any, stripe: Stripe) => {
        // Get the signature from the request header
        const sig = req.headers['stripe-signature'];

        if (!sig) {
            res.status(400).end();
            return;
        }

        // Verify the request against our endpointSecret
        try {
            const event = stripe.webhooks.constructEvent(req.rawBody, sig, webhooksSecret);
            console.log(event)
            res.status(200).end();
        } catch (err) {
            console.error('unable to verify request: rawBody', req.rawBody)
            res.status(400).end();
        }
    }

    handleEphemeralKey = async (req: express.Request, res: express.Response, stripe: Stripe) => {
        const stripe_version = req.body.api_version;
        const customerId = req.stripeCustomerId;

        //validation
        if (!stripe_version) {
            res.status(400).end();
            return;
        }

        if (!customerId) {
            res.status(400).end();
            return;
        }

        try {
            const key = await stripe.ephemeralKeys.create(
                { customer: customerId }, { stripe_version: stripe_version });
            res.status(200).json(key);
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handlePaymentMethods = async (req: express.Request, res: express.Response, stripe: Stripe) => {
        const customerId = req.stripeCustomerId;

        if (!customerId) {
            res.status(400).end();
            return;
        }

        try {
            const customer = await bmsStripe.getCustomerStripe(customerId, stripe);

            if (!customer.sources || !customer.sources.data || !customer.sources.data.length) {
                res.status(200).end();
                return;
            }

            console.log('default_source type: ', typeof (customer.default_source));

            const ret = Array<PaymentMethod>();
            for (let i = 0; i < customer.sources.data.length; i++) {
                const p = <any>customer.sources.data[i];

                ret.push({
                    id: p['id'],
                    brand: p['brand'],
                    tokenizationMethod: p['tokenization_method'],
                    last4: p['last4'],
                    isDefault: p['id'] === customer.default_source
                });
            }

            res.status(200).json(ret);
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handlePurchases = async (req: express.Request, res: express.Response) => {
        const userId = req.userId;

        //validation
        if (!userId) {
            res.status(400).end();
            return;
        }

        try {
            const docs = await bmsFirestore.getPurchases(userId);
            if (!docs) {
                res.status(404).end();
                return
            }

            const purchases = docs.map(doc => {
                const data = doc.data();
                return <Purchase>{
                    id: doc.id,
                    userId: userId,
                    contest: data.contest,
                    course: data.course,
                    timestamp: data.timestamp
                }
            });

            res.status(200).json(purchases);
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleUserPost = async (req: express.Request, res: express.Response, stripe: Stripe) => {
        const email = req.body.email;
        //app will not create account unless user consents to age, age verified always true
        //const isAge18Verified = (req.body.isAge18Verified) == 'true' ? true : false;
        const isAgeVerified = true;


        //validation
        if (!req.userId) {
            res.status(400).end();
            return;
        }

        if (!email) {
            res.status(400).end();
            return;
        }

        try {
            const customer = await stripe.customers.create({ email: email });
            await bmsFirestore.setUserV1(req.userId, customer.id, isAgeVerified);
            const userData = await bmsFirestore.getUser(req.userId);
            res.status(200).json(userData);
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }


    handlePurchase = async (req: express.Request, res: express.Response, stripe: Stripe) => {
        const userId = req.userId;
        const stripeCustomerId = req.stripeCustomerId;
        const courseId = req.body.courseId;
        const contestId = req.body.contestId;

        //validation
        if (!userId) {
            res.status(400).end();
            return;
        }

        if (!stripeCustomerId) {
            res.status(400).end();
            return;
        }

        if (!courseId) {
            res.status(400).end();
            return;
        }

        if (!contestId) {
            res.status(400).end();
            return;
        }

        try {
            //get contest cost
            const contest = await bmsFirestore.getContest(contestId);

            if (!contest) {
                bmsHelpers.requestErrorLogger(req, 'contestId not found: ' + contestId);
                res.status(400).end();
                return;
            }

            //get stripe balance
            const customer = await bmsStripe.getCustomerStripe(stripeCustomerId, stripe);

            //ensure there is credit
            if (!customer.account_balance || (-1 * customer.account_balance) < contest.amount) {
                bmsHelpers.requestErrorLogger(req, 'not enough funds to purchase contestId: ' + contestId);
                res.status(422).end();
                return;
            }

            const newBalance = bmsHelpers.calculateCustomerBalance(contest.amount, customer.account_balance);

            await bmsStripe.updateBalanceStripe(stripeCustomerId, newBalance, stripe);
            console.debug('writing purchase to firestore');
            await bmsFirestore.addPurchaseStripe(userId, contest);
            res.status(204).json({}); //iOS App Library alamofire does not deal with empty responses well, give it something
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleGetUser = async (req: express.Request, res: express.Response, stripe: Stripe) => {
        //validation
        if (!req.userId) {
            res.status(400).end();
            return;
        }

        try {
            const userData = await bmsFirestore.getUser(req.userId);
            if (!userData) {
                console.error('/user get handleGetUser no user data');
                res.status(404).end();
                return
            }

            if (!userData.stripeCustomerId) {
                res.status(200).json(userData);
                return
            }

            const stripeData = await bmsStripe.getCustomerStripe(userData.stripeCustomerId, stripe)
            userData.accountBalance = stripeData.account_balance;
            res.status(200).json(userData);
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }
}

export const stripeService = new StripeService();