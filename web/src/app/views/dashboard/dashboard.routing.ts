import { Routes } from '@angular/router';
import { IndexComponent } from './index/index.component';


export const DashboardRoutes: Routes = [
    {
        path: '',
        component: IndexComponent,
        // children: [{
        //   path: 'dashboard',
        //   component: IndexComponent,
        //   data: { title: 'Dashboard', breadcrumb: 'DASHBOARD' }
        //}]
    }
];