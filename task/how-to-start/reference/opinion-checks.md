Before recommending, check for relevant context that changes the recommendation:

- **Matching spec exists** -> "You have docs/specs/{topic}.md. /tdd to build it, or /spec to revise scope?"
- **Open concerns on this topic** -> "C-{id} is related: '{description}'. Resolve first or build around it?"
- **No project docs + recommended skill is project-layer** (check-in, wrapup, reorient, buildout, migrate) -> "No project setup detected. /setup first?"
- **No project docs + recommended skill is task-layer** -> skip this opinion. Task skills work standalone. Don't suggest setup when someone just wants to fix a bug.
- **Active Workflow exists** -> "You're in Phase {n} of /{workflow}. /check-in to resume?"
- **Topic matches a concern type:question** -> "There's an open question about this (C-{id}). Worth resolving before building."

State the opinion in one sentence. Don't lecture.
