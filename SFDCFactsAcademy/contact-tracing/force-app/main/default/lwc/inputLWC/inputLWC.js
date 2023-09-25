import { LightningElement } from 'lwc';

export default class InputLWC extends LightningElement {
    myvalue = 'komal';
   
   /* handleclick(event,component){
        //this.gameModeComboBox = component.find("gameMode");
        //this.value = gameModeComboBox.get("value");
       // this.value = event.target.value;
       // this.options = event.detail.options;
        window.alert("game mode is" +this.firstname+this.lastname);
       // console.log("game mode is"+this.value);
    }*/
    handlechange(event){
        
       this.myvalue = event.detail.value;
    }

    
        
    
}