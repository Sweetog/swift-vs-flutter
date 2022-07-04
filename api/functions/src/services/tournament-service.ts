import * as express from 'express';
import { bmsFirestore } from '../lib/bms-firestore';


type Tournament = { id: string, name: string, participants: number, date: any, contest: any, time: string, timestamp: any };

class TournamentService {
    handleTournamentsGet = async (req: express.Request, res: express.Response) => {
        const courseId = req.courseId;

        //validation
        if (!courseId) {
            res.status(400).end();
            return;
        }

        try {
            const docs = await bmsFirestore.getTournaments(courseId);
            if (!docs) {
                res.status(204).end({});
                return
            }

            const tournaments = docs.map(doc => {
                const data = doc.data();
                return <Tournament>{
                    id: doc.id,
                    userId: data.userId,
                    name: data.name,
                    participants: data.participants,
                    date: data.date,
                    contest: data.contest,
                    time: data.time,
                    timestamp: data.timestamp
                }
            });

            res.status(200).json(tournaments);
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleTournamentPut = async (req: express.Request, res: express.Response) => {
        const userId = req.userId;
        const id = req.body.id;
        const name = req.body.name;
        const participants = req.body.participants;
        const date = req.body.date;
        const contest = req.body.contest;
        const time = req.body.time;

        //validation
        if (!userId) {
            res.status(400).end();
            return;
        }

        if (!id) {
            res.status(400).end();
            return;
        }

        if (!name) {
            res.status(400).end();
            return;
        }

        if (!participants) {
            res.status(400).end();
            return;
        }

        if (!date) {
            res.status(400).end();
            return;
        }

        if (!contest) {
            res.status(400).end();
            return;
        }

        if (!time) {
            res.status(400).end();
            return;
        }

        try {
            await bmsFirestore.updateTournament(userId, id, name, participants, date, contest, time);
            res.status(204).json({}); //iOS App Library alamofire does not deal with empty responses well, give it something
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleTournamentPost = async (req: express.Request, res: express.Response) => {
        const courseId = req.courseId;
        const userId = req.userId;
        const name = req.body.name;
        const participants = req.body.participants;
        const date = req.body.date;
        const contest = req.body.contest;
        const time = req.body.time;

        //validation
        if (!courseId) {
            res.status(400).end();
            return;
        }

        if (!userId) {
            res.status(400).end();
            return;
        }

        if (!name) {
            res.status(400).end();
            return;
        }

        if (!participants) {
            res.status(400).end();
            return;
        }

        if (!date) {
            res.status(400).end();
            return;
        }

        if (!contest) {
            res.status(400).end();
            return;
        }

        if (!time) {
            res.status(400).end();
            return;
        }

        try {
            await bmsFirestore.addTournament(courseId, userId, name, participants, date, contest, time);
            res.status(204).json({}); //iOS App Library alamofire does not deal with empty responses well, give it something
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleTournamentDelete = async (req: express.Request, res: express.Response) => {
        console.log('handleTournamentDelete', req.body);
        const id = req.body.id;

        if (!id) {
            res.status(400).end();
            return;
        }

        try {
            await bmsFirestore.deleteTournament(id);
            res.status(204).json({});
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }
}

export const tournamentService = new TournamentService();