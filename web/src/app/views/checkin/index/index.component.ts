import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { ValidatorPhone } from 'app/shared/validators/phone.validator';
import { CheckinService } from 'app/shared/services/api/checkin-service';
import { MatSnackBar } from '@angular/material';
import { AppLoaderService } from 'app/shared/services/app-loader/app-loader.service';
import { Mask } from 'app/shared/const/mask.const';
import { ContestService } from 'app/shared/services/api/contest-service';
import { AuthService } from 'app/shared/services/auth.service';

@Component({
  selector: 'app-index',
  templateUrl: './index.component.html',
})
export class IndexComponent implements OnInit {

  form: FormGroup;
  phoneMask = Mask.phone;
  contests: any[];

  constructor(
    private fb: FormBuilder,
    private http: CheckinService,
    private snackBar: MatSnackBar,
    private loader: AppLoaderService,
    private httpContest: ContestService,
    private authService: AuthService
  ) { }

  ngOnInit() {
    this.form = this.fb.group({
      phone: ['', [Validators.required, ValidatorPhone]],
      contests: ['', Validators.required]
    });

    this.getContests();
  }

  private async getContests() {
    this.loader.open();
    this.authService.getClaims().then((claims) => {
      this.httpContest.getContests(claims.courseId).then((res) => {
        this.loader.close();
        this.contests = res;
      });
    });
  }

  async submit() {
    this.loader.open();
    var p = this.form.controls['phone'].value.replace(/\D/g, '');
    var c = this.form.controls['contests'].value;
    var result = await this.http.post(p, c);
    this.loader.close();

    var message;
    var panelClass;

    if (result == 'success') {
      message = 'Success: Confirmation Text Message Sent to Player';
    }

    if (result == 'toomanyrequests') {
      message = 'Player already confirmed for today, please do not check in again';
      panelClass = 'snack-error';
    }

    if (!message) {
      message = 'Error, please try again: ' + result;
      panelClass = 'snack-error';
    }

    this.snackBar.open(message, '', {
      duration: 5000,
      panelClass: [panelClass]
    });
  }

}
