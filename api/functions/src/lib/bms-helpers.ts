import * as express from 'express';
import { bmsFirestore } from './bms-firestore';
import { bmsAuth } from './bms-auth';

interface IClaims {
    role: string;
    courseId: string;
};

class BmsHelpers {
    createUser = async (email: string, password: string, name: string, role: string, courseId: string, phone?: string, memberNumber?: string) => {
        const uid = await bmsAuth.createUser(email, password, name, role, courseId);
        await bmsFirestore.setUser(uid, courseId, phone, memberNumber);
        return uid;
    }

    validE164 = (num: string) => {
        return /^\+?[1-9]\d{1,14}$/.test(num);
    }

    requestErrorLogger = (req: express.Request, message: string) => {
        const logObj = {
            stripeCustomerId: req.stripeCustomerId,
            userId: req.userId
        }

        console.error(message, logObj);
    }

    updateAccountBalance = async (userId: string, adjustmentAmount: number) => {
        const uData = await bmsFirestore.getUser(userId);

        if (!uData) {
            return null;
        }

        const newBalance = this.calculateCustomerBalance(adjustmentAmount, uData.accountBalance);
        console.log('newBalance', newBalance);
        return bmsFirestore.updateUserAccountBalance(userId, newBalance);
    }

    calculateCustomerBalance = (adjustmentAmount: number, currentBalance?: number | null) => {
        let balance = 0;
        if (currentBalance) {
            balance = currentBalance;
        }
        return balance + adjustmentAmount;
    }

    getUserDocAndAuth = async (userId: string) => {
        const auth = await bmsAuth.getUser(userId);
        const uData = await bmsFirestore.getUser(userId);

        if (!uData) {
            return null;
        }

        const user = {
            userId: userId,
            phone: uData.phone,
            courseId: '',
            email: auth.email,
            role: 'null',
            accountBalance: uData.accountBalance
        }

        if (!auth.customClaims) {
            return user;
        }

        const claims = <IClaims>auth.customClaims;
        user.role = claims.role;
        user.courseId = claims.courseId;

        return user;
    }

    // Express middleware that validates Firebase ID Tokens passed in the Authorization HTTP header.
    // The Firebase ID token needs to be passed as a Bearer token in the Authorization HTTP header like this:
    // `Authorization: Bearer <Firebase ID Token>`.
    // when decoded successfully, the ID Token content will be added as `req.user`.
    middlewareValidateToken = async (req: any, res: any, next: any) => {
        //anonymous route checks
        if (req.path === '/checkin' && req.method === 'GET') {
            return next();
        }

        if (req.path === '/confirm' && req.method === 'POST') {
            return next();
        }

        if (req.path === '/courses' && req.method === 'GET') {
            return next();
        }

        if (req.path === '/v2/user' && req.method === 'POST') {
            return next();
        }

        try {
            if ((!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) &&
                !(req.cookies && req.cookies.__session)) {
                console.error('No Firebase ID token was passed as a Bearer token in the Authorization header.',
                    'Make sure you authorize your request by providing the following HTTP header:',
                    'Authorization: Bearer <Firebase ID Token>',
                    'or by passing a "__session" cookie.');
                res.status(403).send('Unauthorized');
                return;
            }

            let idToken;
            if (req.headers.authorization && req.headers.authorization.startsWith('Bearer ')) {
                // Read the ID Token from the Authorization header.
                idToken = req.headers.authorization.split('Bearer ')[1];
            } else if (req.cookies) {
                console.log('Found "__session" cookie');
                // Read the ID Token from cookie.
                idToken = req.cookies.__session;
            } else {
                // No cookie
                res.status(403).send('Unauthorized');
                return;
            }

            const decodedIdToken = await bmsAuth.verifyToken(idToken);
            req.name = decodedIdToken.name;
            req.userId = decodedIdToken.user_id;
            req.email = decodedIdToken.email;
            req.email_verified = decodedIdToken.email_verified;
            req.role = decodedIdToken.role;
            req.courseId = decodedIdToken.courseId;
            // const userData = await bmsFirestore.getUser(decodedIdToken.user_id);
            // if (!userData) {
            //     return next();
            // }
            // req.stripeCustomerId = userData.stripeCustomerId;
            return next();
        }
        catch (err) {
            console.error('Error while verifying Firebase ID token:', err);
            res.status(403).send('Unauthorized');
        }
    }
}

export const bmsHelpers = new BmsHelpers();