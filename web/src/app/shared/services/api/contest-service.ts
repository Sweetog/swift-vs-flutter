import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../../../environments/environment';
import { Tournament } from '../../models/tournament.model';
import { AuthService } from '../auth.service';

@Injectable({
    providedIn: 'root'
})
export class ContestService {
    url = environment.apiURL;

    constructor(private http: HttpClient, private auth: AuthService) { }

    async getContests(courseId: string): Promise<any[]> {
        const headers = await this.createHeaders();

        try {
            let result = await this.http.get<any[]>(this.url + '/contests?courseId=' + courseId, { headers: headers }).toPromise<any[]>();
            return result;
        }
        catch (error) {
            console.error(error.message);
            return error.message;
        }
    }

    private async createHeaders() {
        var token = await this.auth.getBearerToken();

        return new HttpHeaders({
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ' + token
        });
    }
}
