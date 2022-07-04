
import * as express from 'express';
import { bmsMailgun } from '../lib/bms-mailgun';
import { bmsAuth } from '../lib/bms-auth';
import { bmsFirestore } from '../lib/bms-firestore'

class AdminService {

    handleContactUs = async (req: express.Request, res: express.Response, to: string) => {
        const userId = req.userId;
        const message = req.body.message;
        const email = req.body.email;

        //validation
        if (!email) {
            res.status(400).end();
            return;
        }

        if (!message) {
            res.status(400).end();
            return;
        }

        try {

            console.log('AdminService.contactUs sending email');
            const htmlBody = '<ul>' +
                '<li><strong>Email</strong>: ' + email + '</li>' +
                '<li><strong>UserId</strong>: ' + userId + '</li>' +
                '<li><strong>Message</strong>: ' + message + '</li>' +
                '</ul>';

            const subject = 'Contact Us Message';

            await bmsMailgun.sendMail(to, subject, htmlBody, (err) => {
                console.log('mailGun sendMail complete');
                if (err) {
                    console.error(err);
                    res.status(500).end();
                    return;
                }
            })

            console.log('AdminService.contactUs success');

            res.status(204).json({}); //alamofire does not deal with empty responses well, give it something
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    //admin call once clean up functions

    handleDeletePurchases = async (req: express.Request, res: express.Response) => {
        const userIdToDelete = req.body.userIdToDelete;

        if (!userIdToDelete) {
            res.status(400).end();
            return;
        }

        try {
            const result = await bmsFirestore.getPurchases(userIdToDelete);

            console.log('result.length', result.length);
            for (let i = 0; i < result.length; i++) {
                const d = result[i];
                console.log('delete purchaseId: ', d.id);
                await bmsFirestore.deletePurchase(d.id);
            }

            res.status(204).json({});
        } catch (err) {
            console.log(err);
            res.status(500).end();
        }
    }

    handleUpdateRoleAndCourse = async (req: express.Request, res: express.Response) => {

        try {
            const result = await bmsAuth.listUsers(1000);
            if (!result) {
                return;
            }

            for (let i = 0; i < result.users.length; i++) {
                const u = result.users[i];
                await bmsAuth.updateUser(u.uid, u.email, u.name, 'player', 'ILXBlsKJW8Cdqk27MTq5');
                await bmsFirestore.setUser(u.uid, 'ILXBlsKJW8Cdqk27MTq5');
            }
            res.status(204).end({});
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }
}

export const adminService = new AdminService();