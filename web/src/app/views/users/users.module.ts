import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IndexComponent } from './index/index.component';
import { RouterModule } from '@angular/router';
import { UsersRoutes } from './users.routing';
import { FlexLayoutModule } from '@angular/flex-layout';
import { ReactiveFormsModule } from '@angular/forms';
import { SharedMaterialModule } from 'app/shared/shared-material.module';
import { NgxDatatableModule } from '@swimlane/ngx-datatable';
import { UserPopupComponent } from './index/user-popup/user-popup.component';
import { TextMaskModule } from 'angular2-text-mask';

@NgModule({
  declarations: [IndexComponent, UserPopupComponent],
  imports: [
    CommonModule,
    SharedMaterialModule,
    FlexLayoutModule,
    ReactiveFormsModule,
    NgxDatatableModule,
    TextMaskModule,
    RouterModule.forChild(UsersRoutes)
  ],
  entryComponents: [UserPopupComponent]
})
export class UsersModule { }
