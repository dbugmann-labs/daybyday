/**
 * The artifact budgets of ADR-1047, in the one place both checks read them from.
 *
 * These numbers exist twice on purpose: as prose in `openspec/config.yaml`'s `rules`, where
 * `spec-author` reads them while drafting, and as integers here, where `check:budgets` measures
 * what was actually written. The OpenSpec CLI never parses `rules` back out, so the prose cannot
 * be executed and the integers cannot be read by an agent — neither copy can stand in for the
 * other. What used to be missing was anything noticing when the two drifted apart;
 * `check:config` now asserts each number below still appears in the rule that states it.
 *
 * So this module is the source of truth for the integer, and `openspec/config.yaml` is the
 * source of truth for the wording. Change a budget in both, or `check:config` says so.
 */

/** `proposal.md`, in lines. */
export const PROPOSAL_LINES_MAX = 60

/** `design.md`, in lines. */
export const DESIGN_LINES_MAX = 150

/** `tasks.md`, in lines, on top of one line per scenario. */
export const TASKS_BASE_LINES = 80

/** A delta requirement's prose, in words — the upper bound. */
export const REQUIREMENT_WORDS_MAX = 150

/** A delta requirement's prose, in words — below this it is "thin", not merely small. */
export const REQUIREMENT_WORDS_THIN = 40
