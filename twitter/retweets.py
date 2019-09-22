#!/usr/bin/env python3.6

import argparse
import datetime
import json
import random
from pathlib import Path

import requests


# Fill here or in the cli
API_KEY = ""
API_SECRET_KEY = ""


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


def get_retweeters(t_id, headers):
    endpoint = "https://api.twitter.com/1.1/statuses/retweeters/ids.json"
    params = {"id": t_id, "count": 100, "stringify_ids": True}
    r = requests.get(endpoint, params=params, headers=headers)
    r.raise_for_status()
    retweeters = r.json().get("ids")
    return retweeters


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


def write_to_disk(t_id, retweets):
    n = datetime.datetime.now().isoformat()
    filename = f"{t_id}_{n}.json"
    with open(filename, "w") as f:
        json.dump(retweets, f, indent=4, sort_keys=True)


def get_unique_retweets_from_disk(t_id):
    full_list = []
    for filename in Path.cwd().rglob(f"{t_id}_*.json"):
        with filename.open() as f:
            full_list.extend(json.load(f))

    # idiom to build a list of unique dicts from a list of repeated dicts
    uniq_list = [dict(s) for s in set(frozenset(d.items()) for d in full_list)]
    uniq_list_id = [l["id_str"] for l in uniq_list]
    # just a check
    assert len([l for l in full_list if l["id_str"] not in uniq_list_id]) == 0
    return uniq_list


def main(t_id):
    headers = get_auth_headers()
    retweets = get_retweets(t_id, headers)
    return retweets


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Get Retweets of a Tweet")
    parser.add_argument("tweet_id", help="Id of the tweet")
    parser.add_argument("--api-key", help="API key", default=globals().get("API_KEY"))
    parser.add_argument(
        "--api-secret-key",
        help="API secret key",
        default=globals().get("API_SECRET_KEY"),
    )
    args = parser.parse_args()

    # TODO. Maybe a bit hacky how KEYs are handled, but it is convenient
    API_KEY = args.api_key or ""
    API_SECRET_KEY = args.api_secret_key or ""
    tweet_id = args.tweet_id

    retweets = main(tweet_id)
    write_to_disk(tweet_id, retweets)
    unique_retweets = get_unique_retweets_from_disk(tweet_id)
    selected_retweet = random.choice(unique_retweets)
    print(selected_retweet)
