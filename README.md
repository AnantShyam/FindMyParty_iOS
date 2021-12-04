# FindMyParty_iOS


ViewControllers:

1. partyinfoviewController

All nearby parties are displayed on the map-view with a party icon. If the user clicks on these custom markers, a new view controller is pushed (partyinfoviewcontroller), which displays more detailed information about the party. 
On the partyinfoviewcontroller, the user is able to rsvp to the selected party.

2. addPartyViewController

The '+' button pushes the "addPartyViewController". On this view-controller, the user is able to add their party by selecting a date/time, location, a photo, and adding a party theme. 

3. profileViewController

The 😃 button pushes the "profileViewController". On this view-controller, the user is able to view their profile (name, profile picture, rsvped parties).  

4. PartyTableViewController

Lastly, the 🎉 button ("party icon") pushes the "PartyTableViewController". On this view-controller, the user can see all of the nearby parties arranged in a tableview.
On this tableview, users are able to directly get map directions to the party, and if a cell in the table view is clicked, once again the partyinfoviewcontroller is pushed.


Alamofire Request:

We used an AlamoFire request to get all of the parties when a party was added in the "addPartyViewController" to properly display them. 


Frontend Team Members: Neil Gidwani, Anant Shyam
