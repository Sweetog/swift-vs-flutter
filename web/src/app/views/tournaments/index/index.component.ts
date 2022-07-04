import { Component, OnInit, ViewChild, ChangeDetectorRef } from '@angular/core';
import { MatDialogRef, MatDialog, MatSnackBar } from '@angular/material';
import { AppLoaderService } from 'app/shared/services/app-loader/app-loader.service';
import { TournamentPopupComponent } from './tournament-popup/tournament-popup.component';
import { egretAnimations } from "../../../shared/animations/egret-animations";
import { Tournament } from 'app/shared/models/tournament.model';
import { DatatableComponent } from '@swimlane/ngx-datatable';
import { setHours } from 'date-fns';
import { AppConfirmService } from 'app/shared/services/app-confirm/app-confirm.service';
import { TournmentService as TournamentService } from 'app/shared/services/api/tournament-service';
import { CourseService } from 'app/shared/services/api/course-service';
import { AuthService } from 'app/shared/services/auth.service';

@Component({
  selector: 'app-index',
  templateUrl: './index.component.html',
  animations: egretAnimations
})
export class IndexComponent implements OnInit {

  items: any[];
  course: any;

  constructor(
    private dialog: MatDialog,
    private snackBar: MatSnackBar,
    private loader: AppLoaderService,
    private http: TournamentService,
    private cdr: ChangeDetectorRef,
    private confirmService: AppConfirmService,
    private httpCourse: CourseService,
    private authService: AuthService
  ) { }

  ngOnInit() {
    this.loader.open();
    this.getData().then(() => {
      this.loader.close();
    });
  }

  openPopUp(data: any = {}, isNew?) {
    data.course = this.course;
    let dialogRef: MatDialogRef<any> = this.dialog.open(TournamentPopupComponent, {
      width: '720px',
      disableClose: true,
      data: { isNew: isNew, payload: data }
    })
    dialogRef.afterClosed()
      .subscribe(async res => {
        if (!res) {
          // If user press cancel
          return;
        }
        this.loader.open();

        var tournament = new Tournament();
        tournament.id = res['id'];
        tournament.date = res['date'];
        tournament.name = res['name'];
        tournament.participants = res['participants'];
        tournament.contest = res['contest'];
        tournament.time = res['time'];

        console.log('tournament to post:', tournament);

        var result;

        if (isNew) {
          result = await this.http.add(tournament);
        } else {
          result = await this.http.update(tournament);
        }
        this.handleAjaxCompletion(result, isNew);

      })
  }

  isRowActive(row) {
    var today = new Date();
    var d = new Date(row.date);
    var result = d > today;
    return result;
  }

  async deleteItem(row) {
    var snackBarDuration = 5000;
    var cancelReason = null;

    var today = new Date();
    var tournamentDate = new Date(row.date);
    var tomorrow = new Date();
    tomorrow.setHours(tomorrow.getHours() + 24);


    if (tournamentDate < tomorrow) {
      cancelReason = 'tomorrow';
    }

    if (tournamentDate < today) {
      cancelReason = 'in the past';
    }

    if (tournamentDate == today) {
      cancelReason = 'today';
    }

    if (cancelReason) {
      this.snackBar.open('This Tournament is ' + cancelReason + ' and can no longer be cancelled/deleted, please contact us.', 'Ok', {
        duration: snackBarDuration
      });
      return;
    }

    console.log('valid to delete');
    this.confirmService.confirm({ message: `Delete ${row.name}?` })
      .subscribe(res => {
        if (res) {
          this.loader.open();

          this.http.delete(row.id).then(async () => {
            await this.getData();
            this.loader.close();
          });
        }
      });
  }


  private async handleAjaxCompletion(res: string, isNew: boolean) {
    var duration = 5000;
    await this.getData();
    this.loader.close();

    if (res == 'success') {
      this.snackBar.open('Tournament ' + ((isNew) ? 'Added' : 'Updated'), '', {
        duration: duration,
      });
    } else {
      this.snackBar.open(res, null, { duration: duration });
    }
  }

  private async getData() {
    var claims = await this.authService.getClaims();
    this.items = await this.http.getTournaments();
    this.course = await this.httpCourse.get(claims.courseId);
    this.cdr.detectChanges();
  }
}
