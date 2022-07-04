
import * as express from 'express';
import { bmsMailgun } from '../lib/bms-mailgun';
import { bmsFirestore } from '../lib/bms-firestore';
import { bmsHelpers } from '../lib/bms-helpers';

class ClaimService {
    handleClaim = async (req: express.Request, res: express.Response, to: string, isTestMode: boolean = false) => {
        const purchaseId = req.body.purchaseId;
        let phone = req.body.phone;
        const time = req.body.time;
        const comboContestName = req.body.comboContestName;
        const comboContestPayout = req.body.comboContestPayout;
        let teeBox = req.body.teeBox;
        const userId = req.userId;
        let email: string | null = null; // string | undefined conversion issue with req.email, must be explicit
        let name: string | null = null; // string | undefined conversion issue with req.name, must be explicit
        const email_verified = req.email_verified;

        // string | undefined conversion issue with req.name, must be explicit
        if (req.name) {
            name = req.name;
        }

        // string | undefined conversion issue with req.email, must be explicit
        if (req.email) {
            email = req.email;
        }

        //validation
        if (!userId) {
            res.status(400).end();
            return;
        }

        if (!purchaseId) {
            res.status(400).end();
            return;
        }

        //removed from Android UI
        // if (!phone) {
        //   res.status(400).end();
        //   return;
        // }

        if (!time) {
            res.status(400).end();
            return;
        }

        if (!teeBox) {
            teeBox = null; //iOS not sending teeBox yet, protection
        }


        if (!phone) {
            phone = null; //Android not sending phone, deprecated, protection
        }

        try {
            const purchase = await bmsFirestore.getPurchase(purchaseId);
            if (!purchase) {
                res.status(400).end();
                return;
            }

            if (purchase.claimId) {
                //claim already started
                res.status(429).end();
                return;
            }

            let contestName = purchase.contest.name;
            let contestPayout = purchase.contest.payout;

            //override with combo contest selected Grand Slam etc
            if (comboContestName) {
                contestName = comboContestName;
            }

            if (comboContestPayout) {
                contestPayout = comboContestPayout;

            }

            console.log('contestPayout', contestPayout);
            const doc = await bmsFirestore.addClaim(userId, purchase, time, phone, contestName, contestPayout, email, name);
            await bmsFirestore.updatePurchase(purchaseId, doc.id);

            if (contestPayout <= 5000) { //auto credit payouts of $50.00 or less
                await bmsHelpers.updateAccountBalance(userId, -1 * contestPayout); //credit
            }

            const htmlBody = '<ul>' +
                '<li><strong>Course</strong>: ' + purchase.course.name + '</li>' +
                '<li><strong>Hole</strong>: ' + purchase.course.hole + '</li>' +
                '<li><strong>Contest</strong>: ' + contestName + '</li>' +
                '<li><strong>Payout</strong>: $' + contestPayout / 100 + '</li>' +
                '<li><strong>Amount</strong>: $' + purchase.contest.amount / 100 + '</li>' +
                '<li><strong>Time</strong>: ' + time + '</li>' +
                '<li><strong>Teebox</strong>: ' + teeBox + '</li>' +
                '<li><strong>Phone</strong>: ' + phone + '</li>' +
                '<li><strong>Name</strong>: ' + name + '</li>' +
                '<li><strong>Email</strong>: ' + email + '</li>' +
                '<li><strong>Email Verified</strong>: ' + email_verified + '</li>' +
                '<li><strong>UserId</strong>: ' + userId + '</li>' +
                '</ul>';

            let subject = 'New Claim - ' + contestName + ' $' + contestPayout / 100;
            if (isTestMode) { subject = 'TEST MODE - ' + subject }

            console.log('sending claim email');
            await bmsMailgun.sendMail(to, subject, htmlBody, (err) => {
                if (err) {
                    console.error(err);
                    res.status(500).end();
                    return;
                }
            })

            res.status(204).json({}); //alamofire does not deal with empty responses well, give it something
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }
}

export const claimService = new ClaimService();