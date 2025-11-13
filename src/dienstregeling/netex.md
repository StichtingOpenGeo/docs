# NeTEx
## Wat is NeTEx
Network Timetable Exchange is een Europese technische specificatie om infrastructuur, dienstregelingen en tarieven uit te wisselen.
Als je niet bij NS of EBS werkt spreek je het uit als Net-tex, als je daar wel werkt: welkom bij onze club. 
De standaard is gebaseerd op Transmodel, een conceptueel datamodel dat beschrijft hoe concepten zich naar elkaar verhouden, maar geen zelfstandige implementatie is.
Alle objecten uit NeTEx staan in Transmodel, maar Transmodel beschrijft niet welke attributen een object moet hebben.
NeTEx is geimplementeerd in XML Schema, een manier om de structuur van een XML bestand te beschrijven, af te dwingen en te kunnen valideren.

Als standaard is NeTEx het beste te beschrijven als een ontologie, een woordenboek met grammaticaregels.
NeTEx beschrijft dat er een relatie kan zijn tussen een rit en een voertuigsoort en met welk attribuut die relatie moet worden gemaakt, maar dat leidt niet automatisch tot software dat in staat is om automatisch naar die _foreign key_ toe te gaan om dat element te benaderen.

## NeTEx in de Nederlandse Context
NeTEx is extreem uitgebreid het is om meerdere reden ondoenlijk om een "volledige NeTEx implementatie te maken".
Binnen NeTEx kun je hetzelfde probleem op meerdere manieren oplossen.
Er zijn afspraken gemaakt hoe een bepaald concept wordt beschreven.
We noemen die afspraken: een profiel.
In Nederland is er een Nederlands NeTEx profiel, in Frankrijk het Franse Profiel, in Italie is het Italiaanse Profiel, in Zwitserland het Zwitserse Profiel, in Noorwegen en Zweden het Nordic Profiel en in Duitsland: VDV462.

![Just keep smiling](https://imgs.xkcd.com/comics/standards.png "How standards proliferate")

...binnen Europa hebben we trouwens het European Passenger Information Profile (EPIP) en het European Passenger Information Accessibility Profile (EPIAP).

Geen van de voorgenoemde profielen kan worden verwerkt met software die een ander profiel geeft geimplementeerd.
Daarom hebben we in Nederland dus ook [eigen documentatie](https://bison.dova.nu/standaarden/nl-netex-nederlands-netex-profiel).

## Programmeren met een XML Schema als basis
XML Schema geeft de mogelijkheid om code te genereren.
Dit kan code zijn om een document te parsen en binnen de programmeertaal rechtstreeks in objecten te benaderen.
Goede resultaten zijn te halen met Java en Python.
Ondanks dat C# een zeer efficiente manier heeft om XML te verwerken, blijkt veelvuldig dat het XML Schema van NeTEx (extreem) complex is en dat het model genereren vanuit het XML Schema niet lukt.
De andere optie: vanuit een bestaand XML-bestand werkt wel, maar dat is valsspelen.
De complexiteit ontstaat door workarounds in NeTEx zodat middels XML Schema toch _multiple inheritance_ toegepast kan worden.
Een tweede complexiteit ligt in het fenomeen _repeated compound fields_.
In een dienstregeling willen we een rit laten lopen langs haltes en andere belangrijke punten die de tijd kennen.
Een halte heeft de klasse `ScheduledStopPoint`, een belangrijkpunt is een `TimingPoint`.
Het afdwingen dat `ScheduledStopPoint` of `TimingPoint` in een lijst kunnen voorkomen, leidt tot een definitie als `list[ScheduledStopPoint|TimingPoint]`.
Sommige programmeertalen kunnen deze definitie niet maken en moeten daarom terugvallen tot `list[Any]`.
Daarmee moet je zowel tijdens het programmeren als in runtime gaan aftasten wat je binnen krijgt, dat is zeer ongewenst en leidt tot fouten.

### Wat moet je zeker niet moet doen
XML zou je nooit met de hand moeten willen parsen.
Kom niet in de verleiding om zelf een parser te schrijven, of met hier en daar een XPath-query elementen te selecteren.
De kracht van een XML Schema is nu juist dat je binnen een programmeertaal de object definities hebt en kunt toepassen alsof je een object bewerkt.

### Wat werkt wel
Na ruim tien jaar NeTEx ontwikkeling kan ik ook zeggen dat het, zonder superieure C# XML technieken, nooit gaat lukken om een XML van meerdere gigabytes groot in een keer te openen en te verwachten dat je daar binnen het genot van random-access hebt.
Maar misschien heb jij inmiddels wel een systeem met een hoeveelheid RAM, waar dat geen pijn meer doet om zo'n XML bestand in een Document Object Model te openen.
Mijn ervaring is dat je voor het lezen van NeTEx het beste uit kan gaan van een SAX-parser waar je op basis van bekende elementnamen objecten incrementeel omzet.
Zo'n incrementele manier zou ook met XPath toegepast kunnen worden, waar het dan aan schort is overerving.
Bepaalde bovenliggende attributen kunnen iets zeggen over iets wat niet er onder is gematerialiseerd.
Middels SAX loop je over alle elementen heen, middels XPath selecteer je alleen de voor jou relevante elementen.
