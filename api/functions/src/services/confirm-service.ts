import * as express from 'express';
import { bmsAuth } from '../lib/bms-auth';
import { bmsFirestore } from '../lib/bms-firestore';
import { bmsHelpers } from '../lib/bms-helpers';
import * as admin from 'firebase-admin';

class ConfirmService {
    handleConfirm = async (req: express.Request, res: express.Response) => {
        const checkinId = req.body.checkinId
        const firstName = req.body.firstName;
        const lastName = req.body.lastName;
        const email = req.body.email;

        if (!checkinId) {
            res.status(400).end();
            return;
        }

        if (!firstName) {
            res.status(400).end();
            return;
        }

        if (!lastName) {
            res.status(400).end();
            return;
        }

        if (!email) {
            res.status(400).end();
            return;
        }


        try {
            const checkInData = await bmsFirestore.getCheckin(checkinId);
            const user = await bmsAuth.getUserByEmail(email);

            if (!checkInData) {
                res.status(404).end();
                return;
            }

            //already confirmed!
            if (checkInData.userId) {
                res.status(429).end();
                return;
            }

            admin.firestore().runTransaction(async t => {
                let uid: string;
                const displayName = firstName + ' ' + lastName;
                if (user) {
                    //create user, give default password
                    uid = user.uid;
                    const userData = {
                        email: email,
                        displayName: displayName,
                        phone: checkInData.phone //not really sure phone available unless used as signup method...
                    }
                    await admin.auth().updateUser(uid, userData);
                    await admin.firestore().collection('users').doc(uid).update({ phone: checkInData.phone, })
                } else {
                    uid = await bmsHelpers.createUser(email, '123456', displayName, 'player', checkInData.courseId, checkInData.phone);
                }

                await admin.firestore().collection('checkins').doc(checkinId).update(
                    {
                        userId: uid,
                        confirmTimestamp: admin.firestore.Timestamp.now(),
                        displayName: displayName
                    });

                //create purchase record
                await bmsFirestore.addPurchaseStripe(uid, checkInData.contest);
            }).then(result => {
                res.status(204).json({});
            }).catch(err => {
                console.error('Confirm Transaction failure: checkinId: ' + checkinId, err);
                res.status(500).end();
            });
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }
}

export const confirmService = new ConfirmService();