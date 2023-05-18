public class popup
{    
    public boolean displayPopup {get; set;}    
   
    public pageReference closePopup()
    {   
        pageReference pr = new pageReference('/home/home.jsp');
        pr.setRedirect(true);
        displayPopup = false;
        return pr;
    }    
    public void showPopup()
    {       
        displayPopup = true;   
    }   
}