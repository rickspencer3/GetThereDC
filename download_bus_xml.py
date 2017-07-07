import urllib2
response = urllib2.urlopen("http://api.wmata.com/Bus.svc/Stops?lat=38.878586&lon=-76.989626&api_key=qdkez64kx75ae48mf3xdd4ta")
f = open("bus_stops.xml","w")
f.write(response.read().encode('utf-8'))
f.close
