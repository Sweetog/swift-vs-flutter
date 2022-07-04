import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IndexComponent } from './index/index.component';
import { RouterModule } from '@angular/router';
import { CheckinRoutes } from './checkin.routing';
import { SharedMaterialModule } from 'app/shared/shared-material.module';
import { FlexLayoutModule } from '@angular/flex-layout';
import { ReactiveFormsModule } from '@angular/forms';
import { TextMaskModule } from 'angular2-text-mask';

@NgModule({
  declarations: [IndexComponent],
  imports: [
    CommonModule,
    SharedMaterialModule,
    FlexLayoutModule,
    ReactiveFormsModule,
    TextMaskModule,
    RouterModule.forChild(CheckinRoutes)
  ]
})
export class CheckinModule { }
