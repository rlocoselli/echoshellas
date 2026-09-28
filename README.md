# Aletheia: Echoes of Hellas

<img width="256" alt="Aletheia owl-and-laurel emblem" src="ui/main/aletheia_emblem.png" />

An original co-operative top-down adventure set in a mythic Greece where the Thread of Truth has been cut. Explore sanctuaries, sea caves, labyrinths, and the agora as you solve puzzles together and confront the ideas behind each myth.

The opening now tells the story in three skippable chapters. New high-resolution sanctuary and hero illustrations frame the menus; in-game sprites keep their readable 16-pixel silhouettes while softer texture filtering, warmer firelight, grounded shadows, and a slimmer HUD update the play view.

## The heroes

- **Thalia**, Seeker of Aletheia — wisdom and the patient question.
- **Asteria**, Watcher of the Aegean — courage under uncertain skies.
- **Dorian**, Guardian of the Polis — justice in action.

## Campaign and artifacts

Four new scenario briefs—Delphi, Knossos, the Isles of Aeolus, and a haunted Agora—are defined in `content/hellas_campaign.json`. Core equipment is framed as the **Xiphos of Athena**, **Apollo’s Far-Sight**, **Hephaestus’ Firepot**, **Lamp of Diogenes**, and **Oracle’s Fragments**. Internal item IDs remain stable for existing maps and saves.

The four scenario briefs are narrative plans, not yet four new playable maps.

## Checks

Run `node tests/content_check.js` for the prologue, campaign, visual assets, and Greek dialogue links. With Godot 3.3.2 installed, run `godot --path . -s res://tests/smoke.gd` to check that the main scenes and new artwork load. Both checks run in the Linux build workflow.

Aletheia is built with the open source Godot Engine. Git ignores generated Godot state and build outputs while retaining source maps and assets.

## Contributing

Please open an issue to discuss a bug, question, or proposed improvement before starting substantial work. Pull requests are welcome.
