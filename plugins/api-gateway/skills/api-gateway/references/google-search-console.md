# Google Search Console

Last checked: 2026-09-29, from the provider definition and Google's API docs; not yet run against the live gateway.

## App key

`google-search-console`. Host: `https://www.googleapis.com/webmasters`, so paths start at `/v3/...`.

## Reads

```bash
# the sites the user can access
api https://gateway.daho.ai/google-search-console/v3/sites

# search performance: top queries for a date range
api -X POST -H 'Content-Type: application/json' \
  -d '{"startDate":"2026-09-01","endDate":"2026-09-28","dimensions":["query"],"rowLimit":10}' \
  "https://gateway.daho.ai/google-search-console/v3/sites/https%3A%2F%2Fexample.com%2F/searchAnalytics/query"

# submitted sitemaps
api "https://gateway.daho.ai/google-search-console/v3/sites/https%3A%2F%2Fexample.com%2F/sitemaps"
```

The `searchAnalytics/query` call is a `POST` but only reads data.

## Writes and risks

- `PUT /v3/sites/{siteUrl}` adds a site to the account; `DELETE /v3/sites/{siteUrl}` removes it.
- `PUT /v3/sites/{siteUrl}/sitemaps/{feedpath}` submits a sitemap; `DELETE` removes one.

Ask the user before any of these.

## Notes

- `siteUrl` must be percent-encoded. A URL-prefix property looks like `https%3A%2F%2Fexample.com%2F`; a domain property looks like `sc-domain%3Aexample.com`. Use a value exactly as returned by `GET /v3/sites`.
- Search data is delayed by a few days; ask for date ranges that end a few days ago.
