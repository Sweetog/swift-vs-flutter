import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IndexComponent } from './index/index.component';
import { TournamentRoutes } from './tournaments.routing';
import { RouterModule } from '@angular/router';
import { SharedMaterialModule } from 'app/shared/shared-material.module';
import { FlexLayoutModule } from '@angular/flex-layout';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { TournamentPopupComponent } from './index/tournament-popup/tournament-popup.component';
import { NgxDatatableModule } from '@swimlane/ngx-datatable';
import { NgxMaterialTimepickerModule } from 'ngx-material-timepicker';

@NgModule({
  declarations: [IndexComponent, TournamentPopupComponent],
  imports: [
    CommonModule,
    FormsModule,
    SharedMaterialModule,
    FlexLayoutModule,
    ReactiveFormsModule,
    NgxDatatableModule,
    NgxMaterialTimepickerModule,
    RouterModule.forChild(TournamentRoutes)
  ],
  entryComponents: [TournamentPopupComponent]
})
export class TournamentsModule { }
