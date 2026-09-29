# DAHO API Gateway skill

Let an AI agent use the apps you have connected in DAHO (Gmail, Google Ads, HubSpot, Stripe, Resend and more) with one API key and plain HTTP. The skill teaches the agent to discover what is connected, call it, and stay safe: read first, ask before writing, never expose the key.

## What you need

1. A DAHO account with your apps connected in the portal: https://portal.auth.daho.ai
2. An API key: portal, **API keys**, **Create key**. Copy it once (it is shown only once).
3. The key in the agent's environment, not in the chat. Typing `export DAHO_API_KEY=...` puts it in your shell history, so read it silently instead (or use a secrets manager):

```bash
read -rs DAHO_API_KEY && export DAHO_API_KEY
```

## Install

**Claude Code**

```bash
claude plugin marketplace add dahoai/api-gateway-skill
claude plugin install api-gateway@daho-plugins
```

**Agents that support the Skills CLI** (Claude Code, Cursor, Codex and others):

```bash
npx skills add dahoai/api-gateway-skill
```

**Any other agent that reads `SKILL.md` skills:** copy `SKILL.md` and the `references/` folder into the agent's skills directory as `api-gateway/`.

From a local clone, use the clone's path instead of `dahoai/api-gateway-skill` in the Claude Code commands.

## Try it

Ask the agent: "Using the api-gateway skill, list which apps are connected." It should call `GET https://gateway.daho.ai/_/apps` and report the result without printing your key.

## What the agent can and cannot do

- It can call any app shown as `connected` by `GET /_/apps`, using that app's own API.
- It cannot connect apps or create keys; you do that in the portal.
- Some providers have APIs on hosts the gateway does not reach (for example the Google Analytics Data API); the per-app guides say so.
- It is asked to make read calls first and to get your explicit approval before any write, send, delete or spend. The gateway itself does not block writes: a key can do anything the connected app allows, so keep keys short-lived, revoke ones you no longer use, and only give a key to agents you trust.

A `daho` CLI and local MCP server ([`@dahoai/cli`](https://github.com/dahoai/cli), `npx -y @dahoai/cli mcp`) can also use the same key; the skill works without them.

## Network access

The skill needs outbound HTTPS to `gateway.daho.ai`. In sandboxed products (Claude Desktop and similar) add `gateway.daho.ai` to the allowed domains.

## For maintainers

`SKILL.md` and `references/` are the source of truth. After editing them run:

```bash
sh scripts/build-plugin.sh     # refresh the Claude Code plugin copy
sh scripts/validate.sh         # structure, links, secrets, drift
sh tests/validate.test.sh      # the validator's own tests
```

Reference pages must only state what was checked against the provider's definition, its official docs, or the live gateway, and carry a `Last checked:` line.

## License

MIT
