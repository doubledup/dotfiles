# Jira Comment

Post a comment to a Jira ticket.

**Arguments:** $ARGUMENTS

The first argument is a Jira ticket key (e.g., `GLUE-2067`). If not provided, ask for one. Any text after the key is treated as raw input for the comment — skip straight to drafting.

---

## Steps

1. Fetch the ticket using cloud ID `sft.atlassian.net` to confirm it exists and understand the context (summary, description, status). If the ticket is not found, tell the user and stop.
2. If no raw input was provided in the arguments, ask what the comment should cover — the user may paste Slack messages, describe the update, or provide raw notes
3. Draft the comment in markdown:
   - First-person, concise, no corporate fluff — sentence fragments are fine
   - Mirror the user's wording and tone from their input
   - Include links where provided
   - Use backticks for technical identifiers
   - For Slack pastes: summarise into a single coherent update, strip noise, preserve key attributions
4. Show the draft and ask for approval or changes. If changes requested, revise and repeat until approved.
5. Post the comment to the ticket
6. Confirm with a link to the ticket browse page (not a comment permalink)
