import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';

// SERVICES
import { ThemeService } from './services/theme.service';
import { NavigationService } from "./services/navigation.service";
import { RoutePartsService } from './services/route-parts.service';
import { AuthGuard } from './services/auth/auth.guard';
import { AppConfirmService } from './services/app-confirm/app-confirm.service';
import { AppLoaderService } from './services/app-loader/app-loader.service';
import { AuthService } from "./services/auth.service";

import { SharedComponentsModule } from './components/shared-components.module';
import { SharedPipesModule } from './pipes/shared-pipes.module';
import { SharedDirectivesModule } from './directives/shared-directives.module';
import { AngularFireAuth } from '@angular/fire/auth';
import { LandingGuard } from './services/auth/landing.guard';
import { CheckinService } from './services/api/checkin-service';
import { ConfirmService } from './services/api/confirm-service';
import { TournmentService } from './services/api/tournament-service';
import { UsersService } from './services/api/users-service';
import { CourseService } from './services/api/course-service';
import { AdminService } from './services/api/admin-service';
import { ReportService } from './services/api/report-service';

@NgModule({
  imports: [
    CommonModule,
    SharedComponentsModule,
    SharedPipesModule,
    SharedDirectivesModule,
    HttpClientModule
  ],
  providers: [
    AngularFireAuth,
    ThemeService,
    NavigationService,
    RoutePartsService,
    AuthGuard,
    LandingGuard,
    AppConfirmService,
    AppLoaderService,
    AuthService,
    CheckinService,
    ConfirmService,
    TournmentService,
    UsersService,
    CourseService,
    AdminService,
    ReportService
  ],
  exports: [
    SharedComponentsModule,
    SharedPipesModule,
    SharedDirectivesModule
  ]
})
export class SharedModule { }
