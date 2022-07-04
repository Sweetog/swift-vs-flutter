import { AbstractControl } from '@angular/forms';

export function ValidatorPhone(control: AbstractControl) {

    var val = control.value.replace(/\D/g, '');
    if (!val) {
        return null;
    }

    var regex = /^(1\s?)?((\([0-9]{3}\))|[0-9]{3})[\s\-]?[\0-9]{3}[\s\-]?[0-9]{4}$/;

    if (!regex.test(val)) {
        return { phone: true };
    }

    return null;
}
