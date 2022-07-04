import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { environment } from '../../../../environments/environment';
import { Tournament } from '../../models/tournament.model';
import { AuthService } from '../auth.service';
import { User } from 'app/shared/models/user.model';
import { PagedData } from 'app/shared/models/paged-data.model';
import { Page } from 'app/shared/models/page.model';

@Injectable({
    providedIn: 'root'
})
export class AdminService {
    url = environment.apiURL;

    constructor(private http: HttpClient, private auth: AuthService) { }

    async deletePurchases(userIdToDelete: string): Promise<any> {
        const headers = await this.createHeaders();

        try {
            let result = await this.http.post<any>(this.url + '/deletePurchases', { userIdToDelete: userIdToDelete }, { headers: headers }).toPromise<any>();
            return result;
        }
        catch (error) {
            console.error(error.message);
            return error.message;
        }
    }


    private async createHeaders() {
        var token = await this.auth.getBearerToken();

        console.log('token', token);
        return new HttpHeaders({
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + token
        });
    }
}
