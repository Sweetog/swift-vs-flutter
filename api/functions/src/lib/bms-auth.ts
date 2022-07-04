
import * as admin from 'firebase-admin';

class BmsAuth {
    getUserByEmail = async (email: string) => {
        try {
            return await admin.auth().getUserByEmail(email);
        }
        catch (error) {
            return null;
        }
    }

    getUser = async (userId: string) => {
        return admin.auth().getUser(userId);
    }

    verifyToken = async (token: string) => {
        return admin.auth().verifyIdToken(token);
    }

    listUsers = async (pageSize: number, nextPageToken?: any) => {
        const users: any[] = [];
        const result = await admin.auth().listUsers(pageSize, nextPageToken);
        result.users.forEach((user) => {
            users.push(user.toJSON());
        });
        return { users: users, nextPageToken: result.pageToken };
    }

    deleteUser = async (uid: string) => {
        return admin.auth().deleteUser(uid);
    }

    createUser = async (email: string, password: string, name: string, role: string, courseId: string) => {
        const userData = {
            email: email,
            emailVerified: false,
            password: password,
            displayName: name,
            disabled: false
        }
        const result = await admin.auth().createUser(userData);

        const claims = {
            role: role,
            courseId: courseId
        }

        await admin.auth().setCustomUserClaims(result.uid, claims);
        return result.uid;
    }

    updateUser = async (uid: string, email: string, name: string, role: string, courseId: string) => {
        const userData = {
            email: email,
            displayName: name,
        }

        await admin.auth().updateUser(uid, userData);

        const claims = {
            role: role,
            courseId: courseId
        }

        return admin.auth().setCustomUserClaims(uid, claims);
    }
}

export const bmsAuth = new BmsAuth();