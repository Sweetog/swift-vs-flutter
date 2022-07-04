import * as express from 'express';
import * as admin from 'firebase-admin';
import { bmsFirestore } from '../lib/bms-firestore';
import { bmsHelpers } from '../lib/bms-helpers';
import { bmsTwilio } from '../lib/bms-twilio';


class CheckinService {
    handleCheckinGet = async (req: express.Request, res: express.Response) => {
        const id = req.query.id;

        if (!id) {
            res.status(400).end();
            return;
        }

        try {
            const data = await bmsFirestore.getCheckin(id);

            if (!data) { //checkinId does not exist
                res.status(404).end();
                return;
            }

            res.status(200).json(data);
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleCheckin = async (req: express.Request, res: express.Response) => {
        const phone = req.body.phone;
        const contestId = req.body.contestId
        const courseId = req.courseId;

        if (!phone) {
            res.status(400).end();
            return;
        }


        if (!contestId) {
            res.status(400).end();
            return;
        }

        if (!courseId) {
            res.status(400).end();
            return;
        }

        if (!bmsHelpers.validE164(phone)) {
            res.status(400).end();
            return;
        }

        try {
            const recentPast = new Date();
            recentPast.setMinutes(recentPast.getMinutes() - 15);

            const existingCheckin = await admin.firestore().collection('checkins')
                .where('courseId', '==', courseId)
                .where('phone', '==', phone)
                .where('sms', '==', true)
                .where('timestamp', '>', admin.firestore.Timestamp.fromDate(recentPast)).get();

            if (!existingCheckin.empty) {
                res.status(429).end();
                return;
            }

            const contest = await bmsFirestore.getContest(contestId);

            const ref = await admin.firestore().collection('checkins').add({
                contest: contest,
                courseId: courseId,
                phone: phone,
                sms: false,
                timestamp: admin.firestore.Timestamp.now()
            });

            const body = 'Please confirm your Big Money Shot contest entry: https://app.bigmoneyshot.com/confirm/' + ref.id;

            const smsResult = await bmsTwilio.sendText(body, phone);
            if (!smsResult.errorCode) {
                await ref.update({ sms: true });
            } else {
                console.error('twilio error, code: ' + smsResult.errorCode, smsResult.errorMessage)
            }
            res.status(204).json({});
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

}

export const checkinService = new CheckinService();