# X (Twitter) API v2

Last checked: 2026-09-29, from the provider definition and X's API docs; not yet run against the live gateway. Availability of each endpoint depends on the X API plan tier of the connected app.

## App key

`twitter-v2`. Host: `https://api.twitter.com`. Auth is the user's X OAuth grant.

## Reads

```bash
api https://connect-api.daho.ai/twitter-v2/2/users/me
api "https://connect-api.daho.ai/twitter-v2/2/users/USER_ID/tweets?max_results=5&tweet.fields=created_at,public_metrics"
api "https://connect-api.daho.ai/twitter-v2/2/tweets/search/recent?query=from%3Aexample&max_results=10"
```

## Writes and risks

- `POST /2/tweets` publishes a public post as the user. `DELETE /2/tweets/{id}` removes one.
- Likes, reposts, follows and direct messages act publicly or contact people.

Show the user the exact text and get a clear yes first. A published post cannot be fully recalled.

## Notes

- Rate limits are tight and per endpoint; on `429` wait for the reset time in the response headers.
- Search and some read endpoints may be unavailable on lower plan tiers (`403`).
- Pagination: `meta.next_token`, sent back as `pagination_token`.
