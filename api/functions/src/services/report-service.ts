
import * as express from 'express';
import { bmsFirestore } from '../lib/bms-firestore';
import * as admin from 'firebase-admin';

type PurchaseSummary = { amount: number, date: any }

class ReportService {

    handlePurchaseSummary = async (req: express.Request, res: express.Response) => {
        const courseId = req.query.courseId;
        const date = req.query.date;

        if (!courseId) {
            res.status(400).end();
            return;
        }

        if (!date) {
            res.status(400).end();
            return;
        }

        try {
            const d = new Date(date);
            const purchaseDocs = await bmsFirestore.getPurchasesByCourseId(courseId, d);
            const checkinDocs = await bmsFirestore.getCheckinsByCourseId(courseId, d);

            console.log('courseSummaryPurchases purchaseDocs.length', purchaseDocs.length);
            console.log('courseSummaryPurchases checkinDocs.length', checkinDocs.length);
            const purchases = purchaseDocs.map(doc => {
                const data = doc.data();
                return <PurchaseSummary>{
                    amount: data.contest.amount,
                    date: (<admin.firestore.Timestamp>data.timestamp).toDate()
                }
            });

            const checkins = checkinDocs.map(doc => {
                const data = doc.data();
                return <PurchaseSummary>{
                    amount: data.contest.amount,
                    date: (<admin.firestore.Timestamp>data.timestamp).toDate()
                }
            });

            //must combine checkins and purchases into aggregate 
            const result = purchases.concat(checkins);
            res.status(200).json(result);
        } catch (err) {
            console.log(err);
            res.status(500).end();
        }
    }
}

export const reportService = new ReportService();