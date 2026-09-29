# Stripe

Last checked: 2026-09-29, from the provider definition and Stripe's API docs; not yet run against the live gateway.

## App key

`stripe-api-key`. Host: `https://api.stripe.com`. Auth is the stored Stripe key. DAHO injects the `stripe-context` header from the connection's settings: **do not send it yourself.**

## Reads

```bash
api https://gateway.daho.ai/stripe-api-key/v1/balance
api "https://gateway.daho.ai/stripe-api-key/v1/customers?limit=5"
api "https://gateway.daho.ai/stripe-api-key/v1/charges?limit=5"
api "https://gateway.daho.ai/stripe-api-key/v1/subscriptions?limit=5&status=active"
api "https://gateway.daho.ai/stripe-api-key/v1/invoices?limit=5"
```

## Writes and risks

This app moves money. Every write needs the user's explicit approval naming the customer, the amount and the currency:

- refunds (`POST /v1/refunds`), charges and payment intents, payouts (`POST /v1/payouts`);
- creating, changing or cancelling subscriptions; deleting customers, coupons or products;
- creating invoices and sending them to customers.

Prefer test-mode data when the user says the key is a test key. Do not retry a failed payment call before checking the current state with a read.

## Notes

- `POST` bodies are form-encoded: send `Content-Type: application/x-www-form-urlencoded` with `key=value&...`, not JSON.
- Pagination: `has_more` is true when there is another page; pass the last object's id as `starting_after`.
- Amounts are in the smallest currency unit (cents), so 1999 is 19.99.
