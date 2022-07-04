import { Component, OnInit, ChangeDetectorRef } from '@angular/core';
import { AdminService } from 'app/shared/services/api/admin-service';
import { ReportService } from 'app/shared/services/api/report-service';
import { AuthService } from 'app/shared/services/auth.service';

@Component({
  selector: 'app-index',
  templateUrl: './index.component.html',
  styleUrls: ['./index.component.scss']
})
export class IndexComponent implements OnInit {

  constructor(private adminService: AdminService, private reportService: ReportService, private authService: AuthService) { }


  ngOnInit() {
    //this.getPurchaseSummary();
  }

  // private async getPurchaseSummary() {
  //   var claims = await this.authService.getClaims();
  //   var result = await this.reportService.getPurchaseSummary(claims.courseId);
  //   console.log('getPurchaseSummary complete', result);
  //   console.log('sorting');
  //   result = result.sort((a, b) => {
  //     return +(new Date(a.date)) - +(new Date(b.date));
  //   });
  //   console.log('result sorted', result);
  // }

  //admin clean up functions
  private async deleteMemberTestPurchases() {
    console.log('deleteMemberTestPurchases()')
    await this.adminService.deletePurchases('poYVLUbOYLgDF40C22q0gNCbQHg2'); //member@test.com
    console.log('deleteMemberTestPurchases() complete');
  }

  private async deleteLunchPurchases() {
    console.log('deleteLunchPurchases()')
    await this.adminService.deletePurchases('iPZi6t3cLhXRSvAH01MGnkI1XbM2'); //lunch1210@gmail.com
    console.log('deleteLunchPurchases() complete');
  }

  private async deleteDrunkLunchPurchases() {
    console.log('deleteLunchPurchases()')
    await this.adminService.deletePurchases('SMGS87a22wT4JYuyTuN5YqvDnin2'); //drunk@gmail.com
    console.log('deleteLunchPurchases() complete');
  }

  private async deleteNickMaglioPurchases() {
    console.log('deleteNickMaglioPurchases()')
    await this.adminService.deletePurchases('2Lvpbct7mpN6Gbqsy3yVAxAncn12'); //nick.magilo@gmail.com
    console.log('deleteNickMaglioPurchases() complete');
  }
}
