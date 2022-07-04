import { Component, OnInit } from '@angular/core';
import { ActivatedRoute, Params, Router } from '@angular/router';
import { AppLoaderService } from 'app/shared/services/app-loader/app-loader.service';
import { CheckinService } from 'app/shared/services/api/checkin-service';

@Component({
  selector: 'app-complete',
  templateUrl: './complete.component.html'
})
export class CompleteComponent implements OnInit {

  id: string;
  contest: any;
  displayName: string;

  constructor(
    private route: ActivatedRoute,
    private loader: AppLoaderService,
    private httpCheckin: CheckinService,
    private router: Router
  ) { }

  ngOnInit() {
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
    this.contest = result.contest;
    this.displayName = result.displayName;
  }
}
