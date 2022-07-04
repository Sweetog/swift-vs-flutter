import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { IndexComponent } from './index/index.component';
import { RouterModule } from '@angular/router';
import { SandboxRoutes } from './sandbox.routing';
import { NgxDatatableModule } from '@swimlane/ngx-datatable';

@NgModule({
  declarations: [IndexComponent],
  imports: [
    CommonModule,
    NgxDatatableModule,
    RouterModule.forChild(SandboxRoutes)
  ]
})
export class SandboxModule { }
