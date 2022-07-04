import * as Stripe from 'stripe';
import * as functions from 'firebase-functions';

class BmsStripe {

    //****************STRIP IN TEST MODE****************** */
    stripeTest = new Stripe(functions.config().stripe.secretkeytest);
    webhooksSecretTest = functions.config().stripe.webhookstest;

    //****************STRIP IN PRODUCTION MODE****************** */
    stripeLive = new Stripe(functions.config().stripe.secretkey);
    webhooksSecretLive = functions.config().stripe.webhooks;

    getCustomerStripe = async (stripeCustomerId: string, stripe: Stripe) => {
        const customer = await stripe.customers.retrieve(stripeCustomerId);
        return customer;
    }

    updateBalanceStripe = async (stripeCustomerId: string, accountBalance: number, stripe: Stripe) => {
        console.debug('updateBalanceStripe for stripeCustomerId', stripeCustomerId);
        console.debug('balance to update:', accountBalance);
        await stripe.customers.update(stripeCustomerId, { 'account_balance': accountBalance });
    }
}

export const bmsStripe = new BmsStripe();