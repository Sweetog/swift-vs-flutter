import * as twilio from 'twilio';
import * as functions from 'firebase-functions';

//************Twilio*********** */
const accountSid = functions.config().twilio.sid;
const authToken = functions.config().twilio.token;
const twClient = twilio(accountSid, authToken);
const twilioNumber = '+18582950187';

class BmsTwilio {

    sendText = async (body: string, toPhone: string) => {
        const text = {
            body: body,
            to: toPhone,
            from: twilioNumber
        }
        return twClient.messages.create(text);
    }
}

export const bmsTwilio = new BmsTwilio();