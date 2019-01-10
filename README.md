> ⚠️ Questo repository è **deprecato**. È ora disponibile il nuovo IdP di test: https://github.com/italia/spid-testenv2

# SPID TEST ENVIRONMENT

[![](https://images.microbadger.com/badges/version/italia/spid-testenv-backoffice.svg)](https://microbadger.com/images/italia/spid-testenv-backoffice "Get your own version badge on microbadger.com") [![](https://images.microbadger.com/badges/image/italia/spid-testenv-backoffice.svg)](https://microbadger.com/images/italia/spid-testenv-backoffice "Get your own image badge on microbadger.com") [![](https://img.shields.io/github/issues/italia/spid-testenv.svg)](https://github.com/italia/spid-testenv/issues "Issue tracker")

SPID Test Environment è rivolto ai Service Provider che vogliono testare la propria integrazione con SPID senza avere a disposizione identità SPID reali.
Consiste in un Identity Provider da far girare in locale o su un proprio server, in cui si possono liberamente configurare delle identità di test.

L'ambiente si compone di due elementi:
* l'Identity Server vero e proprio, basato su [WSO2-is](https://github.com/wso2/product-is);
* un backoffice web basato su Node.js che offre un'interfaccia semplificata per la configurazione del Service Provider sull'IS e la creazione delle identità.

## Docker

Installazione `docker` e `docker-compose` su qualsiasi sistema (su Mac si può usare Docker for Mac), anche per windows è possibile utilizzare il docker facendo attenzione e permettendo le cartelle condivise.

### Configurazione alias

```
echo "127.0.0.1 spid-testenv-identityserver" | sudo tee -a /etc/hosts
```

Su Windows questo alias si può configurare in `%windir%\System32\drivers\etc\HOSTS`.

### Utilizzo del container

Avvio con `docker-compose` (non in background):

```bash
$ docker-compose up
```

Avvio in background con `docker-compose` (modalità detached):

```bash
$ docker-compose up -d
```

### Utilizzo dei container su OSX con docker-machine (non Docker for Mac)

La docker-machine standard non prevede un mapping automatico delle porte dall'host locale verso la docker-machine.
Si possono usare diverse tecniche, una delle quali è la seguende:

```
docker-machine ssh default -L 9443:localhost:9443
```

In questo modo viene creato un ssh port-forward dalla vm verso localhost, quindi sarà possibile accedere a `https://localhost:9443`

### Disponibilità del servizio

L'avvio può richiedere anche qualche minuto.
L'interfaccia di amministrazione dell'identity server sarà disponibile in https://localhost:9443/ (utente: admin, password: admin)
ma **non è necessario** aprirla poiché le attività di configurazione saranno disponibili su https://localhost:8080 (backoffice ad accesso libero).

## Uso del backoffice

### Configurazione di un Service Provider

Il primo passo è quello di configurare il proprio Service Provider nell'ambiente di test in modo che sia riconosciuto dall'Identity Provider (WSO2-is), proprio come si farebbe con la procedura di accreditamento presso SPID.
Dopo aver aperto il backoffice e riempito il form in tutte le sue parti è possibile vedere sulla destra l'anteprima dei metadati XML/SAML che descrivono il Service Provider. Si consiglia di scaricare il file XML prima di inviare il form poiché servirà anche nella configurazione del proprio Service Provider. Premendo il tasto "Salva" il Service Provider viene creato in WSO2-is.
È possibile eseguire successive modifiche ad un Service Provider esistente inviando nuovamente il modulo con l'entity ID e il nome invariati.

#### Nota importante per MacOS X

A causa di un bug di WSO2-is su MacOS X, per la creazione di un Service Provider è necessario seguire [il workaround qui descritto](https://github.com/italia/spid-testenv/issues/1#issuecomment-334537881).

### Creazione delle identità (utenti)

Per ciascun Service Provider configurato si può accedere alla lista degli utenti ed è possibile crearne di nuovi.
