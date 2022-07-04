import { Component, OnInit, Inject, ViewChild } from '@angular/core';
import { FormGroup, FormBuilder, Validators, FormControl } from '@angular/forms';
import { MAT_DIALOG_DATA, MatDialogRef, MatProgressBar } from '@angular/material';
import { ValidatorPhone } from 'app/shared/validators/phone.validator';
import { CourseService } from 'app/shared/services/api/course-service';
import { CustomValidators } from 'ng2-validation';
import { Mask } from 'app/shared/const/mask.const';
import { Role } from 'app/shared/const/role.const';
import { UsersService } from 'app/shared/services/api/users-service';

export interface Select {
  value: string;
  viewValue: string;
}

@Component({
  selector: 'app-user-popup',
  templateUrl: './user-popup.component.html'
})
export class UserPopupComponent implements OnInit {
  @ViewChild(MatProgressBar, { static: false }) progressBar: MatProgressBar;

  form: FormGroup;
  courses: any[];
  phoneMask = Mask.phone;

  roles: Select[] = [
    { value: Role.courseAdmin, viewValue: 'Course Admin' },
    { value: Role.courseUser, viewValue: 'Course User' },
    { value: Role.player, viewValue: 'Player' },
    { value: Role.admin, viewValue: 'Big Money Shot Admin' }
  ];

  constructor(
    @Inject(MAT_DIALOG_DATA) public data: any,
    public dialogRef: MatDialogRef<UserPopupComponent>,
    private fb: FormBuilder,
    private httpCourse: CourseService,
    private http: UsersService,
  ) { }

  ngOnInit() {
    if (this.data.isCourseAdmin) {
      this.roles = [
        { value: Role.courseAdmin, viewValue: 'Course Admin' },
        { value: Role.courseUser, viewValue: 'Course User' }
      ];
    }

    this.getData().then(() => {
      this.progressBar.mode = "determinate";
    });
  }

  async getData(): Promise<void> {
    const promise = new Promise<void>(async (resolve, reject) => {
      this.courses = await this.httpCourse.getCourses();

      if (!this.data.isNew) {
        var userDoc = await this.http.get(this.data.payload.uid);
      }

      this.handleDataLoadComplete(userDoc);
      resolve();
    });

    return promise;
  }

  handleDataLoadComplete(user?: any) {
    var role;
    var courseId;
    var phone;


    var passwordValidators = [];

    if (this.data.isNew) {
      passwordValidators.push(Validators.required);
    } else {
      if (this.data.payload.customClaims) {
        role = this.data.payload.customClaims.role;
        courseId = this.data.payload.customClaims.courseId;
      }

      if (user) {
        phone = user.phone;
      }

    }

    const password = new FormControl('', passwordValidators);
    const confirmPassword = new FormControl('', CustomValidators.equalTo(password));

    this.form = this.fb.group({
      uid: [this.data.payload.uid] || '',
      name: [this.data.payload.displayName || '', Validators.required],
      email: [this.data.payload.email || '', [Validators.required, Validators.email]],
      phone: [phone || '', [ValidatorPhone]],
      role: [role || '', Validators.required],
      courseId: [courseId || '', Validators.required],
      password: password,
      confirmPassword: confirmPassword
    });
  }

  submit() {
    this.dialogRef.close(this.form.value)
  }

}
