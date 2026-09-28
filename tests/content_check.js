const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");

const root = path.resolve(__dirname, "..");
const readJson = (file) => JSON.parse(fs.readFileSync(path.join(root, file), "utf8"));
const exists = (file) => fs.existsSync(path.join(root, file));

const story = readJson("content/prologue.json");
assert.ok(Array.isArray(story.pages) && story.pages.length >= 3, "The opening needs at least three story beats");
for (const page of story.pages) {
  assert.ok(typeof page.title === "string" && page.title.trim(), "Each page needs a title");
  assert.ok(typeof page.text === "string" && page.text.trim().length >= 40, "Each page needs substantial story text");
}
assert.equal(new Set(story.pages.map((page) => page.title)).size, story.pages.length);

const campaign = readJson("content/hellas_campaign.json");
assert.equal(campaign.heroes.length, 3);
assert.equal(new Set(campaign.heroes.map((hero) => hero.id)).size, campaign.heroes.length);
assert.ok(campaign.scenarios.length >= 4);
for (const scenario of campaign.scenarios) {
  assert.ok(scenario.id && scenario.setting && scenario.objective && scenario.philosophical_question);
}

for (const asset of [
  "ui/main/hellas_sanctuary_hd.png",
  "ui/options/hero_lineup_hd.png",
  "ui/main/aletheia_emblem.png",
  "entities/player/chain.png",
  "entities/player/knot.png",
  "entities/player/key.png",
]) {
  assert.ok(exists(asset), `Missing visual asset: ${asset}`);
}

const dialogueFiles = [
  "sign_dungeon", "sign_shrine", "sign_village", "sign_danger_village",
  "npc_oldman_blacksmith", "npc_boy_overworld",
].map((name) => `dialogue/${name}.json`).concat([
  "dialogue/acquisition/acquire_bombs.json",
  "dialogue/acquisition/acquire_bow.json",
  "dialogue/acquisition/acquire_lantern.json",
  "dialogue/acquisition/acquire_spirit_pearl.json",
]);

for (const file of dialogueFiles) {
  const dialogue = readJson(file);
  assert.ok(Array.isArray(dialogue.Nodes) && dialogue.Nodes.length, `${file}: empty dialogue`);
  const ids = new Set(dialogue.Nodes.map((node) => node.id));
  assert.equal(ids.size, dialogue.Nodes.length, `${file}: duplicate node ID`);
  for (const node of dialogue.Nodes) {
    assert.ok(node.text && node.text.trim(), `${file}: empty dialogue line`);
    const links = [node.next_id, ...(node.choices || []).map((choice) => choice.next_id)];
    for (const link of links) {
      assert.ok(link === -1 || ids.has(link), `${file}: broken link from ${node.id} to ${link}`);
    }
  }
}

console.log(`Content OK: ${story.pages.length} prologue pages, ${campaign.scenarios.length} scenario briefs, ${dialogueFiles.length} dialogues`);
