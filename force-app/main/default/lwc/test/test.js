import { LightningElement ,track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllAccount from '@salesforce/apex/CallOut_http.getAllAccount';
import getAllOpportunity from '@salesforce/apex/CallOut_http.getAllOpportunity';
import getAllLead from '@salesforce/apex/CallOut_http.getAllLead';
import postAccount from '@salesforce/apex/CallOut_http.postAccount';
import checkPermissions from '@salesforce/apex/CallOut_http.checkPermissions';

//Import Account e fields
import ACCOUNT_OBJECT from '@salesforce/schema/Account';
import ACC_NAME_FIELD from '@salesforce/schema/Account.Name';
import ACC_PHONE_FIELD from '@salesforce/schema/Account.Phone';
import ACC_DESCRIPTION from '@salesforce/schema/Account.Description';

//Url per le callout
const url1 = 'callout:Named_CredentialCallout/AccountService';
const url2 = 'callout:EmaOrgServerNamed/AccountService';
const url3 = 'callout:GaggioOrgServerNamed/AccountService';

//Colonne per la dataTable
const columnsAcc = [
    { label: 'Name', fieldName: 'Name'},
    { label: 'Phone', fieldName: 'Phone', type: 'phone'},
    { label: 'Type', fieldName: 'Type', type: 'type'},
    { label: 'OwnerId', fieldName: 'OwnerId', type: 'id'},
];
const columnsOpp = [
    { label: 'Name', fieldName: 'Name' ,type: 'String'},
    { label: 'stageName', fieldName: 'StageName', type: 'String'},
    { label: 'CloseDate', fieldName: 'CloseDate', type: 'date'},
    { label: 'Amount', fieldName :'Amount', type: 'currency'},
    { label: 'OwnerId', fieldName: 'OwnerId', type: 'id' },
];
const columnsLead = [
    { label: 'Name', fieldName: 'Name' ,type: 'String'},
    { label: 'Company', fieldName: 'Company', type: 'String'},
    { label: 'Status', fieldName: 'Status', type: 'String'},
];


export default class CallOut extends LightningElement {

    //Ricorda l'org attiva
    url;

    //Servono per il form di creazione account
    objectApiName = ACCOUNT_OBJECT;
    fields = [ACC_NAME_FIELD, ACC_PHONE_FIELD, ACC_DESCRIPTION];
    isNewAccOpen = false;

    //DataTable singola
    title;
    showDataTable = false;
    myList = [];
    columns = [];

    showOrg1Methods = false;
    showOrg2Methods = false;
    showOrg3Methods = false;

    //Sceglie i metodi da mostrare in base al numero della org
    async chooseOrgMethods(choice){
        switch(choice){
            case 1 :
                this.showOrg1Methods = await checkPermissions({url : url1});
                this.showOrg2Methods = false;
                this.showOrg3Methods = false;
                break;
            case 2:
                this.showOrg1Methods = false;
                this.showOrg2Methods = await checkPermissions({url : url2});
                this.showOrg3Methods = false;
                break;
            case 3:
                this.showOrg1Methods = false;
                this.showOrg2Methods = false;
                this.showOrg3Methods = await checkPermissions({url : url3});
                break;
        }
    }

    //Stampa un toast con l'esito dell'operazione di login
    showToastPermission(bool,name){
        if(!bool){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'You dont have enough permission to access the server',
                    variant : 'error',
                }),
            );
        }
        else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Access granted. You are in ' + name,
                    variant : 'success',
                }),
            );
        }
    }

    //Stampa un toast con l'esito dell'operazione di submit
    async postAccount(url, event){
        if(await postAccount({url : url , account : JSON.stringify(event.detail.fields)})){
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Record created succesfully',
                    variant : 'success',
                }),
            );
        }else{
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Record not created ',
                    variant : 'error',
                }),
            );
        }
    }

    async checkPermissionOrg(event){
        this.showDataTable = false;
        switch (event.detail.name){
            case 'org1':
                await this.chooseOrgMethods(1);
                this.showToastPermission(this.showOrg1Methods,'Org 1');
                this.url = url1;
                if(this.showOrg1Methods){
                    await this.handleAccountButton();
                }
                break;
            case 'org2':
                await this.chooseOrgMethods(2);
                this.showToastPermission(this.showOrg2Methods,'Org 2');
                this.url = url2;
                if(this.showOrg2Methods){
                    await this.handleAccountButton();
                }
                break;
            case 'org3':
                await this.chooseOrgMethods(3);
                this.showToastPermission(this.showOrg3Methods,'Org 3');
                this.url = url3;
                if(this.showOrg3Methods){
                    await this.handleAccountButton();
                }
                break;
        }
        this.showDataTable = true;
    }

    //Gestisce l'inserimento di un account
    async handleSubmitAccount(event) {
        event.preventDefault();
        await this.postAccount(this.url,event);
    }    

    async handleAccountButton() {
       
        this.title = 'Account';
        this.columns = columnsAcc;
        this.myList = await getAllAccount({url : this.url});
        this.showDataTable = true;
                
    }

    async handleOppButton() {
        
        this.title = 'Opportunity'
        this.columns = columnsOpp;
        this.myList = await getAllOpportunity({url : this.url});
        this.showDataTable = true;

    }

    async handleLeadButton() {
        
        this.title = 'Lead';
        this.columns = columnsLead;
        this.myList = await getAllLead({url : this.url});
        this.showDataTable = true;
                
    }

}