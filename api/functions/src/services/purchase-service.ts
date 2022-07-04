import * as express from 'express';
import { bmsFirestore } from '../lib/bms-firestore';
import { bmsHelpers } from '../lib/bms-helpers';

type Purchase = { id: string, userId: string, claimId: string, contest: any, course: any, timestamp: any };

class PurchaseService {
    handlePurchasesGet = async (req: express.Request, res: express.Response) => {
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
                    userId: data.userId,
                    claimId: data.claimId,
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

    handlePurchase = async (req: express.Request, res: express.Response) => {
        const userId = req.userId;
        const memberNumber = req.body.memberNumber;
        const courseId = req.body.courseId;
        const contestId = req.body.contestId;

        //validation
        if (!userId) {
            res.status(400).end();
            return;
        }

        if (!memberNumber) {
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
            const contest = await bmsFirestore.getContest(contestId);

            if (!contest) {
                bmsHelpers.requestErrorLogger(req, 'contestId not found: ' + contestId);
                res.status(400).end();
                return;
            }

            const uData = await bmsFirestore.getUser(userId);
            let isCredit = false;

            if (!uData) {
                res.status(500).end();
                return;
            }

            console.log('purchaseService -> uData.accountBalance', uData.accountBalance);
            console.log('purchaseService -> contest.amount', contest.amount);

            if (-1 * uData.accountBalance >= contest.amount) {
                //deduct balance
                console.log('contest purchase on credit');
                await bmsHelpers.updateAccountBalance(userId, contest.amount);
                isCredit = true;
            }

            await bmsFirestore.addPurchase(userId, contest, memberNumber, isCredit);
            res.status(204).json({}); //iOS App Library alamofire does not deal with empty responses well, give it something
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }
}

export const purchaseService = new PurchaseService();