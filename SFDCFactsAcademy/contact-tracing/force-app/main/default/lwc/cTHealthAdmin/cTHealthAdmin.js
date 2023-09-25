import { LightningElement ,api} from 'lwc';

export default class CTHealthAdmin extends LightningElement {

   @api headermsg = '';
    @api handleActive(event){
        const tabName = event.target.name;
        if(tabName == PersonView){
           this.headermsg = "Person View";
        }
        if(tabName == LocationView){
            this.headermsg = "Location View";
        }
    }
}