import * as express from 'express';
import { bmsFirestore } from '../lib/bms-firestore';

type Contest = { id: string, name: string, amount: number, payout: number, payoutLabel: string, startDate: any, endDate: any, courseId: String, contests: any };

class ContestService {
    handleGetContests = async (req: express.Request, res: express.Response) => {
        if (!req.query.courseId) {
            res.status(400).end();
            return;
        }

        try {
            const docs = await bmsFirestore.getContests(req.query.courseId);
            if (!docs) {
                console.error('/contests get handleGetContests no contests', req.query.id);
                res.status(404).end();
                return
            }

            const contests = docs.map(doc => {
                const data = doc.data();
                return <Contest>{
                    id: doc.id,
                    name: data.name,
                    amount: data.amount,
                    payout: data.payout,
                    payoutLabel: data.payoutLabel,
                    startDate: data.startDate,
                    endDate: data.endDate,
                    courseId: data.courseId,
                    contests: data.contests
                }
            });

            res.status(200).json(contests);
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }
}

export const contestService = new ContestService();