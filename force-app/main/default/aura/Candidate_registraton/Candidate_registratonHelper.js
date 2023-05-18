({
	clickCheckBoxHelper : function(cmp) {
		console.log("Working");
        var checkBoxValue = cmp.find("checkBox").get("v.checked");
        cmp.set("v.checkBoxValue", checkBoxValue);
	}
})