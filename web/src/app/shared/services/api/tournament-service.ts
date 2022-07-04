import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../../../environments/environment';
import { Tournament } from '../../models/tournament.model';
import { AuthService } from '../auth.service';

@Injectable({
    providedIn: 'root'
})
export class TournmentService {
    url = environment.apiURL;

    constructor(private http: HttpClient, private auth: AuthService) { }

    async getTournaments(): Promise<Tournament[]> {
        const headers = await this.createHeaders();

        try {
            let result = await this.http.get<Tournament[]>(this.url + '/tournaments', { headers: headers }).toPromise<Tournament[]>();
            return result;
        }
        catch (error) {
            console.error(error.message);
            return error.message;
        }
    }

    async update(tournament: Tournament): Promise<string> {
        const headers = await this.createHeaders();

        try {
            await this.http.put<Tournament>(this.url + '/tournament', tournament, { headers: headers }).toPromise<Tournament>();
            return 'success';
        }
        catch (error) {
            console.error(error.message);
            return error.message;
        }
    }

    async delete(id: string): Promise<string> {
        const headers = await this.createHeaders();
        const options = {
            headers: headers,
            body: {
                id: id,
            },
        };

        try {
            await this.http.delete<any>(this.url + '/tournament', options).toPromise<void>();
            return 'success';
        }
        catch (error) {
            console.error(error.message);
            return error.message;
        }
    }

    async add(tournament: Tournament): Promise<string> {
        const headers = await this.createHeaders();

        try {
            await this.http.post<Tournament>(this.url + '/tournament', tournament, { headers: headers }).toPromise<Tournament>();
            return 'success';
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
