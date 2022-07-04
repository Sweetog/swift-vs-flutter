//import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';


class BmsFirestore {

    incrementCheckInCounts = async (courseId: string, increment: number) => {
        //increment course count
        const courseRef = admin.firestore().collection('courses').doc(courseId);
        const inc = admin.firestore.FieldValue.increment(increment);
        await courseRef.update({ checkinCount: inc });

        //increment total user count
        const userCountRef = admin.firestore().collection('admin').doc('summary');
        await userCountRef.update({ checkinCount: inc });
    }

    incrementPurchaseCounts = async (courseId: string, increment: number) => {
        //increment course count
        const courseRef = admin.firestore().collection('courses').doc(courseId);
        const inc = admin.firestore.FieldValue.increment(increment);
        await courseRef.update({ purchaseCount: inc });

        //increment total user count
        const userCountRef = admin.firestore().collection('admin').doc('summary');
        await userCountRef.update({ purchaseCount: inc });
    }

    incrementUserCounts = async (courseId: string, increment: number) => {
        //increment course count
        const courseRef = admin.firestore().collection('courses').doc(courseId);
        const inc = admin.firestore.FieldValue.increment(increment);
        await courseRef.update({ userCount: inc });

        //increment total user count
        const userCountRef = admin.firestore().collection('admin').doc('summary');
        await userCountRef.update({ userCount: inc });
    }

    getAdminSummaryDoc = async () => {
        const snapShot = await admin.firestore().collection('admin').doc('summary').get();
        return snapShot.data();
    }

    getCheckin = async (checkinId: string) => {
        const snapShot = await admin.firestore().collection('checkins').doc(checkinId).get();
        return snapShot.data();
    }

    getCheckinsByCourseId = async (courseId: string, date: Date) => {
        const dateT = admin.firestore.Timestamp.fromDate(date);
        const snapShot = await admin.firestore().collection('checkins')
            .where('courseId', '==', courseId)
            .where('timestamp', '>=', dateT).get();
        return snapShot.docs;
    }

    getContest = async (contestId: string) => {
        const snapShot = await admin.firestore().collection('contests').doc(contestId).get();
        return snapShot.data();
    }

    getContests = async (courseId: string) => {
        const today = admin.firestore.Timestamp.now();
        const snapShot = await admin.firestore().collection('contests')
            .where('courseId', '==', courseId)
            .where('endDate', '>', today).get();
        return snapShot.docs;
    }

    getCourse = async (courseId: string) => {
        const snapShot = await admin.firestore().collection('courses').doc(courseId).get();
        return snapShot.data();
    }

    getCourses = async () => {
        const snapShot = await admin.firestore().collection('courses').get();
        return snapShot.docs;
    }

    getPurchase = async (purchaseId: string) => {
        const snapShot = await admin.firestore().collection('purchases').doc(purchaseId).get();
        return snapShot.data();
    }

    getPurchases = async (userId: string) => {
        const snapShot = await admin.firestore().collection('purchases')
            .where('userId', '==', userId)
            .orderBy('timestamp', 'desc').get();
        return snapShot.docs;
    }

    getPurchasesByCourseId = async (courseId: string, date: Date) => {
        const dateT = admin.firestore.Timestamp.fromDate(date);
        const snapShot = await admin.firestore().collection('purchases')
            .where('contest.courseId', '==', courseId)
            .where('timestamp', '>=', dateT).get();
        return snapShot.docs;
    }

    deletePurchase = async (purchaseId: string) => {
        return admin.firestore().collection('purchases').doc(purchaseId).delete();
    }

    getUser = async (userId: string) => {
        const userSnapShot = await admin.firestore().collection('users').doc(userId).get();
        return userSnapShot.data();
    }

    setUserV1 = async (userId: string, stripeCustomerId: string, isAge18Verified: boolean) => {
        const vals = {
            'stripeCustomerId': stripeCustomerId,
            'isAge18Verified': isAge18Verified
        }
        return admin.firestore().collection('users').doc(userId).set(vals);
    }

    setUser = async (userId: string, courseId: string, phone?: string, memberNumber?: string) => {
        const vals = {
            'courseIds': [courseId],
            'lastCourseId': courseId,
            'phone': (phone) ? phone : null,
            'memberNumber': (memberNumber) ? memberNumber : null
        }
        return admin.firestore().collection('users').doc(userId).set(vals);
    }

    deleteUser = async (id: string) => {
        return admin.firestore().collection('users').doc(id).delete();
    }

    addClaim = async (userId: string, purchase: FirebaseFirestore.DocumentData, time: string, phone: string, contestName: string | null, contestPayout: number | null, email: string | null, name: string | null) => {
        const vals = {
            purchase: purchase,
            time: time,
            phone: phone,
            name: name,
            email: email,
            userId: userId,
            contestName: contestName,
            contestPayout: contestPayout,
            timestamp: admin.firestore.Timestamp.now()
        }
        return admin.firestore().collection('claims').add(vals);
    }


    updateUserAccountBalance = async (userId: string, accountBalance: number) => {
        const vals = {
            'accountBalance': accountBalance
        }
        return admin.firestore().collection('users').doc(userId).update(vals);
    }

    updatePurchase = async (id: string, claimId: string) => {

        const vals = {
            claimId: claimId
        }

        return admin.firestore().collection('purchases').doc(id).update(vals);
    }

    addPurchase = async (userId: string, contest: FirebaseFirestore.DocumentData, memberNumber: String, isCredit?: boolean | false) => {

        const course = await this.getCourse(contest.courseId);

        const vals = {
            userId: userId,
            contest: contest,
            course: course,
            memberNumber: memberNumber,
            isCredit: isCredit,
            timestamp: admin.firestore.Timestamp.now()
        }
        console.log('writing purchase', vals);
        return admin.firestore().collection('purchases').add(vals);
    }

    addPurchaseStripe = async (userId: string, contest: FirebaseFirestore.DocumentData) => {

        const course = await this.getCourse(contest.courseId);

        const vals = {
            userId: userId,
            contest: contest,
            course: course,
            timestamp: admin.firestore.Timestamp.now()
        }

        return admin.firestore().collection('purchases').add(vals);
    }

    getTournaments = async (courseId: string) => {
        const snapShot = await admin.firestore().collection('tournaments')
            .where('courseId', '==', courseId).get();
        return snapShot.docs;
    }

    addTournament = async (courseId: string, userId: string, name: string, participants: number, date: Date, contest: any, time: string) => {

        const vals = {
            courseId: courseId,
            userId: userId,
            name: name,
            participants: participants,
            date: date,
            contest: contest,
            time: time,
            timestamp: admin.firestore.Timestamp.now()
        }

        return admin.firestore().collection('tournaments').add(vals);
    }

    updateTournament = async (userId: string, id: string, name: string, participants: number, date: Date, contest: any, time: string) => {

        const vals = {
            userId: userId,
            name: name,
            participants: participants,
            date: date,
            contest: contest,
            time: time,
            timestamp: admin.firestore.Timestamp.now()
        }

        return admin.firestore().collection('tournaments').doc(id).update(vals);
    }

    deleteTournament = async (id: string) => {
        return admin.firestore().collection('tournaments').doc(id).delete();
    }
}

export const bmsFirestore = new BmsFirestore();