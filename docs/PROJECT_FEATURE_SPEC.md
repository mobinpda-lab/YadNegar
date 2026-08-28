# YadNegar Project Feature — Product Contract

## Purpose
Project is a first-class grouping container for tracked tasks. It is **not a Tag**.

## Core product rules
- A Project contains zero or more tracked tasks.
- A tracked task may have zero or many FollowUps.
- A tracked task may have zero or one Project.
- FollowUps do not own a Project directly; they inherit context from their parent tracked task.
- Every tracked task keeps its existing optional multi-line description field, whether it has FollowUps or not.
- Project and Tag must remain separate concepts in data model, UI and future search/filter behavior.

## Project operations
From the Projects menu, user can add/edit title, choose/change color, and delete an empty Project.
A Project containing at least one tracked task MUST NOT be deleted. The protection is enforced outside the UI as well.

## Visual contract
Projects are shown as colored boxes/cards. Color is stable across restart and backup. Project context on task cards must not look like a Tag chip.

## Data contract
- Existing root tracked task + child FollowUp architecture remains unchanged.
- Project membership is stored only on root tracked tasks.
- Existing data remains readable after additive migration.
- Backup/Restore includes Projects and task Project membership.
- No second database or parallel Timeline store.

## Initial UX
- Projects entry in Home menu.
- Colored Project boxes with Add/Edit/Delete.
- Task create/edit can assign or clear a Project.
- Non-empty Project deletion is rejected.

## Explicit distinction from Tags
Project is a container/group with one optional membership per task in v1 and protected deletion when non-empty. Tag is an independent label/classification and may later support many labels per task.
