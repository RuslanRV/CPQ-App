public class MyController {
    
    public String name;
    
    public MyController(){
    	this.name = 'constructor name';    
    }

    public String getName() {        
//        return 'method name';
return this.name;
    }

    public Account getAccount() {
        return [select id, name from Account where id = '0010Y000004tvB9']; 
    } 
}