import * as Mailgun from 'mailgun-js';
import * as functions from 'firebase-functions';

//************Mailgun*********** */
const mailgun = Mailgun({ apiKey: functions.config().mailgun.key, domain: functions.config().mailgun.domain });

class BmsMailgun {
    sendMail = async (to: string, subject: string, htmlBody: string, callback: (err: any) => void): Promise<any> => {
        const data = {
            from: 'Info <info@bigmoneyshot.com>',
            to: to,
            subject: subject,
            html: htmlBody
        };

        await mailgun.messages().send(data, function (err: any, body: any) {
            callback(err);
        });
    }
}

export const bmsMailgun = new BmsMailgun();