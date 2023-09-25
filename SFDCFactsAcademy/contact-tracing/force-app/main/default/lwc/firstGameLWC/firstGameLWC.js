import { LightningElement , track} from 'lwc';

export default class FirstGameLWC extends LightningElement {
     value = '';

    get options() {
        return [
            { label: 'Easy', value: 'Easy' },
            { label: 'Medium', value: 'Medium' },
            { label: 'Hard', value: 'Hard' },
        ];
    }
    handleclick(event,component){
        //this.gameModeComboBox = component.find("gameMode");
        //this.value = gameModeComboBox.get("value");
       // this.value = event.target.value;
       // this.options = event.detail.options;
        window.alert("game mode is" +this.value);
        console.log("game mode is"+this.value);
    }
    

   handleChange(event) {
        this.value = event.detail.value;
}
}