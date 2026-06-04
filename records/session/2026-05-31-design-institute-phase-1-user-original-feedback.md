# Phase 1 Design-Institute Review Request - User Original Feedback

Date: 2026-05-31

## Purpose

This file is for design-institute / technical-lead review. It includes the customer's original text and must be treated as primary acceptance evidence.

Important: the customer / 甲方 is the current user interacting with Codex. The quoted text below is the user's original wording, not a Codex paraphrase.

## Review Request

Please review the Phase 1 shielding manual-acceptance feedback and provide technical/product direction for the remaining gaps.

Acceptance package:

- `phase-1-prebuild.26680259984`

Current gate state:

- Android runtime smoke: green from prior evidence.
- Startup / no white screen: user reports pass.
- Manual acceptance: not green.
- Technical-lead review: pending.
- 甲方验收: not green because the 甲方 reported issues below.

## Customer Original Text

```text
1.同样的包我装过了所以当然没问题，但是上一个commit跟这个commit还是冲突状态 2.没闪退没白 3.up主改变的还是不对，屏蔽用户关键词means，针对用户这个分类下，屏蔽所有用户id里带这个词的操作，但是目前的系统，把用户名当作普通关键词的一种，不满意，而且，我希望是在piliplus上游的那种长按卡片有显示封面的方式魔改，目前的不够美观，但是有屏蔽uid的选项这个对了 6.相关视频也生效了，但是标签屏蔽没有作用，我期望的是标签屏蔽的效果在推荐流生效，但是程序似乎没有这样的读取，请问是逻辑问题吗？推荐流不识别视频的标签，所以是不点进去不识别吗？need factcheck 7.有用了，但是是同样的问题，上游的屏蔽功能和新增的屏蔽系统同时在生效，不需要这样，上游的功能合并到这个屏蔽系统里 8.可以，但是我需要设置也的分类页，方便整理 9.可以 10.也可以
```

## Questions For Design Institute / Technical Lead

1. UP user keyword semantics:
   - User expects "屏蔽用户关键词" to belong to the user category and match user identifiers / user-related fields, not be stored as a generic content keyword.
   - Please define the accepted model: UID exact match, username keyword match, and whether "user id contains keyword" is required.

2. Card long-press UX:
   - User wants a PiliPlus-upstream-style long-press card interaction that keeps / shows the cover preview and looks better.
   - Please decide whether this is required for Phase 1 acceptance or a follow-up UX task.

3. Recommendation-feed tag shielding:
   - User expects tag shielding to affect recommendation feed.
   - Please fact-check whether recommendation-feed items expose usable tag data before entering the detail page.
   - If recommendation payloads do not contain tags, decide whether tag rules should be unavailable in recommendation feed, use category / tname fallback, or fetch detail data.

4. Legacy upstream shielding integration:
   - User reports both upstream legacy shielding and the new shielding system are active.
   - User wants upstream shielding merged into the new shielding system instead of duplicated behavior.
   - Please decide migration direction and Phase 1 scope.

5. Settings organization:
   - User wants categorized pages in shielding settings for easier organization.
   - Please decide required categories and whether this blocks Phase 1.

## Current Codex Interpretation

- Startup and runtime gates are not the blocker now.
- Manual acceptance remains failed / incomplete due to semantics, tag behavior, UX, legacy-system duplication, and settings organization.
- Do not mark Phase 1 green until the customer confirms the revised behavior.
