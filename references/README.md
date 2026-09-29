# Per-app guides

One page per app DAHO has configured. The `app` value in the URL is the integration key shown in `GET /_/apps`. Every page says when it was last checked and against what; until the user's live smoke test passes, none of them has been run against the live gateway, so treat examples as starting points and confirm with a small read call first.

If an app has no page, read the provider's official API docs and start with read calls.

| App key | What it is | Guide |
|---|---|---|
| `google` | Gmail, Drive, Calendar and other Google APIs on `www.googleapis.com` | [google](google.md) |
| `google-ads` | Google Ads campaigns and reporting | [google-ads](google-ads.md) |
| `google-analytics` | Google Analytics (limited: see the guide) | [google-analytics](google-analytics.md) |
| `google-search-console` | Search performance and sitemaps | [google-search-console](google-search-console.md) |
| `google-my-business` | Google Business Profile accounts (limited) | [google-my-business](google-my-business.md) |
| `hubspot` | CRM: contacts, companies, deals | [hubspot](hubspot.md) |
| `linkedin` | LinkedIn profile and posts | [linkedin](linkedin.md) |
| `twitter-v2` | X (Twitter) API v2 | [twitter-v2](twitter-v2.md) |
| `facebook` | Facebook Graph API (Pages) | [facebook](facebook.md) |
| `anaella` | Anaella social scheduling | [anaella](anaella.md) |
| `openai` | OpenAI API (models, completions) | [openai](openai.md) |
| `openai-admin` | OpenAI organization admin (usage, costs, projects) | [openai-admin](openai-admin.md) |
| `resend` | Resend transactional email | [resend](resend.md) |
| `stripe-api-key` | Stripe payments | [stripe-api-key](stripe-api-key.md) |
| `apify` | Apify actors and datasets | [apify](apify.md) |
| `builtwith` | BuiltWith technology lookups | [builtwith](builtwith.md) |

## Adding a page

Copy an existing page, keep the four headings (`## App key`, `## Reads`, `## Writes and risks`, `## Notes`) and the `Last checked:` line, add a row above, then run `scripts/validate.sh`. Only state what you checked against the provider's definition, its official docs, or the live gateway.
