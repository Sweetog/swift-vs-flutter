import * as express from 'express';
import { bmsAuth } from '../lib/bms-auth';
import { bmsFirestore } from '../lib/bms-firestore'
import { bmsHelpers } from '../lib/bms-helpers';

class UserService {
    handleGetUser = async (req: express.Request, res: express.Response) => {
        const uid = req.query.uid;

        if (!uid) {
            res.status(400).end();
            return;
        }

        try {
            const user = await bmsHelpers.getUserDocAndAuth(uid);

            if (!user) {
                res.status(404).end();
                return;
            }

            res.status(200).json(user);
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleUsersGet = async (req: express.Request, res: express.Response) => {
        const role = req.role;
        const courseId = req.courseId;
        const pageSize = req.query.pageSize;
        const nextPageToken = req.query.nextPageToken;


        if (!pageSize) {
            res.status(400).end();
            return;
        }

        if (!courseId) {
            res.status(400).end();
            return;
        }

        if (!role) {
            res.status(400).end();
            return;
        }

        if (role !== 'courseAdmin' && role !== 'admin') {
            console.log('not authorized /users get, role: ', role);
            res.status(400).end();
            return;
        }

        try {
            let count = 0;

            const result = await bmsAuth.listUsers(+pageSize, nextPageToken);
            if (!result) {
                res.status(204).json({});
                return;
            }

            let filteredUsers: any[] = [];

             if (role === 'courseAdmin') {
                const data = await bmsFirestore.getCourse(courseId);
                //filter users for admin
                result.users.forEach(async (user) => {
                    if (user.customClaims && user.customClaims.courseId && user.customClaims.courseId == courseId) {
                        filteredUsers.push(user);
                    }
                });
                count = (data && data.userCount) ? data.userCount : 0;
            } else {
                const data = await bmsFirestore.getAdminSummaryDoc();
                filteredUsers = result.users; //big money shot admin
                count = (data && data.userCount) ? data.userCount : 0;
            }

            res.status(200).json({ users: filteredUsers, nextPageToken: result.nextPageToken, count: count });
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleCreateUser = async (req: express.Request, res: express.Response) => {
        //const userId = req.userId;
        const email = req.body.email;
        const phone = req.body.phone;
        const password = req.body.password
        const name = req.body.name;
        const role = req.body.role;
        const courseId = req.body.courseId;
        const memberNumber = req.body.memberNumber;

        if (!courseId) {
            res.status(400).end();
            return;
        }

        if (!email) {
            res.status(400).end();
            return;
        }

        if (!password) {
            res.status(400).end();
            return;
        }

        if (!role) {
            res.status(400).end();
            return;
        }

        if (!name) {
            res.status(400).end();
            return;
        }

        try {
            await bmsHelpers.createUser(email, password, name, role, courseId, phone, memberNumber);
            res.status(204).json({});
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleUserUpdate = async (req: express.Request, res: express.Response) => {
        //const userId = req.userId;
        const uid = req.body.uid;
        const email = req.body.email;
        const phone = req.body.phone;
        const name = req.body.name;
        const role = req.body.role;
        const courseId = req.body.courseId;

        if (!uid) {
            res.status(400).end();
            return;
        }

        if (!courseId) {
            res.status(400).end();
            return;
        }

        if (!email) {
            res.status(400).end();
            return;
        }


        if (!role) {
            res.status(400).end();
            return;
        }

        if (!name) {
            res.status(400).end();
            return;
        }

        try {
            await bmsAuth.updateUser(uid, email, name, role, courseId);
            await bmsFirestore.setUser(uid, courseId, phone);
            res.status(204).json({});
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleUserDelete = async (req: express.Request, res: express.Response) => {
        //const userId = req.userId;
        const id = req.body.id;

        if (!id) {
            res.status(400).end();
            return;
        }

        try {
            await bmsFirestore.deleteUser(id);
            await bmsAuth.deleteUser(id);
            console.log('delete user complete');
            res.status(204).json({});
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }
}

export const userService = new UserService;