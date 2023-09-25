import { LightningElement ,track} from 'lwc';

export default class PracticeLWC extends LightningElement {
     @track names = [];
     connectedCallback(){
       // this.showdefaultvalue();
     }
    handleClick(){
        const inBox = this.template.querySelector("lightning-input");
        const name={
            id:this.names.length,
            name:inBox.value,
            done:false
        }
        this.names.push(name);
        inBox.value="";
        //const inputBox = 
    }

    showdefaultvalue(){
        const names=[
            {
                id:1,
                name:"komal",
            },
            {
                id:2,
                name:"sayali",
            }
        ]
        this.names=names;
    }

    get selected(){
        return this.names && this.names.length ? this.names.filter( name => !name.done) : [];
    }
    get Notselected(){
        return this.names && this.names.length ? this.names.filter( name => name.done) : [];
    }
}