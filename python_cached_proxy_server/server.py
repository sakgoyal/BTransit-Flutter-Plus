import threading
import time

import requests
import xmltodict
from flask import Flask

app = Flask(__name__)


cache = {"data": "Initial data"} # Initialize the cache with an initial value
ALL_ROUTE_IDS = ["CRB", "CRC", "HDG", "HWA", "HWB", "HWD", "HXP", "MSA", "MSG", "MS", "PHB", "PHD", "PRO", "TOM", "TTT", "UCB"] # All route IDs
BT_API_STATUS = True # is the backend API up or down?

# Function to periodically update the cache with new data
def update_cache():
    while True:
        response = requests.get("http://www.bt4uclassic.org/webservices/bt4u_webservice.asmx/GetCurrentBusInfo")
        if response.status_code != 200:
            print("Failed to fetch data from the backend. Status code:", response.status_code)
            continue
        try:
            cache["data"] = xmltodict.parse(response.text)
            BT_API_STATUS = True
            print("Cache updated with new XML data.")
        except Exception as e:
            BT_API_STATUS = False
            print(f"Failed to parse XML data: {e}")
            
        time.sleep(5) # Update every 5 seconds to avoid hitting the API too frequently


update_thread = threading.Thread(target=update_cache)
update_thread.daemon = True # Start the cache update thread as a daemon
update_thread.start()


# @app.route("/get_data", defaults={"force": False})
@app.route("/get_data/")
def get_data():
    # if force:
    #     # Force a cache update
    #     update_cache()
    return cache["data"]["DocumentElement"]["LatestInfoTable"]


@app.route("/status") # 1 means up, 0 means down
def status():
    return {"status": 1 if BT_API_STATUS else 0}


@app.route("/health")
def health():
    return {"status": "OK"}

# @app.route("/alerts_active/<type>/<cause>/<effect>")
# def alerts(type, cause, effect):
#     return "Alerts" # http://www.bt4uclassic.org/webservices/bt4u_webservice.asmx/GetActiveAlerts

# @app.route("/alerts_all")
# def alerts_all():
#     return "Alerts" # http://www.bt4uclassic.org/webservices/bt4u_webservice.asmx/GetAllAlerts

# @app.route("/alert_causes")
# def alert_causes():
#     return "Alert Causes" # http://www.bt4uclassic.org/webservices/bt4u_webservice.asmx/GetAlertCauses

# @app.route("/alert_types")
# def alert_types():
#     return "Alert Types" # http://www.bt4uclassic.org/webservices/bt4u_webservice.asmx/GetAlertTypes

# @app.route("/alert_effects")
# def alert_effects():
#     return "Alert Effects" # http://www.bt4uclassic.org/webservices/bt4u_webservice.asmx/GetAlertEffects

# @app.route("/all_places")
# @app.route("/GetArrivalAndDepartureTimesForRoutes")
# @app.route("/GetArrivalAndDepartureTimesForTrip")
# @app.route("/GetCurrentBusInfo")
# @app.route("/GetCurrentRoutes")
# @app.route("/GetNearestStops")
# @app.route("/GetNextDepartures")
# @app.route("/GetNextDeparturesForStop")
# @app.route("/GetPatternNamesForDate")
# @app.route("/GetPatternPointsForPatternID")
# @app.route("/GetPlaceTypes")
# @app.route("/GetPlaces")
# @app.route("/GetScheduledPatternPoints")
# @app.route("/GetScheduledRoutes")
# @app.route("/GetScheduledStopCodes")
# @app.route("/GetScheduledStopInfo")
# @app.route("/GetScheduledStopNames")
# @app.route("/GetSummary")


@app.route("/GetBusSchedulePDF/<routeID>")
def GetBusSchedulePDF(routeID):
    if routeID not in ALL_ROUTE_IDS:
        return {"link": "Invalid route ID"}
    return {"link": f"https://ridebt.org/images/Schedules/{routeID}.pdf"}


@app.route("/")
def index():
    # return a list of links to the endpoints
    return """
<ul>
		<li><a href="/AddAlert">AddAlert</a></li>
		<li><a href="/AddPlace">AddPlace</a></li>
		<li><a href="/CheckForKnownPlace">CheckForKnownPlace</a></li>
		<li><a href="/DeleteAlert">DeleteAlert</a></li>
		<li><a href="/DeletePlace">DeletePlace</a></li>
		<li><a href="/GetActiveAlerts">GetActiveAlerts</a></li>
		<li><a href="/GetAlertCauses">GetAlertCauses</a></li>
		<li><a href="/GetAlertEffects">GetAlertEffects</a></li>
		<li><a href="/GetAlertTypes">GetAlertTypes</a></li>
		<li><a href="/GetAllAlerts">GetAllAlerts</a></li>
		<li><a href="/GetAllPlaces">GetAllPlaces</a></li>
		<li><a href="/GetArrivalAndDepartureTimesForRoutes">GetArrivalAndDepartureTimesForRoutes</a></li>
		<li><a href="/GetArrivalAndDepartureTimesForTrip">GetArrivalAndDepartureTimesForTrip</a></li>
		<li><a href="/GetCurrentBusInfo">GetCurrentBusInfo</a></li>
		<li><a href="/GetCurrentRoutes">GetCurrentRoutes</a></li>
		<li><a href="/GetNearestStops">GetNearestStops</a></li>
		<li><a href="/GetNextDepartures">GetNextDepartures</a></li>
		<li><a href="/GetNextDeparturesForStop">GetNextDeparturesForStop</a></li>
		<li><a href="/GetPatternNamesForDate">GetPatternNamesForDate</a></li>
		<li><a href="/GetPatternPointsForPatternID">GetPatternPointsForPatternID</a></li>
		<li><a href="/GetPlaceTypes">GetPlaceTypes</a></li>
		<li><a href="/GetPlaces">GetPlaces</a></li>
		<li><a href="/GetScheduledPatternPoints">GetScheduledPatternPoints</a></li>
		<li><a href="/GetScheduledRoutes">GetScheduledRoutes</a></li>
		<li><a href="/GetScheduledStopCodes">GetScheduledStopCodes</a></li>
		<li><a href="/GetScheduledStopInfo">GetScheduledStopInfo</a></li>
		<li><a href="/GetScheduledStopNames">GetScheduledStopNames</a></li>
		<li><a href="/GetSummary">GetSummary</a></li>
		<li><a href="/ModifyAlert">ModifyAlert</a></li>
		<li><a href="/ModifyPlace">ModifyPlace</a></li>
	</ul>
"""




if __name__ == "__main__":
    app.run(debug=True)
