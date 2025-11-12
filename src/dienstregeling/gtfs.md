# GTFS en GTFS-RT
GTFS is een [dienstregeling standaard](https://gtfs.org/) dat een grote internationale aanhang heeft.
Stichting OpenGeo is ook bij dit standaardisatie proces jaren betrokken en was de eerste partij die zowel geplande als dynamische data op een geintegreerde manier nationaal kon aanbieden.
Deze data is te zien op Google Maps, Apple Maps en vele andere kanalen.

### Geschiedenis
Stichting OpenGeo publiceert twee verschillende smaken GTFS bestanden, veel keuzes die zijn gemaakt hebben tal van historische en functionele redenen.
Er zijn ook andere partijen zoals R-OV die voor een toepassing als [OpenTripPlanner](https://opentripplanner.org) een aangepaste GTFS maakt waardoor deze toepassing beter werkt.

Onze twee maken vielen historisch uiteen in:
 1. [openov-nl](https://gtfs.openov.nl/) een dataset die primair gericht was op Google Transit, want Google wilde op landsgrenzen splitsen.
 2. [OVapi](https://gtfs.ovapi.nl/nl/) waarin alle naburige data uit Duitsland en België die middels Bliksem Integration ingeladen kon worden werd geëxporteerd.

### Eigenaardigheden
Omdat GTFS (op dit moment) nog geen scheiding maakt tussen een vervoerder en een merk, wordt deze scheiding aangebracht door het introduceren van een nieuwe GTFS-agency.
Je zult zien dat Bravo, Breng, RRReis, U-OV, etc. allemaal een losse GTFS-agencies zijn, terwijl ze door "vervoerders" worden uitgevoerd die ook onder een andere naam als GTFS-agency te vinden zijn.
In de categorie "tagging-voor-de-reisplanner" (naar: OpenStreetMap's Tagging voor de Renderer) wordt in Nederland voor Sprinters, Intercities, etc. de GTFS route_short_name gebruikt om deze vervoerssoort aan te geven.

Ook voor dynamische data is er rond 2012 een bijzondere situatie ontstaan.
Vanwege een andere (al dan niet historische) beperking in Google Transit, het niet dynamisch kunnen toevoegen van nieuwe ritten met een ander ritpatroon, is de keuze gemaakt om een los staande trainUpdates.pb feeds te maken.
Reisplanners zoals OpenTripPlanner en rrrr konden daarmee wel echte dynamische NS informatie gebruiken, maar Google Transit negeert (alleen) ritannuleringen in deze feed.

Beide GTFS bestanden maken het, tevens om historische redenen, mogelijk om in plaats van GTFS-RT, KV6 te koppelen.
Het is niet ondersteund, wordt actief afgeraden, maar een blijvend grote wens van leden binnen ons openOV ecosysteem.
Dat heeft een aantal consequenties hoe de GTFS data wordt gecommuniceerd.
 1. Om KV6 te koppelen moeten Dataownercode, LinePlanningNumber en JourneyNumber beschikbaar zijn op rit niveau, middels het veld realtime_trip_id, gesplitst op :
 2. Tevens moest de UserStopCode, een logisch attribuut uit het domein van de vervoerder, op stop niveau worden ontsloten. Dat gaf direct de consequentie dat dezelfde halte, van verschillende vervoerders, meerdere keren in de GTFS data stond.

### Toekomst
Inmiddels is er een derde nog niet publieke smaak van GTFS uit het integratiesysteem _stat_.
In deze variant wordt alle openbaar vervoer data volledig opnieuw geïntegreerd, om het zo ver mogelijk plat te slaan.
In plaats van de logische haltes die vervoerders gebruiken, wordt een eenduidige koppeling gemaakt naar de fysieke infrastructuur.
De GTFS-RT voor deze data kan instantaan worden uitgeleverd, een inkomend KV6 of SIRI bericht geeft direct een update, er hoeft niet gewacht te worden op een tripUpdates.pb publicatie.

## Vragen

### Wanneer zou je GTFS moeten willen gebruiken?
GTFS is een defacto standaard en kan in veel reisplanners rechtstreeks worden gebruikt.
Ook wanneer je een consistent beeld wilt hebben over verschillende vervoerders heen is GTFS een goede platgeslagen manier om tegen een uniforme kwaliteit berekeningen te doen.
GTFS is een CSV formaat en laat zich perfect inladen in een relationele database, dus ook voor statistische toepassingen een goede start.

### Wanneer zou je GTFS niet moeten gebruiken?
Je wilt meer leren over hoe het openbaar vervoer echt werkt en welke (bron)data wordt uitgewisseld om reisinformatie in goede banen te leiden.
GTFS is een afgeleide hiervan, het is heel geschikt om een reisplanner op te maken, maar het detailniveau is lager.
Wil je in de operatie iets met omlopen doen, echt weten wat een bus de hele dag gaat doen, dan kun je dat in NeTEx eenvoudig vinden, niet in GTFS.
Wil je in een reisplanner tonen dat een bepaald voertuig een toilet, wifi, etc. heeft het kan in NeTEx vastgelegd worden, maar dat hoeft het niet te zijn.
Voor ieder extra attribuut dat in NeTEx is vastgelegd zou je theoretisch een extra kolom in een tabel kunnen maken, of een nieuwe tabel introduceren.
Het voordeel van NeTEx: die structuren zijn allemaal al bedacht.

### Vallen GTFS en GTFS-RT onder het NDOVloket?
Nee.
In Nederland zijn de NeTEx en de historische BISON-koppelvlakken onderdeel van NDOV.
GTFS heeft daar altijd buiten gevallen.
Wel is de GTFS-publicatie opgenomen in het Nationaal Toegangspunt Mobiliteit (NTM). 

### Zijn er historische GTFS bestanden beschikbaar?
Ja.
Stichting OpenGeo heeft een volledige catalogus aan historische reisinformatie, waaronder ook GTFS bestanden.
Neem daarvoor contact op met het loket, afhankelijk van de toepassing kunnen daar kosten voor worden gerekend.
