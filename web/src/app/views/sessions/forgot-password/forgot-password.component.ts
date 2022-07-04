import { Component, OnInit, ViewChild } from '@angular/core';
import { MatProgressBar, MatButton, MatSnackBar } from '@angular/material';
import { AuthService } from 'app/shared/services/auth.service';


@Component({
  selector: 'app-forgot-password',
  templateUrl: './forgot-password.component.html',
  styleUrls: ['./forgot-password.component.css']
})
export class ForgotPasswordComponent implements OnInit {
  userEmail;
  @ViewChild(MatProgressBar, { static: false }) progressBar: MatProgressBar;
  @ViewChild(MatButton, { static: false }) submitButton: MatButton;
  constructor(private snackBar: MatSnackBar, private authService: AuthService) { }

  ngOnInit() {
  }

  async submitEmail() {
    this.submitButton.disabled = true;
    this.progressBar.mode = 'indeterminate';
    let result = await this.authService.forgotPassword(this.userEmail);
    this.snackBar.open(result, '', {
      duration: 3000,
    });
    this.submitButton.disabled = false;
    this.progressBar.mode = 'determinate';
  }
}
