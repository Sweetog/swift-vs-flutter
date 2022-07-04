import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IndexComponent } from './index/index.component';
import { RouterModule } from '@angular/router';
import { DashboardRoutes } from './dashboard.routing';
import { SharedMaterialModule } from 'app/shared/shared-material.module';
import { NgxEchartsModule } from 'ngx-echarts';
import { FlexLayoutModule } from '@angular/flex-layout';

@NgModule({
  declarations: [IndexComponent],
  imports: [
    CommonModule,
    FlexLayoutModule,
    SharedMaterialModule,
    NgxEchartsModule,
    RouterModule.forChild(DashboardRoutes)
  ]
})
export class DashboardModule { }
