import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../../../environments/environment';
import { AuthService } from '../auth.service';

@Injectable({
    providedIn: 'root'
})
export class CheckinService {
    url = environment.apiURL;

    constructor(private http: HttpClient, private auth: AuthService) { }

    async get(id: string): Promise<any> {
        const headers = await this.createHeaders();

        try {
            var result = await this.http.get<any>(this.url + '/checkin?id=' + id, { headers: headers }).toPromise<any>();
            return result;
        }
        catch (error) {
            console.log('error state', error.status);
            if (error.status == 404) {
                return null;
            }
            console.error(error.message);
            return error.message;
        }
    }

    async post(phone: string, contestId: string): Promise<string> {
        const headers = await this.createHeaders();

        try {
            await this.http.post<any>(this.url + '/checkin', { phone: phone, contestId: contestId }, { headers: headers }).toPromise<void>();
            return 'success';
        }
        catch (error) {
            if (error.status == 429) {
                return 'toomanyrequests';
            }
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
