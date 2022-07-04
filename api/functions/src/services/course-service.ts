import * as express from 'express';
import { bmsFirestore } from '../lib/bms-firestore';

type Course = { id: string, imageUrl: string, handicap: number, hole: number, name: string, par: number, logoUrl: String, teeBoxLabel: String, tournaments?: any };

class CourseService {
    handleGetCourses = async (req: express.Request, res: express.Response) => {

        try {
            const docs = await bmsFirestore.getCourses();

            if (!docs) {
                res.status(204).json({});
                return
            }

            const courses = docs.map(doc => {
                const data = doc.data();
                return <Course>{
                    id: doc.id,
                    imageUrl: data.imageUrl,
                    handicap: data.handicap,
                    hole: data.hole,
                    name: data.name,
                    par: data.par,
                    logoUrl: data.logoUrl,
                    teeBoxLabel: data.teeBoxLabel
                }
            });

            res.status(200).json(courses);
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }

    handleGetCourse = async (req: express.Request, res: express.Response) => {
        //validation
        if (!req.query.id) {
            res.status(400).end();
            return;
        }

        try {
            const data = await bmsFirestore.getCourse(req.query.id);

            if (!data) {
                console.error('/course get handleGetCourse no course with that id', req.query.id);
                res.status(404).end();
                return
            }

            const course = <Course>{
                id: req.query.id,
                imageUrl: data.imageUrl,
                handicap: data.handicap,
                hole: data.hole,
                name: data.name,
                par: data.par,
                logoUrl: data.logoUrl,
                teeBoxLabel: data.teeBoxLabel,
                purchaseCount: data.purchaseCount,
                userCount: data.userCount,
                checkinCount: data.checkinCount,
                tournaments: data.tournaments
            }

            res.status(200).json(course);
        } catch (err) {
            console.error(err);
            res.status(500).end();
        }
    }
}

export const courseService = new CourseService();