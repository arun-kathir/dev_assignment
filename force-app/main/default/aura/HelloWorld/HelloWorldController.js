({
	onClick : function(component, event, helper) {
		var msg1 = component.get("v.msg");
        //alert(msg1);
        if(msg1==="default message"){
            component.set("v.msg","Changed in JS Controller");
        }
        else{
            component.set("v.msg","default message");
        }
        helper.myAlert("Alert from helper JS");
	},
	onClick1 : function(component, event, helper) {
		helper.myAlert("Alert from helper JS for onClick1");
	}
})