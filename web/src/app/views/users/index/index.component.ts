import { Component, OnInit, ChangeDetectorRef, ViewChild } from '@angular/core';
import { egretAnimations } from 'app/shared/animations/egret-animations';
import { AppLoaderService } from 'app/shared/services/app-loader/app-loader.service';
import { UsersService } from 'app/shared/services/api/users-service';
import { Page } from 'app/shared/models/page.model';
import { DatatableComponent } from '@swimlane/ngx-datatable';
import { AppConfirmService } from 'app/shared/services/app-confirm/app-confirm.service';
import { MatDialog, MatDialogRef } from '@angular/material';
import { UserPopupComponent } from './user-popup/user-popup.component';
import { AuthService } from 'app/shared/services/auth.service';
import { Role } from 'app/shared/const/role.const';

const PAGE_SIZE = 200;

@Component({
  selector: 'app-index',
  templateUrl: './index.component.html',
  animations: egretAnimations
})
export class IndexComponent implements OnInit {
  @ViewChild('ngxDatatable', { read: null, static: null }) ngxDatatable: DatatableComponent;

  page = new Page();
  rows: any[];
  isAdmin: boolean;
  isCourseAdmin: boolean;

  constructor(
    private dialog: MatDialog,
    private loader: AppLoaderService,
    private cdr: ChangeDetectorRef,
    private http: UsersService,
    private confirmService: AppConfirmService,
    private authService: AuthService
  ) {
    this.authService.getClaims().then((claims) => {
      this.isAdmin = (Role.admin === claims.role);
      this.isCourseAdmin = (Role.courseAdmin === claims.role);
    });
    this.page.size = PAGE_SIZE;
  }

  ngOnInit() {
    this.setPage({ page: 1 });
  }

  openPopUp(data: any = {}, isNew?) {
    let dialogRef: MatDialogRef<any> = this.dialog.open(UserPopupComponent, {
      width: '720px',
      disableClose: true,
      data: { isNew: isNew, payload: data, isCourseAdmin: this.isCourseAdmin }
    })
    dialogRef.afterClosed()
      .subscribe(async res => {
        if (!res) {
          // If user press cancel
          return;
        }
        this.loader.open();

        if (isNew) {
          await this.http.add(res);
        } else {
          await this.http.update(res);
        }
        this.loader.close();
        this.setPage({ page: this.page.size + 1 })
      })
  }

  async deleteItem(row) {
    let message = `Delete ${(row.displayName) ? row.displayName : row.email}?`;

    this.confirmService.confirm({ message: message })
      .subscribe(async res => {
        if (res) {
          this.loader.open();
          await this.http.delete(row.uid).then(async () => {
            this.loader.close();
            await this.setPage({ page: this.page.size })
          });
        }
      });
  }

  async setPage(pageInfo) {
    this.loader.open();
    this.page.offset = pageInfo.page - 1;
    const result = await this.http.getUsers(this.page);
    this.rows = result.data;
    this.page = result.page;
    this.cdr.detectChanges();
    this.loader.close();
  }

  comparatorText(rowA, rowB) {
    console.log('comparatorText', rowA);
    rowA = (rowA) ? rowA : '';
    rowB = (rowB) ? rowB : '';
    rowA = rowA.toLowerCase();
    rowB = rowB.toLowerCase();

    // Just a simple sort function comparisoins
    if (rowA < rowB) return -1;
    if (rowA > rowB) return 1;
  }


  comparatorDate(rowA, rowB) {
    console.log('creationDateComparator', rowA);
    let rowADate = new Date(rowA);
    let rowBDate = new Date(rowB);

    // Just a simple sort function comparisoins
    if (rowADate < rowBDate) return -1;
    if (rowADate > rowBDate) return 1;
  }

  upperCase(name) {
    if (!name) {
      return;
    }
    return name.charAt(0).toUpperCase() + name.slice(1)
  }
}
