import { Component, OnInit, ViewChild } from '@angular/core';
import { MatProgressBar, MatButton, MatSnackBar } from '@angular/material';
import { Validators, FormGroup, FormControl } from '@angular/forms';
import { AuthService } from 'app/shared/services/auth.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-signin',
  templateUrl: './signin.component.html',
  styleUrls: ['./signin.component.css']
})
export class SigninComponent implements OnInit {
  @ViewChild(MatProgressBar, { static: false }) progressBar: MatProgressBar;
  @ViewChild(MatButton, { static: false }) submitButton: MatButton;

  signinForm: FormGroup;

  constructor(private authService: AuthService, private snackBar: MatSnackBar, private router: Router) { }

  ngOnInit() {
    this.signinForm = new FormGroup({
      username: new FormControl('', [Validators.required, Validators.email]),
      password: new FormControl('', Validators.required),
      rememberMe: new FormControl(false)
    })
  }

  async signin() {
    this.submitButton.disabled = true;
    this.progressBar.mode = 'indeterminate';

    const signinData = this.signinForm.value;
    console.log(signinData);
    console.log('rememberMe value', signinData['rememberMe']);
    console.log('rememberMe type', typeof (signinData['rememberMe']));
    const result = await this.authService.signIn(signinData['username'], signinData['password'], signinData['rememberMe']);

    if (result == 'success') {
      this.router.navigate(['/dashboard']);
      return;
    }

    this.snackBar.open('Error', result, {
      duration: 3000,
    });

    this.submitButton.disabled = false;
    this.progressBar.mode = 'determinate';
  }

}
