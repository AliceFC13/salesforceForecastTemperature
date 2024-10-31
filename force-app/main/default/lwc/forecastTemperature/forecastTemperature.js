import getWeather from '@salesforce/apex/WeatherService.getWeather';
import LOCATION_FIELD from '@salesforce/schema/Account.Location__c';
import { getRecord } from 'lightning/uiRecordApi';
import { LightningElement, api, track, wire } from 'lwc';

const FIELDS = [LOCATION_FIELD];

export default class ForecastTemperature extends LightningElement {
    @track maxTemperatureData;
    @track minTemperatureData;
    @track error;
    @api recordId; // ID-ul contului curent

    // Obține locația din cont
    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    account({ error, data }) {
        if (data) {
            const location = data.fields.Location__c.value;
            if (location) {
                console.log('Location found:', location);
                this.fetchWeather(location);
            }
        } else if (error) {
            this.error = error;
            console.error('Error fetching account data:', this.error);
        }
    }

    // Funcția de apel la metoda Apex pentru a obține vremea
    fetchWeather(location) {
        const [latitude, longitude] = location.split(','); // Desparte latitudinea și longitudinea
        getWeather({ latitude: parseFloat(latitude), longitude: parseFloat(longitude) })
            .then(result => {
                const dailyData = result.daily;
                if (dailyData && dailyData.temperature_2m_max && dailyData.temperature_2m_min) {
                    this.maxTemperatureData = dailyData.temperature_2m_max[1]; 
                    console.log('Max Temperature data:', this.maxTemperatureData);
                    this.minTemperatureData = dailyData.temperature_2m_min[1]; 
                    console.log('Min Temperature data:', this.minTemperatureData);
                } 
                else {
                    console.error('Temperature data not found in response:', result);
                }
            })
            .catch(error => {
                this.error = error.body ? error.body.message : error;
                console.error('Error fetching weather:', this.error);
            });
    }
}

