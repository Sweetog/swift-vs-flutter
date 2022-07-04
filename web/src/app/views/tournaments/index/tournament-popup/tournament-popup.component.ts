import { Component, OnInit, Inject } from '@angular/core';
import { FormGroup, Validators, FormBuilder, FormArray } from '@angular/forms';
import { CustomValidators } from 'ng2-validation';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { ValidatorParticipantLimitHio } from 'app/shared/validators/participant-limit-hio.validator';

const MONTHS_ADVANCE = 1;

@Component({
  selector: 'app-tournament-popup',
  templateUrl: './tournament-popup.component.html',
  styleUrls: ['./tournament-popup.component.scss'],
})
export class TournamentPopupComponent implements OnInit {

  form: FormGroup;
  minDate = new Date();
  maxDate = new Date().setMonth(this.minDate.getMonth() + MONTHS_ADVANCE);
  totalCost: number;
  costPerPlayer: number;

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<TournamentPopupComponent>,
    private fb: FormBuilder
  ) { }

  ngOnInit() {
    console.log('data', this.data);

    // this.form = this.fb.group({
    //   providers: this.fb.array([]),
    // });

    this.form = this.fb.group({
      id: [this.data.payload.id] || '',
      name: [this.data.payload.name || '', Validators.required],
      participants: [this.data.payload.participants || '', [Validators.required, CustomValidators.range([25, 350])]],
      date: [this.data.payload.date || '', [Validators.required, CustomValidators.date, CustomValidators.minDate(this.minDate), CustomValidators.maxDate(this.maxDate)]],
      time: [this.data.payload.time || '', Validators.required],
      contest: [this.data.payload.contest || '', Validators.required]
    }, { validators: [ValidatorParticipantLimitHio] });


    this.form.valueChanges.subscribe(val => {

      if (val.contest && val.participants) {
        this.totalCost = (val.contest.price / 100) * val.participants;
        this.costPerPlayer = val.contest.price / 100
      }
    });
  }

  submit() {
    var val = this.form.value;
    val.contest.type = 'hio'; //only hio available right now
    this.dialogRef.close(this.form.value)
  }

}
