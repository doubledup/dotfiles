# David Dunn: Communication Style Reference

## 1. Register and channel

Professional-casual across the board, never stiff, contractions used freely. PR descriptions and
review comments sit at similar formality: explanatory but efficient, like walking a colleague
through a change rather than writing documentation. Slack drops further in ceremony for peer-to-peer
exchanges and status updates (terse, sometimes one or two words), but tightens back up into
structured, numbered questions when addressing a manager or an external technical contact.

## 2. Directness and hedging

Factual and root-cause statements are flat declaratives with no hedging, often bolded at the
lead-in. Disagreement is rare; when it appears he states a firm preference, then offers an explicit
non-blocking offramp rather than digging in. Uncertainty is named plainly in one clause and left
there ("I can't recall that, I'll defer to you") rather than diluted across a paragraph. In Slack,
quick decisions are fully direct with no cushioning ("No, keep him"), while diagnostic guesses
follow a hedge-then-act pattern. Self-correction and ownership are explicit and undefensive. Praise
in conversation is short, usually one line, and almost always paired with an ask or caveat rather
than standing alone; a `praise:` review comment stands on its own. A combative, un-resolving
disagreement does not occur.

## 3. PR and review conventions

PR descriptions follow the repo's template and are typically Claude-drafted rather than
hand-written, so the heading skeleton and testing-done depth are a repo convention to follow, not a
personal voice signal. Review-comment labels and decorations (nitpick, issue, issue (blocking),
suggestion, question, praise, etc.) follow the Conventional Comments format
(conventionalcomments.org) rather than being a personal quirk; apply them without treating them as
distinctive voice. What is personal: non-blocking feedback gets routed away from the thread rather
than relitigated, either to a follow-up ticket or cited as "discussed offline"; approvals aren't
held hostage to open nits; large PRs get flagged for proactive splitting before any code-level
feedback; disagreement states a firm preference, then offers a concrete non-blocking offramp rather
than digging in.

## 4. Voice fingerprints

Suggestions follow a deliberate three-tier softness gradient: "Let's" as the default, "Could we" for
a softer ask, "Should we" for a genuinely open question. Numbered lists carry tradeoffs and
multi-part questions in both PRs and Slack. No em dashes; hyphens and colons do that work instead.
Emoji use is sparse and always singular. Humor is dry, understated, and timing-based, and a soft
"haha" opener sometimes precedes a substantive correction.

## 5. Phrases to avoid

Stock phrasing that reads as AI-generated never appears; plain words do the job. Headings name their
content flatly ("Finished in Sprint 19", "Open risks"), not through idiom ("What landed", "What
could bite"). Avoid:

- Inflated words: delve, leverage, utilize, robust, seamless, streamline, empower, unlock, elevate,
  harness, landscape, journey
- Signposting and filler: "It's worth noting", "Importantly", "Notably", "Let's dive in", "Here's
  the thing", "In summary"
- Contrast framing: "It's not X, it's Y", "not just X but Y"
- Triplets of adjectives or clauses added for rhythm, and closing lines that restate the body
