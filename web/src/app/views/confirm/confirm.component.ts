import { Component, OnInit, ViewChild } from '@angular/core';
import { ActivatedRoute, Params, Router } from '@angular/router';
import { FormGroup, Validators, FormBuilder, FormControl } from '@angular/forms';
import { MatSnackBar, MatProgressBar, MatButton } from '@angular/material';
import { ConfirmService } from 'app/shared/services/api/confirm-service';
import { CheckinService } from 'app/shared/services/api/checkin-service';
import { AppLoaderService } from 'app/shared/services/app-loader/app-loader.service';

@Component({
  selector: 'app-confirm',
  templateUrl: './confirm.component.html',
})
export class ConfirmComponent implements OnInit {
  @ViewChild(MatProgressBar, { static: false }) progressBar: MatProgressBar;
  @ViewChild(MatButton, { static: false }) submitButton: MatButton;

  id: string;
  form: FormGroup;
  contest: any;
  userName: string;

  constructor(
    private route: ActivatedRoute,
    private snackBar: MatSnackBar,
    private http: ConfirmService,
    private httpCheckin: CheckinService,
    private router: Router,
    private loader: AppLoaderService,
  ) { }

  ngOnInit() {
    this.form = new FormGroup({
      firstname: new FormControl('', [Validators.required]),
      lastname: new FormControl('', [Validators.required]),
      email: new FormControl('', [Validators.required, Validators.email]),
      agreed: new FormControl('', (control: FormControl) => {
        const agreed = control.value;
        if (!agreed) {
          return { agreed: true }
        }
        return null;
      }),
      ageAm: new FormControl('', (control: FormControl) => {
        const ageAm = control.value;
        if (!ageAm) {
          return { ageAm: true }
        }
        return null;
      })
    })

    this.route.params
      .subscribe((params: Params) => {
        // Get ID
        this.id = params['id'];
        this.fetchCheckin(this.id);
      });
  }

  async fetchCheckin(id: string) {
    this.loader.open();
    var result = await this.httpCheckin.get(id);
    this.loader.close();
    if (!result) {
      this.router.navigate(['session']);
      return;
    }
    console.log('checkIn', result);
    if (result.userId) {
      console.log('routing, userId exists')
      this.router.navigate(['confirm', 'complete', id]);
    }
    this.contest = result.contest;
    this.userName = result.displayName;
  }

  async submit() {
    this.progressBar.mode = 'indeterminate';
    this.submitButton.disabled = true;
    var data = this.form.value;

    var result = await this.http.confirm(this.id, data['firstname'], data['lastname'], data['email'])

    var message;
    var panelClass;

    if (result == 'success') {
      this.router.navigate(['confirm', 'complete', this.id]);
      return;
    }

    if (!message) {
      message = 'Error, please try again: ' + result;
      panelClass = 'snack-error';
    }

    this.snackBar.open(message, '', {
      duration: 5000,
      panelClass: [panelClass]
    });

    this.submitButton.disabled = false;
    this.progressBar.mode = 'determinate';
  }

}
