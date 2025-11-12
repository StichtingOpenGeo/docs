# Verbinden met ZeroMQ

De meeste datafeeds van het NDOV Loket zijn ontsloten via het [ZeroMQ](https://zeromq.org/) protocol.
Dit protocol maakt het mogelijk om een PubSub verbinding op te zetten, zodat je data automatisch gepusht krijgt zonder constant zelf nieuwe data op te hoeven halen.
Voor deze basis tutorial zullen we gebruik maken van de programmeertaal Python met de [PyZMQ](https://github.com/zeromq/pyzmq) library.

Allereerst moeten we er voor zorgen dat Python en PyZMQ geïnstalleerd zijn.
In deze tutorial doen we dit via de package manager `uv`, maar dit kan ook met een andere package manager naar keuze.

1. Volg de installatiestappen van [uv](https://docs.astral.sh/uv/getting-started/installation/) voor jouw besturingssysteem.

2. Installeer Python via uv en maak een project:
```
uv python install --default
uv init ndovzeromq
cd ndovzeromq
```

3. Installeer vervolgens de PyZMQ library:
```
uv add pyzmq
```

4. Open `main.py` in een code editor naar keuze. Vervang de standaard code met onderstaande code-snippet:

```python
#!/usr/bin/env python3

# Imports
from gzip import GzipFile
from io import BytesIO
import time
import zmq

# Maak de nieuwe subscriber socket aan
context = zmq.Context()
subscriber = context.socket(zmq.SUB)

# Verbind met NDOV Loket
subscriber.connect("{SERVER}")

# Vertel de server welke data je allemaal wil ontvangen.
# `/` is een wildcard die er voor zorgt dat je alle data ontvangt.
subscriber.setsockopt_string(zmq.SUBSCRIBE, "/")

# Ontvang alle data en loop door de nieuwe berichten
while True:
    multipart = subscriber.recv_multipart()

    # Berichten ontstaan uit 2 delen, het adres en de inhoud
    address = multipart[0].decode('UTF-8')

    # Om dataverkeer te besparen wordt alle inhoud gecomprimeerd met gzip,
    # dit moeten we dus handmatig decomprimeren
    try:
        contents = b''.join(multipart[1:])
        contents = GzipFile('','r',0,BytesIO(contents)).read()
        contents = contents.decode('UTF-8')

        # Print de tijd, het adres en de inhoud naar je terminal
        print(int(time.time()), address, contents)

    except UnicodeDecodeError:
        print("Error bij decoderen")
        raise
        pass
    except:
        print("Error bij decomprimeren")
        raise
        pass


# Sluit de verbinding netjes af
subscriber.close()
context.term()
```

5. Vervang `{SERVER}` door de gewenste ZeroMQ server:

| Datafeed                | Adres                                     | Doel                                                     |
|-------------------------|-------------------------------------------|----------------------------------------------------------|
| BISON KV6 / KV15 / KV17 | tcp://pubsub.besteffort.ndovloket.nl:7658 | Verschillende bus-tram-metro data                        |
| BISON KV7/8 Turbo       | tcp://pubsub.besteffort.ndovloket.nl:7817 | Geplande en actuele reisinformatie bus-tram-metro        |
| NS InfoPlus             | tcp://pubsub.besteffort.ndovloket.nl:7664 | Verschillende trein data                                 |
| SIRI                    | tcp://pubsub.besteffort.ndovloket.nl:7666 | Nieuwe standaard voor geplande en actuele reisinformatie |

> Voor gebruikers die deze databronnen in productie willen gebruiken is een aparte versie beschikbaar met een SLA.
> Neem contact op met het loket om hier toegang tot te krijgen.

> **Let op**: voor NDOV gebruikers is maximaal *één* actieve verbinding per datafeed toegestaan.
> Om meerdere projecten te ontsluiten kunnen datafeeds lokaal herdistribueert worden via [universal-sub-pubsub](https://github.com/StichtingOpenGeo/universal).

6. Start het Python script:

```
uv run main.py
```

Als de verbinding succesvol is ontvang je nu alle berichten op de gekozen ZeroMQ server.

Krijg je fouten in je terminal? In onze [Discord](https://discord.gg/gGjdt7uWQ) kunnen we je vast verder helpen.
