# Un poco de Python para hacer sorteos por Twitter

Puedes encontrar en Internet un montón de consejos sobre como organizar un sorteo por Twitter, aplicaciones para hacerlo (en su mayoría de pago) y las bondades de este tipo de acciones de marketing.

Nosotros simplemente queríamos sortear una entrada sin invertir mucho tiempo en el proceso y [difundir que queremos contratar para desarrollo](http://icarto.es/2019/09/buscamos-una-persona-para-aumentar-nuestro-equipo-de-desarrollo-de-software/).

En este artículo mostramos rápido y sucio como obtener los identificadores de la gente que hizo retweet para poder sortear entre ellos y escoger uno al azar. Hace tiempo que no jugamos con Twitter así que la primera cuestión es si Twitter sigue teniendo una API que nos permita obtener esta información de forma sencilla.

Una vista rápida a Duckduckgo que acaba en [StackOverflow](https://stackoverflow.com/questions/6316899/how-to-get-a-list-of-all-retweeters-in-twitter) más un vistazo al [índice de endpoints](https://developer.twitter.com/en/docs/api-reference-index) nos dice que hay un par de posibles APIs para obtener los datos:

-   [GET statuses/retweeters/ids](https://developer.twitter.com/en/docs/tweets/post-and-engage/api-reference/get-statuses-retweeters-ids) que sería exactamente lo que necesitamos. Pero que devuelve un máximo de 100 usuarios. Y tampoco nos da información que podría ser útil, como la hora del retweet.
-   [GET statuses/retweets/:id](https://developer.twitter.com/en/docs/tweets/post-and-engage/api-reference/get-statuses-retweets-id) parecida a la anterior nos da el retweet en sí del que podemos sacar al usuario. Pero de nuevo está limitado a un máximo de 100 retweets.
-   [GET statuses/mentions_timeline](https://developer.twitter.com/en/docs/tweets/timelines/api-reference/get-statuses-mentions_timeline)> que es un poco más compleja de usar y también tiene límites aunque mayores. Además sólo funciona para el id que esté logueado, lo que complica un poco la autenticación.

Visto esto, la mejor alternativa parece la API de ids de retweets. Si vemos que nos aproximamos al límite podemos hacer la petición periódicamente y luego filtrar. O en caso de problemas hacer fallback a la API de menciones o usarla como _double check_.

La cuestión ahora es que necesitamos para usarla. Generalmente estos servicios obligan a obtener algún tipo de cuenta de desarrollo, generar tokens, ... La documentación (introductoria) es "extensa" para un usuario ocasional que simplemente quiera hacer un par de llamadas a la API. Pero el resumen es que es necesario [solicitar una cuenta de desarrollo](https://developer.twitter.com/en/docs/basics/apps/overview) autenticándose en https://developer.twitter.com, y pulsando en _Create an app_. Si por algún motivo teníamos una cuenta antigua con acceso a la API podemos reusar el API Key de nuestra antigua aplicación. Si no tendremos que pinchar el _Apply_, y rellenar un cuestionario no pequeño, que incluye rellenar un texto de un mínimo de 200 palabras, y otros cuatro de al menos 100 palabras. Vamos, que de nuevo no está pensando para el usuario ocasional. Así que en nuestro caso reutilizamos una API Key creada hace tiempo.

Entrando a la aplicación concreta hay una pestaña _Keys and tokens_ donde nos encontraremos una _API key_ y una _API secret key_. Según lo que queramos hacer con las key [necesitaremos obtener un _bearer token_ o un _user access token_](https://developer.twitter.com/en/docs/basics/authentication/overview/oauth). En nuestro caso sólo consultaremos información pública, al menos mientras no usemos la API de menciones con lo que sólo necesitamos el [_bearer token_](https://developer.twitter.com/en/docs/basics/authentication/guides/bearer-tokens).

La forma más sencilla de probar la API es mediante una utilidad de línea de comandos creada por Twitter llamada [Twurl](https://developer.twitter.com/en/docs/tutorials/using-twurl).

Pero hacerlo en Python tampoco es complicado. Podríamos usar alguna librería adicional para gestionar la autenticación pero para algo tan sencillo podemos hacerlo a mano, simplemente usando [requests](https://2.python-requests.org/en/master/) y sin plugins.

El código que lidia con la autenticación es tan sencillo como esto, donde a partir de _API_KEY_ y _API_SECRET_KEY_ (definidos en otro sitio) obtenemos un _bearer token_ y construiremos el _header HTTP_ que tendremos que usar en el resto de peticiones.

```python
def get_auth_headers(access_token=None):
    if not access_token:
        access_token = get_bearer_token()
    # TODO. It should be b64 encoded
    headers = {"Authorization": f"Bearer {access_token}"}
    return headers


def get_bearer_token():
    auth = (API_KEY, API_SECRET_KEY)
    endpoint = "https://api.twitter.com/oauth2/token"
    data = {"grant_type": "client_credentials"}
    r = requests.post(endpoint, data=data, auth=auth)
    r.raise_for_status()
    access_token = r.json().get("access_token")
    return access_token
```

Obtener los retweets y construir una lista de diccionarios con sólo la información de interés también son sólo unas pocas líneas.

```python
def get_retweets(t_id, headers):
    endpoint = f"https://api.twitter.com/1.1/statuses/retweets/{t_id}.json"
    params = {"count": 100, "trim_user": False}
    r = requests.get(endpoint, params=params, headers=headers)
    r.raise_for_status()
    retweets = [
        {
            "created_at": retweet["created_at"],
            "id_str": retweet["id_str"],
            "user_id_str": retweet["user"]["id_str"],
            "user_name": retweet["user"]["name"],
            "user_screen_name": retweet["user"]["screen_name"],
        }
        for retweet in r.json()
    ]
    return retweets
```

Y escoger de forma aleatoria uno de los elementos de la lista es todavía más sencillo:

```
selected_retweet = random.choice(unique_retweets)
```

El script completo con el resto de boilerplate y ejecutable desde consola está en este mismo repo.
