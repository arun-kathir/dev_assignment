({
	doSubmit : function(cmp, evnt, hlpr) {
        //Read value of attribute
		var studName = cmp.get("v.NameofStudent");
        if(studName !== null){
        	alert("Name of Student is " + studName);
        }
        else{
            alert("Please provide some name");
            //set value of attribute
            cmp.set("v.NameofStudent", "Default Name");
        }
	},
	clickCheckBox : function(cmp, evnt, hlpr) {
        console.log("From controller");
        //call function defined in helper
		hlpr.clickCheckBoxHelper(cmp);
	}
})