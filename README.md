# Currency



## Goal

The goal was to create an application, which shows currency values, using API provided by NBP:
http://api.nbp.pl


## Functions

The application displays currency values in UITableView.
The cells contain:
    - name of the currency,
    - code of the currency,
    - average exchange rate,
    - date, when the data was received.

User can select table and reload the data.
The activity indicator is displayed when the app is waiting for the response from the server. 

Tapping desired cell displays detail view, which presents values for selected period of time.
The time interval can be adjusted, but its maximum range is equal to 365 days.
Data can be reloaded, using the reload button.
The activity indicator is displayed, when the app is waiting for the response from the server.


## Pods

Following pods were used:
    - Alamofire - used for networking
    - SwiftyJSON - used for dealing with the .json response from the server


## Testing activity indicator

Because the data is received from the server almost instantly, it is hard to notice the activity indicator.
One way of testing is to adjust following setting of the device the app is installed on:
Settings -> Developer -> Network Link Conditioner -> Choose 'Edge' -> Set 'Enable' to ON position

>Attribution: Logo used in app icon made by Freepik: www.flaticon.com
