import { FormGroup } from "@angular/forms";


export function ValidatorParticipantLimitHio(form: FormGroup): { [key: string]: boolean } {
    const contestControl = form.controls['contest'];
    const participantsControl = form.controls['participants'];

    if (contestControl && participantsControl) {
        const contest = contestControl.value;
        const participants = participantsControl.value;

        if (!participants || !contest) {
            return;
        }

        if (participants < 50 && contest.payout > 1000000) {
            return { invalidParticipants: true };
        }

        return null;
    }
}
