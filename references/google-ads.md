# Google Ads

Last checked: 2026-09-29, from the provider definition and Google's API docs; not yet run against the live gateway. The API version in the paths (`v20`) is the one assumed when this was written: if a call answers 404 for the version, use the current version from Google's Ads API release notes.

## App key

`google-ads`. Host: `https://googleads.googleapis.com`.

DadConnect injects the `developer-token` and `login-customer-id` headers from the connection's settings. **Do not send them yourself.**

## Reads

```bash
# which customer accounts the user can access
api https://gateway.daho.ai/google-ads/v20/customers:listAccessibleCustomers

# campaigns of one customer (a search query is a read even though it is a POST)
api -X POST -H 'Content-Type: application/json' \
  -d '{"query":"SELECT campaign.id, campaign.name, campaign.status FROM campaign ORDER BY campaign.id LIMIT 20"}' \
  https://gateway.daho.ai/google-ads/v20/customers/1234567890/googleAds:search

# performance for the last 7 days
api -X POST -H 'Content-Type: application/json' \
  -d '{"query":"SELECT campaign.name, metrics.impressions, metrics.clicks, metrics.cost_micros FROM campaign WHERE segments.date DURING LAST_7_DAYS"}' \
  https://gateway.daho.ai/google-ads/v20/customers/1234567890/googleAds:search
```

## Writes and risks

Anything under `.../customers/{id}/...:mutate` changes the account: creating or pausing campaigns, editing budgets and bids, adding keywords. **These spend or redirect real advertising money.** Get the user's explicit approval naming the customer, campaign, and the exact change before any `:mutate` call.

## Notes

- Customer ids are digits only, no dashes (`123-456-7890` becomes `1234567890`).
- Money fields are in micros: `cost_micros` 1,500,000 is 1.50 in the account currency.
- Use `pageToken` and `nextPageToken` from the response for more rows.
- Google Ads Query Language (GAQL) has its own syntax; check Google's docs before writing a query.
